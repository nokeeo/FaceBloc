// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.md, included with
// this project.

#import "FBLCEditorViewController.h"

#import <Vision/Vision.h>

#import "FBLCActivityViewController.h"
#import "FBLCCGUtils.h"
#import "FBLCEditorBottomNavigationView.h"
#import "FBLCFeatureDetector.h"
#import "FBLCGeometryOverlayView.h"
#import "FBLCImage.h"
#import "FBLCImageGeometryData.h"
#import "FBLCImageGraphicsRenderer.h"
#import "FBLCImageView.h"
#import "FBLCImageViewController.h"
#import "FBLCPath.h"
#import "FBLCPhotoLibraryService.h"
#import "FBLCRenderingOptions.h"
#import "FBLCStrokeWidthIndicatorLayer.h"
#import "LocalizationIDs.h"
#import "UIView+AutoLayout.h"
#import "UIViewController+NSError.h"

/** The width of the stroke width slider. */
static const CGFloat kDrawSliderWidth = 135;

/** The distance from the top of the stroke width slider and the top edge of the screen. */
static const CGFloat kDrawSliderTopPadding = 30;

/** The padding between the stroke width slider and the trailing edge of the screen. */
static const CGFloat kDrawSliderHorizontalPadding = 8;

/** The minimum value of the stroke width slider. */
static const CGFloat kDrawSliderMinimumValue = 0.05;

/** The maximum value of the stroke width slider. */
static const CGFloat kDrawSliderMaximumValue = 0.9;

/** The value of the stroke width slider upon initialization. */
static const CGFloat kDrawSliderInitialValue = 0.1;

/** The time in seconds of the animation to display the stroke width slider and its indicator. */
static const NSTimeInterval kStrokeWidthIndicatorAnimationDuration = 0.4;

/** The core animation key for animating the opacity of a layer. */
static NSString *const kOpacityAnimationKey = @"opacity";

/** Creates the slider that represents the width of the draw brush. */
static UISlider *CreateDrawSlider() {
  UISlider *slider = [[UISlider alloc] init];
  slider.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI / 2);
  slider.minimumValue = kDrawSliderMinimumValue;
  slider.maximumValue = kDrawSliderMaximumValue;
  slider.value = kDrawSliderInitialValue;

  return slider;
}

/** Maps the given stroke width slider value to stroke width. */
static CGFloat DrawSliderValueToStrokeWidth(CGFloat value) {
  if (value < 0.75) {
    return value / 2.f;
  } else {
    return 2 * (value - 0.75) + (value / 2.f);
  }
}

/** Returns the core animation for hiding and showing the stroke width indicator. */
static CAAnimation *StrokeWidthIndicatorAnimation(BOOL hidden) {
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:kOpacityAnimationKey];
  animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
  animation.fromValue = hidden ? @(1) : @(0);
  animation.toValue = hidden ? @(0) : @(1);
  animation.duration = kStrokeWidthIndicatorAnimationDuration;

  return animation;
}

/** Returns the actions sheet item title for the given quality level. */
static NSString *SaveActionTitleForQualityLevel(FBLCSavePhotoQuality quality) {
  switch (quality) {
    case FBLCSavePhotoQualityFull:
      return NSLocalizedString(FBLCSaveQualityFullTitle, nil);
    case FBLCSavePhotoQualityLarge:
      return NSLocalizedString(FBLCSaveQualityHighTitle, nil);
    case FBLCSavePhotoQualityMedium:
      return NSLocalizedString(FBLCSaveQualityMediumTitle, nil);
    case FBLCSavePhotoQualitySmall:
      return NSLocalizedString(FBLCSaveQualityLowTitle, nil);
  }
}

@implementation FBLCEditorViewController {
  /** The view controller for displaying a FBLCImage */
  FBLCImageViewController *_imageViewController;
  
  /** The view that contains controls that sits at the bottom of the screen. */
  FBLCEditorBottomNavigationView *_bottomNavigationView;

  /** The object that processes a given image and returns the @c CGRect of all detected faces. */
  FBLCFeatureDetector *_featureDetector;

  /** The object that saves given photos to disk. */
  FBLCPhotoLibraryService *_photoService;

  /** The view that renders geometry data over an image. */
  FBLCGeometryOverlayView *_geometryOverlayView;

  /** An array of paths previously drawn by the user. */
  NSArray<FBLCPath *> *_previousTouchPaths;
  
  /** The current path being drawn by the user. */
  FBLCMutablePath *_touchPath;

  /** The slider that indicates the stroke width of the draw tool. */
  UISlider *_drawWidthSlider;

  /**
   * The layer that is a visual representation of the stroke width. Is hidden by default and only displayed when the
   * draw slider's value changes.
   */
  FBLCStrokeWidthIndicatorLayer *_strokeIndicatorLayer;
  
  /**
   * The layer that overlays most views and other layers and when displayed applies a dimming effect to all view beneath
   * it. Is hidden by default.
   */
  CALayer *_imageDimmingLayer;

  /** The image this object was initialized with. */
  FBLCImage *_image;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _featureDetector = [[FBLCFeatureDetector alloc] init];
    _photoService = [[FBLCPhotoLibraryService alloc] init];
    _previousTouchPaths = [NSArray array];
    _touchPath = [[FBLCMutablePath alloc] init];
  }

  return self;
}

- (instancetype)initWithImage:(FBLCImage *)image {
  self = [self initWithNibName:nil bundle:nil];
  if (self) {
    _image = image;
  }

  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  UIView *view = self.view;

  _imageViewController = [[FBLCImageViewController alloc] initWithImage:_image];
  _imageViewController.delegate = self;
  UIView *imageView = _imageViewController.view;
  imageView.translatesAutoresizingMaskIntoConstraints = NO;
  [self addChildViewController:_imageViewController];
  [view addSubview:_imageViewController.view];
  [_imageViewController didMoveToParentViewController:self];

  _geometryOverlayView = [[FBLCGeometryOverlayView alloc] init];
  _geometryOverlayView.translatesAutoresizingMaskIntoConstraints = NO;
  [_imageViewController.imageView.contentView addSubview:_geometryOverlayView];
  [_imageViewController.imageView fblc_addConstraints:[_geometryOverlayView fblc_constraintsAttachedToSuperviewEdges]];

  _imageDimmingLayer = [[CALayer alloc] init];
  _imageDimmingLayer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.65].CGColor;
  _imageDimmingLayer.hidden = YES;
  [view.layer addSublayer:_imageDimmingLayer];

  _strokeIndicatorLayer = [[FBLCStrokeWidthIndicatorLayer alloc] initWithNormalStrokeWidth:0 zoomLevel:0];
  _strokeIndicatorLayer.hidden = YES;
  [view.layer addSublayer:_strokeIndicatorLayer];

  _bottomNavigationView = [[FBLCEditorBottomNavigationView alloc] init];
  _bottomNavigationView.translatesAutoresizingMaskIntoConstraints = NO;
  _bottomNavigationView.delegate = self;
  [view addSubview:_bottomNavigationView];

  [view fblc_addConstraints:[imageView fblc_constraintsAttachedToSuperviewEdges]];

  _drawWidthSlider = CreateDrawSlider();
  [_drawWidthSlider addTarget:self action:@selector(drawSliderDidChange:) forControlEvents:UIControlEventValueChanged];
  [_drawWidthSlider addTarget:self
                       action:@selector(drawSliderDidTouchUp:)
             forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
  _touchPath.strokeWidth = DrawSliderValueToStrokeWidth(_drawWidthSlider.value);
  [view addSubview:_drawWidthSlider];

  FBLCEdgeConstraints *bottomNavigationEdgeConstraints =
      [_bottomNavigationView fblc_constraintsAttachedToSuperviewEdges];
  [view addConstraints:@[
    bottomNavigationEdgeConstraints.leading,
    bottomNavigationEdgeConstraints.bottom,
    bottomNavigationEdgeConstraints.trailing,
  ]];

  self.view.backgroundColor = UIColor.blackColor;
  [self setIsDrawingEnabled:[_bottomNavigationView isDrawingEnabled] animated:NO];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];

  CGRect safeAreaRect = UIEdgeInsetsInsetRect(self.view.bounds, self.view.safeAreaInsets);
  CGFloat bottomNavigationHeight = CGRectGetHeight(_bottomNavigationView.frame);
  _imageViewController.additionalSafeAreaInsets = UIEdgeInsetsMake(0, 0, bottomNavigationHeight, 0);

  // Layout draw slider.
  CGSize sliderIntrinsicSize = _drawWidthSlider.intrinsicContentSize;
  CGSize sliderSize = CGSizeMake(kDrawSliderWidth, sliderIntrinsicSize.height);
  CGRect sliderBounds = _drawWidthSlider.bounds;
  sliderBounds.size = sliderSize;

  // The slider has 90 degree rotation transform applied.  Width is height and height is width.
  CGFloat sliderCenterX = CGRectGetMaxX(safeAreaRect) - kDrawSliderHorizontalPadding - (floor(sliderSize.height) / 2.f);
  CGFloat sliderCenterY = CGRectGetMinY(safeAreaRect) + kDrawSliderTopPadding + (floor(sliderSize.width) / 2.f);

  _drawWidthSlider.bounds = sliderBounds;
  _drawWidthSlider.center = CGPointMake(sliderCenterX, sliderCenterY);

  // Center the layer in the image rect.
  _strokeIndicatorLayer.frame =
      UIEdgeInsetsInsetRect(_imageViewController.view.bounds, _imageViewController.view.safeAreaInsets);
  _imageDimmingLayer.frame = self.view.bounds;
}

#pragma mark - FBLCEditorBottomNavigationViewDelegate

- (void)editorBottomNavigationView:(FBLCEditorBottomNavigationView *)editorBottomNavigationView
          didChangeFaceObfuscation:(BOOL)shouldFaceObfuscate {
  _geometryOverlayView.renderingOptions = [self createRenderingOptionsWithTargetSize:_geometryOverlayView.bounds.size];
}

- (void)editorBottomNavigationView:(FBLCEditorBottomNavigationView *)editorBottomNavigationView
                  didEnableDrawing:(BOOL)enabled {
  [self setIsDrawingEnabled:enabled animated:YES];
}

- (void)editorBottomNavigationViewDidCancelEditing:(FBLCEditorBottomNavigationView *)bottomNavigationView {
  [_delegate editorViewControllerDidCancelEditing:self];
}

- (void)editorBottomNavigationViewDidTapSaveButton:(FBLCEditorBottomNavigationView *)bottomNavigationView {
  [self showSaveQualityActionSheet];
}

#pragma mark - FBLCImageViewControllerDelegate

- (void)imageViewController:(FBLCImageViewController *)viewController didLoadImage:(UIImage *)image {
  FBLCActivityViewController *activityIndicatorViewController = [[FBLCActivityViewController alloc] init];

  __weak FBLCActivityViewController *weakActivityIndicatorViewController = activityIndicatorViewController;
  [self presentViewController:activityIndicatorViewController
                     animated:YES
                   completion:^{
                     __weak __typeof__(self) weakSelf = self;
                     [self->_featureDetector
                         detectFeaturesForImage:image
                                  dispatchQueue:dispatch_get_main_queue()
                                     completion:^(NSArray<VNDetectedObjectObservation *> *_Nullable observations,
                                                  NSError *_Nullable error) {
                                       [weakActivityIndicatorViewController dismissViewControllerAnimated:YES
                                                                                               completion:nil];
                                       [weakSelf handleFacialFeatureDetectionForImage:image
                                                                         observations:observations
                                                                                error:error];
                                     }];
                   }];
}
#pragma mark - UIResponder

- (BOOL)canHandleTouches {
  return _bottomNavigationView.drawingEnabled;
}

- (void)handleTouchesUpdate:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  UITouch *touch = touches.allObjects.firstObject;
  CGPoint touchPoint = [touch locationInView:_geometryOverlayView];

  CGPoint normalizedPoint = FBLCNormalizePoint(touchPoint, _geometryOverlayView.bounds.size);
  [_touchPath addPoint:normalizedPoint];

  FBLCImageGeometryData *currentGeometry = _geometryOverlayView.geometry;
  NSMutableArray<FBLCPath *> *obfuscationPaths = [_previousTouchPaths mutableCopy];
  [obfuscationPaths addObject:_touchPath];
  FBLCImageGeometryData *newGeometry =
      [FBLCImageGeometryData geometryWithFaceObservations:currentGeometry.faceObservations
                                         obfuscationPaths:obfuscationPaths];

  _geometryOverlayView.geometry = newGeometry;
}

- (void)handleTouchesEnd:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [self handleTouchesUpdate:touches withEvent:event];
  _previousTouchPaths = _geometryOverlayView.geometry.obfuscationPaths;
  _touchPath = [[FBLCMutablePath alloc] init];
  _touchPath.strokeWidth = DrawSliderValueToStrokeWidth(_drawWidthSlider.value);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  if (![self canHandleTouches]) {
    [super touchesBegan:touches withEvent:event];
    return;
  }
  [self handleTouchesUpdate:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  if (![self canHandleTouches]) {
    [super touchesMoved:touches withEvent:event];
    return;
  }
  [self handleTouchesUpdate:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  if (![self canHandleTouches]) {
    [super touchesEnded:touches withEvent:event];
    return;
  }
  [self handleTouchesEnd:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  if (![self canHandleTouches]) {
    [super touchesCancelled:touches withEvent:event];
    return;
  }
  [self handleTouchesEnd:touches withEvent:event];
}

#pragma mark - Target Actions

- (void)drawSliderDidChange:(UISlider *)sender {
  // TODO: Show some indication that the slider has changed value.
  CGFloat normalizedStrokeWidth = DrawSliderValueToStrokeWidth(_drawWidthSlider.value);
  _touchPath.strokeWidth = normalizedStrokeWidth;
  [_strokeIndicatorLayer setNormalStrokeWidth:normalizedStrokeWidth
                                    zoomLevel:_imageViewController.imageView.zoomScale
                                    imageSize:_imageViewController.imageView.image.size];
  [self showStrokeWidthIndicator];
}

- (void)drawSliderDidTouchUp:(UISlider *)slider {
  [self hideStrokeWidthIndicator];
}

#pragma mark - Private Methods

/**
 * Returns an alert action associated with the given quality level. When the action is selected, the current image is
 * saved to the photo library.
 */
- (UIAlertAction *)alertActionForQualityLevel:(FBLCSavePhotoQuality)quality {
  __weak __typeof__(self) weakSelf = self;
  return [UIAlertAction actionWithTitle:SaveActionTitleForQualityLevel(quality)
                                  style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *_Nonnull action) {
                                  [weakSelf saveCurrentImageToPhotosLibraryForQuality:quality];
                                }];
}

/** Is called when the feature detector has finished processing the given image. */
- (void)handleFacialFeatureDetectionForImage:(UIImage *)image
                                observations:(nullable NSArray<VNDetectedObjectObservation *> *)observations
                                       error:(nullable NSError *)error {
  if (error || !observations) {
    // TODO: Handle error.
    return;
  }

  FBLCImageGeometryData *geometryData = [FBLCImageGeometryData geometryWithFaceObservations:observations obfuscationPaths:nil];
  _geometryOverlayView.geometry = geometryData;
}

/** Creates the rending options with the given target render size. */
- (FBLCRenderingOptions *)createRenderingOptionsWithTargetSize:(CGSize)targetSize {
  return [FBLCRenderingOptions optionsWithTargetSize:targetSize
                                  shouldObscureFaces:_bottomNavigationView.shouldObscureFaces];
}

/** Sets drawing UI to enabled or disabled. */
- (void)setIsDrawingEnabled:(BOOL)isDrawingEnabled animated:(BOOL)animated {
  // Disable interaction on the image view controller to propagate the touch events up to this object.
  _imageViewController.view.userInteractionEnabled = !isDrawingEnabled;

  CGFloat drawSliderAlpha = [self->_bottomNavigationView isDrawingEnabled] ? 1 : 0;
  [UIView animateWithDuration:kStrokeWidthIndicatorAnimationDuration
                   animations:^{
                     self->_drawWidthSlider.alpha = drawSliderAlpha;
                   }];
}

/**
 * Shows the action sheet that allows the user to select the quality of image to save. Upon selected an option, the
 * image is save to the photo library.
 */
- (void)showSaveQualityActionSheet {
  NSString *title = NSLocalizedString(FBLCSaveQualityActionSheetTitle, nil);
  NSString *subtitle = NSLocalizedString(FBLCSaveQualityActionSheetSubtitle, nil);
  UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:title
                                                                       message:subtitle
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
  [actionSheet addAction:[self alertActionForQualityLevel:FBLCSavePhotoQualityFull]];
  [actionSheet addAction:[self alertActionForQualityLevel:FBLCSavePhotoQualityLarge]];
  [actionSheet addAction:[self alertActionForQualityLevel:FBLCSavePhotoQualityMedium]];
  [actionSheet addAction:[self alertActionForQualityLevel:FBLCSavePhotoQualitySmall]];
  [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(FBLCSaveQualityCancelTitle, nil)
                                                  style:UIAlertActionStyleCancel
                                                handler:nil]];

  [self presentViewController:actionSheet animated:YES completion:nil];
}

/** Saves the current editing image to the user photo library. */
- (void)saveCurrentImageToPhotosLibraryForQuality:(FBLCSavePhotoQuality)quality {
  FBLCActivityViewController *activityViewController = [[FBLCActivityViewController alloc] init];
  [self presentViewController:activityViewController
                     animated:YES
                   completion:^{
                     FBLCImage *image = self->_imageViewController.image;
                     FBLCPhotoLibraryService *photoService = self->_photoService;
                     FBLCImageGeometryData *geometry = self->_geometryOverlayView.geometry;
                     __weak __typeof__(self) weakSelf = self;
                     dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                       UIImage *sourceImage = [image imageOfType:FBLCImageTypeSource options:nil];
                       FBLCImageGraphicsRenderer *renderer = [[FBLCImageGraphicsRenderer alloc] init];
                       FBLCRenderingOptions *options = [weakSelf createRenderingOptionsWithTargetSize:sourceImage.size];
                       UIImage *outputImage = [renderer renderImage:sourceImage geometry:geometry options:options];
                       [photoService savePhotoToLibrary:outputImage
                                                quality:quality
                                                  queue:dispatch_get_main_queue()
                                             completion:^(NSError *_Nullable error) {
                                               [weakSelf handlePhotoSaveResponse:outputImage
                                                                           error:error
                                                          activityViewController:activityViewController];
                                             }];
                     });
                   }];
}

/** Is called when the photo service image has attempted to save an image to disk. */
- (void)handlePhotoSaveResponse:(UIImage *)image
                          error:(nullable NSError *)error
         activityViewController:(UIViewController *)activityViewController {
  NSAssert([NSThread isMainThread], @"%@ must be run on the main thread.", NSStringFromSelector(_cmd));
  [activityViewController dismissViewControllerAnimated:YES
                                             completion:^{
                                               if (error) {
                                                 [self fblc_presentError:error];
                                               } else {
                                                 [self->_delegate editorViewController:self
                                                        didFinishEditingWithFinalImage:image];
                                               }
                                             }];
}

/** Displays the stroke width indicator with animations. */
- (void)showStrokeWidthIndicator {
  if (!_strokeIndicatorLayer.hidden) {
    return;
  }

  _strokeIndicatorLayer.hidden = NO;
  _imageDimmingLayer.hidden = NO;
  [_strokeIndicatorLayer addAnimation:StrokeWidthIndicatorAnimation(/*hidden=*/NO) forKey:kOpacityAnimationKey];
  [_imageDimmingLayer addAnimation:StrokeWidthIndicatorAnimation(/*hidden=*/NO) forKey:kOpacityAnimationKey];
  _strokeIndicatorLayer.opacity = 1;
  _imageDimmingLayer.opacity = 1;
}

/** Hides the stroke width indicator with animations. */
- (void)hideStrokeWidthIndicator {
  if (_strokeIndicatorLayer.hidden) {
    return;
  }

  [CATransaction begin];
  [CATransaction setCompletionBlock:^{
    self->_strokeIndicatorLayer.hidden = YES;
    self->_imageDimmingLayer.hidden = YES;
  }];
  [_strokeIndicatorLayer addAnimation:StrokeWidthIndicatorAnimation(/*hidden=*/YES) forKey:kOpacityAnimationKey];
  [_imageDimmingLayer addAnimation:StrokeWidthIndicatorAnimation(/*hidden=*/YES) forKey:kOpacityAnimationKey];
  _strokeIndicatorLayer.opacity = 0;
  _imageDimmingLayer.opacity = 0;
  [CATransaction commit];
}

@end
