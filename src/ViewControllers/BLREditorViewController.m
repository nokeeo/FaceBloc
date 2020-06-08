#import "BLREditorViewController.h"

#import <Vision/Vision.h>

#import "BLRActivityViewController.h"
#import "BLRCGUtils.h"
#import "BLREditorBottomNavigationView.h"
#import "BLRFeatureDetector.h"
#import "BLRGeometryOverylayView.h"
#import "BLRImageGeometryData.h"
#import "BLRImageView.h"
#import "BLRImageViewController.h"
#import "BLRPath.h"
#import "BLRPhotoLibraryService.h"
#import "BLRRenderingOptions.h"
#import "UIViewController+NSError.h"
#import "UIView+AutoLayout.h"

@implementation BLREditorViewController {
  BLRImageViewController *_imageViewController;
  BLREditorBottomNavigationView *_bottomNavigationView;
  
  BLRFeatureDetector *_featureDetector;
  
  UIImage *_originalImage;
  BLRImageGeometryData *_imageMetadata;
  NSArray<UIBezierPath *> *_imagePaths;
  
  BLRPhotoLibraryService *_photoService;
  
  BLRGeometryOverylayView *_geometryOverlayView;
  
  NSArray<UIBezierPath *> *_previousTouchPaths;
  BLRPath *_touchPath;
  
  NSURL *_imageURL;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _featureDetector = [[BLRFeatureDetector alloc] init];
    _imagePaths = @[];
    _photoService = [[BLRPhotoLibraryService alloc] init];
    _previousTouchPaths= [NSArray array];
    _touchPath = [[BLRPath alloc] init];
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
  
  _imageViewController = [[BLRImageViewController alloc] initWithImageURL:_imageURL];
  _imageViewController.delegate = self;
  UIView *imageView = _imageViewController.view;
  imageView.translatesAutoresizingMaskIntoConstraints = NO;
  [self addChildViewController:_imageViewController];
  [self.view addSubview:_imageViewController.view];
  [_imageViewController didMoveToParentViewController:self];
  
  _geometryOverlayView = [[BLRGeometryOverylayView alloc] init];
  _geometryOverlayView.translatesAutoresizingMaskIntoConstraints = NO;
  [_imageViewController.imageView.contentView addSubview:_geometryOverlayView];
  [_imageViewController.imageView blr_addConstraints:[_geometryOverlayView blr_constraintsAttachedToSuperviewEdges]];
  
  _bottomNavigationView = [[BLREditorBottomNavigationView alloc] init];
  _bottomNavigationView.translatesAutoresizingMaskIntoConstraints = NO;
  _bottomNavigationView.delegate = self;
  [self.view addSubview:_bottomNavigationView];
  
  UIView *view = self.view;
  [view blr_addConstraints:[imageView blr_constraintsAttachedToSuperviewEdges]];
  
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
  
  CGFloat bottomNavigationHeight = CGRectGetHeight(_bottomNavigationView.frame);
  _imageViewController.additionalSafeAreaInsets = UIEdgeInsetsMake(0, 0, bottomNavigationHeight, 0);
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
  CGPathRef newPathRef = _touchPath.CGPath;
  UIBezierPath *bezierPath = [UIBezierPath bezierPathWithCGPath:newPathRef];
  CGPathRelease(newPathRef);
  
  NSMutableArray<UIBezierPath *> *obfuscationPaths = [_previousTouchPaths mutableCopy];
  [obfuscationPaths addObject:bezierPath];
  BLRImageGeometryData *newGeometry = [BLRImageGeometryData geometryWithFaceObservations:currentGeometry.faceObservations obfuscationPaths:obfuscationPaths];
  
  _geometryOverlayView.geometry = newGeometry;
}

- (void)handleTouchesEnd:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [self handleTouchesUpdate:touches withEvent:event];
  _previousTouchPaths = _geometryOverlayView.geometry.obfuscationPaths;
  [_touchPath clear];
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
    UIImage *image = self->_imageViewController.imageView.image;
    __weak __typeof__(self) weakSelf = self;
    [self->_photoService savePhotoToLibrary:image queue:dispatch_get_main_queue() completion:^(NSError * _Nullable error) {
      [weakSelf handlePhotoSaveResponse:image error:error activityViewController:activityViewController];
    }];
  }];
}

- (void)handlePhotoSaveResponse:(UIImage *)image error:(nullable NSError *)error activityViewController:(UIViewController *)activityViewController {
  [activityViewController dismissViewControllerAnimated:YES completion:^{
    if (error) {
      [self blr_presentError:error];
    } else {
      [self->_delegate editorViewController:self didFinishEditingWithFinalImage:image];
    }
  }];
}

@end
