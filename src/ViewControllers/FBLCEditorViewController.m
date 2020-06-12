// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.txt, included with
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
#import "UIViewController+NSError.h"
#import "UIView+AutoLayout.h"

static const CGFloat kDrawSliderWidth = 135;
static const CGFloat kDrawSliderTopPadding = 30;
static const CGFloat kDrawSliderHorizontalPadding = 8;

static const CGFloat kDrawSliderMinimumValue = 0.05;
static const CGFloat kDrawSliderMaximumValue = 0.9;
static const CGFloat kDrawSliderInitialValue = 0.1;

static const NSTimeInterval kStrokeWidthIndicatorAnimationDuration = 0.4;

static NSString *const kOpacityAnimationKey = @"opacity";

static UISlider *CreateDrawSlider() {
  UISlider *slider = [[UISlider alloc] init];
  slider.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI / 2);
  slider.minimumValue = kDrawSliderMinimumValue;
  slider.maximumValue = kDrawSliderMaximumValue;
  slider.value = kDrawSliderInitialValue;
  
  return slider;
}

static CGFloat DrawSliderValueToStrokeWidth(CGFloat value) {
  if (value < 0.75) {
    return value / 2.f;
  } else {
    return 2 * (value - 0.75) + (value / 2.f);
  }
}

static CAAnimation *StrokeWidthIndicatorAnimation(BOOL hidden) {
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:kOpacityAnimationKey];
  animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
  animation.fromValue = hidden ? @(1) : @(0);
  animation.toValue = hidden ? @(0) : @(1);
  animation.duration = kStrokeWidthIndicatorAnimationDuration;
  
  return animation;
}

@implementation FBLCEditorViewController {
  FBLCImageViewController *_imageViewController;
  FBLCEditorBottomNavigationView *_bottomNavigationView;
  
  FBLCFeatureDetector *_featureDetector;
  
  UIImage *_originalImage;
  FBLCImageGeometryData *_imageMetadata;
  NSArray<UIBezierPath *> *_imagePaths;
  
  FBLCPhotoLibraryService *_photoService;
  
  FBLCGeometryOverlayView *_geometryOverlayView;
  
  NSArray<FBLCPath *> *_previousTouchPaths;
  FBLCMutablePath *_touchPath;
  
  NSURL *_imageURL;
  
  UISlider *_drawWidthSlider;
  
  FBLCStrokeWidthIndicatorLayer *_strokeIndicatorLayer;
  CALayer *_imageDimmingLayer;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _featureDetector = [[FBLCFeatureDetector alloc] init];
    _imagePaths = @[];
    _photoService = [[FBLCPhotoLibraryService alloc] init];
    _previousTouchPaths= [NSArray array];
    _touchPath = [[FBLCMutablePath alloc] init];
  }
  
  return self;
}

- (instancetype)initWithImageURL:(NSURL *)imageURL {
  self = [self initWithNibName:nil bundle:nil];
  if (self) {
    _imageURL = imageURL;
  }
  
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIView *view = self.view;
  
  FBLCImage *image = [[FBLCImage alloc] initWithURL:_imageURL];
  _imageViewController = [[FBLCImageViewController alloc] initWithImage:image];
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
  [_drawWidthSlider addTarget:self action:@selector(drawSliderDidTouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
  _touchPath.strokeWidth = DrawSliderValueToStrokeWidth(_drawWidthSlider.value);
  [view addSubview:_drawWidthSlider];
  
  FBLCEdgeConstraints *bottomNavigationEdgeConstraints = [_bottomNavigationView fblc_constraintsAttachedToSuperviewEdges];
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
  _strokeIndicatorLayer.frame = UIEdgeInsetsInsetRect(_imageViewController.view.bounds, _imageViewController.view.safeAreaInsets);
  _imageDimmingLayer.frame = self.view.bounds;
}

#pragma mark - FBLCEditorBottomNavigationViewDelegate

- (void)editorBottomNavigationView:(FBLCEditorBottomNavigationView *)editorBottomNavigationView didChangeFaceObfuscation:(BOOL)shouldFaceObfuscate {
  _geometryOverlayView.renderingOptions = [self createRenderingOptionsWithTargetSize:_geometryOverlayView.bounds.size];
}

- (void)editorBottomNavigationView:(FBLCEditorBottomNavigationView *)editorBottomNavigationView didEnableDrawing:(BOOL)enabled {
  [self setIsDrawingEnabled:enabled animated:YES];
}

- (void)editorBottomNavigationViewDidCancelEditing:(FBLCEditorBottomNavigationView *)bottomNavigationView {
  [_delegate editorViewControllerDidCancelEditing:self];
}

- (void)editorBottomNavigationViewDidTapSaveButton:(FBLCEditorBottomNavigationView *)bottomNavigationView {
  [self saveCurrentImageToPhotosLibrary];
}

#pragma mark - FBLCImageViewControllerDelegate

- (void)imageViewController:(FBLCImageViewController *)viewController didLoadImage:(UIImage *)image {
  __weak __typeof__(self) weakSelf = self;
  [_featureDetector detectFeaturesForImage:image dispatchQueue:dispatch_get_main_queue() completion:^(NSArray<VNDetectedObjectObservation *> * _Nullable observations, NSError * _Nullable error) {
    [weakSelf handleFacialFeatureDetectionForImage:image observations:observations error:error];
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
  FBLCImageGeometryData *newGeometry = [FBLCImageGeometryData geometryWithFaceObservations:currentGeometry.faceObservations obfuscationPaths:obfuscationPaths];
  
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
  [_strokeIndicatorLayer setNormalStrokeWidth:normalizedStrokeWidth zoomLevel:_imageViewController.imageView.zoomScale imageSize:_imageViewController.imageView.image.size];
  [self showStrokeWidthIndicator];
}

- (void)drawSliderDidTouchUp:(UISlider *)slider {
  [self hideStrokeWidthIndicator];
}

#pragma mark - Private Methods

- (void)handleFacialFeatureDetectionForImage:(UIImage *)image observations:(nullable NSArray<VNDetectedObjectObservation *> *)observations error:(nullable NSError *)error {
  if (error || !observations) {
    // TODO: Handle error.
    return;
  }
  
  _imageMetadata = [FBLCImageGeometryData geometryWithFaceObservations:observations obfuscationPaths:nil];
  _geometryOverlayView.geometry = _imageMetadata;
}

- (FBLCRenderingOptions *)createRenderingOptionsWithTargetSize:(CGSize)targetSize {
  return [FBLCRenderingOptions optionsWithTargetSize:targetSize shouldObscureFaces:_bottomNavigationView.shouldObscureFaces];
}

- (void)setIsDrawingEnabled:(BOOL)isDrawingEnabled animated:(BOOL)animated {
  // Disable interaction on the image view controller to propagate the touch events up to this object.
  _imageViewController.view.userInteractionEnabled = !isDrawingEnabled;
  
  CGFloat drawSliderAlpha = [self->_bottomNavigationView isDrawingEnabled] ? 1 : 0;
  [UIView animateWithDuration:kStrokeWidthIndicatorAnimationDuration animations:^{
    self->_drawWidthSlider.alpha = drawSliderAlpha;
  }];
}

- (void)saveCurrentImageToPhotosLibrary {
  FBLCActivityViewController *activityViewController = [[FBLCActivityViewController alloc] init];
  [self presentViewController:activityViewController animated:YES completion:^{
    FBLCImage *image = self->_imageViewController.image;
    FBLCPhotoLibraryService *photoService = self->_photoService;
    FBLCImageGeometryData *geometry = self->_geometryOverlayView.geometry;
    __weak __typeof__(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
      UIImage *sourceImage = [image imageOfType:FBLCImageTypeSource options:nil];
      FBLCImageGraphicsRenderer *renderer = [[FBLCImageGraphicsRenderer alloc] init];
      FBLCRenderingOptions *options = [weakSelf createRenderingOptionsWithTargetSize:sourceImage.size];
      UIImage *outputImage = [renderer renderImage:sourceImage geometry:geometry options:options];
      [photoService savePhotoToLibrary:outputImage queue:dispatch_get_main_queue() completion:^(NSError * _Nullable error) {
        [weakSelf handlePhotoSaveResponse:outputImage error:error activityViewController:activityViewController];
      }];
    });
  }];
}

- (void)handlePhotoSaveResponse:(UIImage *)image error:(nullable NSError *)error activityViewController:(UIViewController *)activityViewController {
  NSAssert([NSThread isMainThread], @"%@ must be run on the main thread.", NSStringFromSelector(_cmd));
  [activityViewController dismissViewControllerAnimated:YES completion:^{
    if (error) {
      [self fblc_presentError:error];
    } else {
      [self->_delegate editorViewController:self didFinishEditingWithFinalImage:image];
    }
  }];
}

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