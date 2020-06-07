#import "BLREditorViewController.h"

#import <Vision/Vision.h>

#import "BLRActivityViewController.h"
#import "BLREditorBottomNavigationView.h"
#import "BLRFeatureDetector.h"
#import "BLRImageMetadata.h"
#import "BLRImagePipeline.h"
#import "BLRImageView.h"
#import "BLRImageViewController.h"
#import "BLRPhotoLibraryService.h"
#import "UIViewController+NSError.h"
#import "UIView+AutoLayout.h"

@implementation BLREditorViewController {
  BLRImageViewController *_imageViewController;
  BLREditorBottomNavigationView *_bottomNavigationView;
  
  BLRFeatureDetector *_featureDetector;
  BLRImagePipeline *_imagePipeline;
  
  UIImage *_originalImage;
  BLRImageMetadata *_imageMetadata;
  NSArray<UIBezierPath *> *_imagePaths;
  
  BLRPhotoLibraryService *_photoService;
  
  NSURL *_imageURL;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _featureDetector = [[BLRFeatureDetector alloc] init];
    _imagePipeline = [[BLRImagePipeline alloc] init];
    _imagePaths = @[];
    _photoService = [[BLRPhotoLibraryService alloc] init];
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
  [self setIsDrawingEnabled:[_bottomNavigationView isDrawingEnabled]];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  CGFloat bottomNavigationHeight = CGRectGetHeight(_bottomNavigationView.frame);
  _imageViewController.additionalSafeAreaInsets = UIEdgeInsetsMake(0, 0, bottomNavigationHeight, 0);
}

#pragma mark - BLREditorBottomNavigationViewDelegate

- (void)editorBottomNavigationView:(BLREditorBottomNavigationView *)editorBottomNavigationView didChangeFaceObfuscation:(BOOL)shouldFaceObfuscate {
  // Triggers a re-rendering of the image.
  [self processImage:_originalImage metadata:_imageMetadata];
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

#pragma mark - BLRImageViewDelegate

- (void)imageView:(BLRImageView *)imageView didUpdatePath:(CGPathRef)path {
  UIBezierPath *currentPath = [UIBezierPath bezierPathWithCGPath:path];
  
  NSMutableArray *paths = [_imagePaths mutableCopy];
  [paths addObject:currentPath];
  _imageMetadata = [BLRImageMetadata metadataWithFaceObservations:_imageMetadata.faceObservations obfuscationPaths:paths];
  
  [self processImage:_originalImage metadata:_imageMetadata];
}

- (void)imageView:(BLRImageView *)imageView didFinishPath:(CGPathRef)path {
  UIBezierPath *currentPath = [UIBezierPath bezierPathWithCGPath:path];
  
  NSMutableArray *paths = [_imagePaths mutableCopy];
  [paths addObject:currentPath];
  
  _imageMetadata = [BLRImageMetadata metadataWithFaceObservations:_imageMetadata.faceObservations obfuscationPaths:paths];
  _imagePaths = paths;
  
  [self processImage:_originalImage metadata:_imageMetadata];
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

- (void)setIsDrawingEnabled:(BOOL)isDrawingEnabled {
  _imageViewController.imageView.touchTrackingEnabled = isDrawingEnabled;
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
