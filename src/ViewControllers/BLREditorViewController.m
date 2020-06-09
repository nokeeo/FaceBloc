#import "BLREditorViewController.h"

#import <Vision/Vision.h>

#import "BLRActivityViewController.h"
#import "BLRCGUtils.h"
#import "BLREditorBottomNavigationView.h"
#import "BLRFeatureDetector.h"
#import "BLRGeometryOverylayView.h"
#import "BLRImage.h"
#import "BLRImageGeometryData.h"
#import "BLRImageGraphicsRenderer.h"
#import "BLRImageView.h"
#import "BLRImageViewController.h"
#import "BLRPath.h"
#import "BLRPhotoLibraryService.h"
#import "BLRRenderingOptions.h"
#import "UIViewController+NSError.h"
#import "UIView+AutoLayout.h"

static const CGFloat kDrawSliderWidth = 135;
static const CGFloat kDrawSliderTopPadding = 30;
static const CGFloat kDrawSliderHorizontalPadding = 8;

static UISlider *CreateDrawSlider() {
  UISlider *slider = [[UISlider alloc] init];
  slider.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI / 2);
  slider.minimumValue = 0.0;
  slider.maximumValue = 0.5;
  slider.value = 0.1;
  
  return slider;
}

static CGFloat DrawSliderValueToStrokeWidth(CGFloat value) {
  if (value < 0.75) {
    return value / 2.f;
  } else {
    return 2 * (value - 0.75) + (value / 2.f);
  }
}

@implementation BLREditorViewController {
  BLRImageViewController *_imageViewController;
  BLREditorBottomNavigationView *_bottomNavigationView;
  
  BLRFeatureDetector *_featureDetector;
  
  UIImage *_originalImage;
  BLRImageGeometryData *_imageMetadata;
  NSArray<UIBezierPath *> *_imagePaths;
  
  BLRPhotoLibraryService *_photoService;
  
  BLRGeometryOverylayView *_geometryOverlayView;
  
  NSArray<BLRPath *> *_previousTouchPaths;
  BLRMutablePath *_touchPath;
  
  NSURL *_imageURL;
  
  UISlider *_drawWidthSlider;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _featureDetector = [[BLRFeatureDetector alloc] init];
    _imagePaths = @[];
    _photoService = [[BLRPhotoLibraryService alloc] init];
    _previousTouchPaths= [NSArray array];
    _touchPath = [[BLRMutablePath alloc] init];
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
  
  BLRImage *image = [[BLRImage alloc] initWithURL:_imageURL];
  _imageViewController = [[BLRImageViewController alloc] initWithImage:image];
  _imageViewController.delegate = self;
  UIView *imageView = _imageViewController.view;
  imageView.translatesAutoresizingMaskIntoConstraints = NO;
  [self addChildViewController:_imageViewController];
  [view addSubview:_imageViewController.view];
  [_imageViewController didMoveToParentViewController:self];
  
  _geometryOverlayView = [[BLRGeometryOverylayView alloc] init];
  _geometryOverlayView.translatesAutoresizingMaskIntoConstraints = NO;
  [_imageViewController.imageView.contentView addSubview:_geometryOverlayView];
  [_imageViewController.imageView blr_addConstraints:[_geometryOverlayView blr_constraintsAttachedToSuperviewEdges]];
  
  _bottomNavigationView = [[BLREditorBottomNavigationView alloc] init];
  _bottomNavigationView.translatesAutoresizingMaskIntoConstraints = NO;
  _bottomNavigationView.delegate = self;
  [view addSubview:_bottomNavigationView];
  
  [view blr_addConstraints:[imageView blr_constraintsAttachedToSuperviewEdges]];
  
  _drawWidthSlider = CreateDrawSlider();
  [_drawWidthSlider addTarget:self action:@selector(drawSliderDidChange:) forControlEvents:UIControlEventValueChanged];
  _touchPath.strokeWidth = DrawSliderValueToStrokeWidth(_drawWidthSlider.value);
  [view addSubview:_drawWidthSlider];
  
  BLREdgeConstraints *bottomNavigationEdgeConstraints = [_bottomNavigationView blr_constraintsAttachedToSuperviewEdges];
  [view addConstraints:@[
    bottomNavigationEdgeConstraints.leading,
    bottomNavigationEdgeConstraints.bottom,
    bottomNavigationEdgeConstraints.trailing,
  ]];
  
  self.view.backgroundColor = UIColor.blackColor;
  [self setIsDrawingEnabled:[_bottomNavigationView isDrawingEnabled]];
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
}

#pragma mark - BLREditorBottomNavigationViewDelegate

- (void)editorBottomNavigationView:(BLREditorBottomNavigationView *)editorBottomNavigationView didChangeFaceObfuscation:(BOOL)shouldFaceObfuscate {
  _geometryOverlayView.renderingOptions = [self createRenderingOptions];
}

- (void)editorBottomNavigationView:(BLREditorBottomNavigationView *)editorBottomNavigationView didEnableDrawing:(BOOL)enabled {
  [self setIsDrawingEnabled:enabled];
}

- (void)editorBottomNavigationViewDidCancelEditing:(BLREditorBottomNavigationView *)bottomNavigationView {
  [_delegate editorViewControllerDidCancelEditing:self];
}

- (void)editorBottomNavigationViewDidTapSaveButton:(BLREditorBottomNavigationView *)bottomNavigationView {
  [self saveCurrentImageToPhotosLibrary];
}

#pragma mark - BLRImageViewControllerDelegate

- (void)imageViewController:(BLRImageViewController *)viewController didLoadImage:(UIImage *)image {
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
  
  CGPoint normalizedPoint = BLRNormalizePoint(touchPoint, _geometryOverlayView.bounds.size);
  [_touchPath addPoint:normalizedPoint];
  
  BLRImageGeometryData *currentGeometry = _geometryOverlayView.geometry;
  NSMutableArray<BLRPath *> *obfuscationPaths = [_previousTouchPaths mutableCopy];
  [obfuscationPaths addObject:_touchPath];
  BLRImageGeometryData *newGeometry = [BLRImageGeometryData geometryWithFaceObservations:currentGeometry.faceObservations obfuscationPaths:obfuscationPaths];
  
  _geometryOverlayView.geometry = newGeometry;
}

- (void)handleTouchesEnd:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [self handleTouchesUpdate:touches withEvent:event];
  _previousTouchPaths = _geometryOverlayView.geometry.obfuscationPaths;
  _touchPath = [[BLRMutablePath alloc] init];
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
  _touchPath.strokeWidth = DrawSliderValueToStrokeWidth(_drawWidthSlider.value);
}

#pragma mark - Private Methods

- (void)handleFacialFeatureDetectionForImage:(UIImage *)image observations:(nullable NSArray<VNDetectedObjectObservation *> *)observations error:(nullable NSError *)error {
  if (error || !observations) {
    // TODO: Handle error.
    return;
  }
  
  _imageMetadata = [BLRImageGeometryData geometryWithFaceObservations:observations obfuscationPaths:nil];
  _geometryOverlayView.geometry = _imageMetadata;
}

- (BLRRenderingOptions *)createRenderingOptions {
  return [BLRRenderingOptions optionsWithShouldObscureFaces:_bottomNavigationView.shouldObscureFaces];
}

- (void)setIsDrawingEnabled:(BOOL)isDrawingEnabled {
  // Disable interaction on the image view controller to propegate the touch events up to this object.
  _imageViewController.view.userInteractionEnabled = !isDrawingEnabled;
}

- (void)saveCurrentImageToPhotosLibrary {
  BLRActivityViewController *activityViewController = [[BLRActivityViewController alloc] init];
  [self presentViewController:activityViewController animated:YES completion:^{
    BLRImage *image = self->_imageViewController.image;
    BLRPhotoLibraryService *photoService = self->_photoService;
    BLRImageGeometryData *geometry = self->_geometryOverlayView.geometry;
    BLRRenderingOptions *options = [self createRenderingOptions];
    __weak __typeof__(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
      UIImage *sourceImage = [image imageOfType:BLRImageTypeSource options:nil];
      BLRImageGraphicsRenderer *renderer = [[BLRImageGraphicsRenderer alloc] init];
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
      [self blr_presentError:error];
    } else {
      [self->_delegate editorViewController:self didFinishEditingWithFinalImage:image];
    }
  }];
}

@end
