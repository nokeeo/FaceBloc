#import "BLREditorViewController.h"

#import <Vision/Vision.h>

#import "BLREditorBottomNavigationView.h"
#import "BLRFeatureDetector.h"
#import "BLRImageMetadata.h"
#import "BLRImagePipeline.h"
#import "BLRImageView.h"
#import "BLRImageViewController.h"
#import "UIView+AutoLayout.h"

@implementation BLREditorViewController {
  BLRImageViewController *_imageViewController;
  BLREditorBottomNavigationView *_bottomNavigationView;
  
  BLRFeatureDetector *_featureDetector;
  BLRImagePipeline *_imagePipeline;
  
  UIImage *_originalImage;
  BLRImageMetadata *_imageMetadata;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _featureDetector = [[BLRFeatureDetector alloc] init];
    _imagePipeline = [[BLRImagePipeline alloc] init];
  }
  
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _imageViewController = [[BLRImageViewController alloc] init];
  _imageViewController.imageView.delegate = self;
  UIView *imageView = _imageViewController.view;
  imageView.translatesAutoresizingMaskIntoConstraints = NO;
  [self addChildViewController:_imageViewController];
  [self.view addSubview:_imageViewController.view];
  [_imageViewController didMoveToParentViewController:self];
  
  _bottomNavigationView = [[BLREditorBottomNavigationView alloc] init];
  _bottomNavigationView.translatesAutoresizingMaskIntoConstraints = NO;
  _bottomNavigationView.delegate = self;
  [self.view addSubview:_bottomNavigationView];
  
  UIView *view = self.view;
  [view blr_addConstraints:[imageView blr_constraintsAttachedToSuperviewEdges]];
  
  BLREdgeConstraints *edgeConstraints = [_bottomNavigationView blr_constraintsAttachedToSuperviewEdges];
  [view addConstraints:@[
    edgeConstraints.leading,
    edgeConstraints.bottom,
    edgeConstraints.trailing,
  ]];
  
  self.view.backgroundColor = UIColor.blackColor;
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  CGFloat bottomNavigationHeight = CGRectGetHeight(_bottomNavigationView.frame);
  _imageViewController.additionalSafeAreaInsets = UIEdgeInsetsMake(0, 0, bottomNavigationHeight, 0);
}

#pragma mark - Getters

- (UIImage *)image {
  return _imageViewController.imageView.image;
}

#pragma mark - Setters

- (void)setImage:(UIImage *)image {
  [self loadViewIfNeeded];
  __weak __typeof__(self) weakSelf = self;
  _originalImage = image;
  [_featureDetector detectFeaturesForImage:image dispatchQueue:dispatch_get_main_queue() completion:^(NSArray<VNDetectedObjectObservation *> * _Nullable observations, NSError * _Nullable error) {
    [weakSelf handleFacialFeatureDetectionForImage:image observations:observations error:error];
  }];
  _imageViewController.imageView.image = image;
}

#pragma mark - BLREditorBottomNavigationViewDelegate

- (void)editorBottomNavigationView:(BLREditorBottomNavigationView *)editorBottomNavigationView didChangeFaceObfuscation:(BOOL)shouldFaceObfuscate {
  // Triggers a re-rendering of the image.
  [self processImage:_originalImage metadata:_imageMetadata];
}

#pragma mark - BLRImageViewDelegate

- (void)imageView:(BLRImageView *)imageView didUpdatePath:(CGPathRef)path {
  UIBezierPath *bezierPath = [UIBezierPath bezierPathWithCGPath:path];
  _imageMetadata = [BLRImageMetadata metadataWithFaceObservations:_imageMetadata.faceObservations obfuscationPaths:@[bezierPath]];
  
  [self processImage:_originalImage metadata:_imageMetadata];
}

- (void)imageView:(BLRImageView *)imageView didFinishPath:(CGPathRef)path {
  // TODO: End path and append path.
}

#pragma mark - Private Methods

- (void)handleFacialFeatureDetectionForImage:(UIImage *)image observations:(nullable NSArray<VNDetectedObjectObservation *> *)observations error:(nullable NSError *)error {
  if (error || !observations) {
    // TODO: Handle error.
    return;
  }
  
  _imageMetadata = [BLRImageMetadata metadataWithFaceObservations:observations obfuscationPaths:nil];
  [self processImage:image metadata:_imageMetadata];
}

- (void)processImage:(UIImage *)image metadata:(BLRImageMetadata *)metadata {
  BLRImagePipelineOptions *options = [self createPipelineOptions];
  __weak __typeof__(self) weakSelf = self;
  [_imagePipeline processImage:image withMetaData:metadata options:options completion:^(UIImage * _Nonnull processedImage) {
    __typeof__(self) strongSelf = weakSelf;
    strongSelf->_imageViewController.imageView.image = processedImage;
  }];
}

- (BLRImagePipelineOptions *)createPipelineOptions {
  return [BLRImagePipelineOptions optionsWithShouldObscureFaces:_bottomNavigationView.shouldObscureFaces];
}

@end
