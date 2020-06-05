#import "BLREditorViewController.h"

#import <Vision/Vision.h>

#import "BLREditorView.h"
#import "BLRFeatureDetector.h"
#import "BLRImageMetadata.h"
#import "BLRImagePipeline.h"

@implementation BLREditorViewController {
  BLREditorView *_editorView;
  
  BLRFeatureDetector *_featureDetector;
  BLRImagePipeline *_imagePipeline;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _featureDetector = [[BLRFeatureDetector alloc] init];
    _imagePipeline = [[BLRImagePipeline alloc] init];
  }
  
  return self;
}

- (void)loadView {
  _editorView = [[BLREditorView alloc] init];
  self.view = _editorView;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = UIColor.blackColor;
}

#pragma mark - Getters

- (UIImage *)image {
  return _editorView.image;
}

#pragma mark - Setters

- (void)setImage:(UIImage *)image {
  [self loadViewIfNeeded];
  __weak __typeof__(self) weakSelf = self;
  [_featureDetector detectFeaturesForImage:image dispatchQueue:dispatch_get_main_queue() completion:^(NSArray<VNDetectedObjectObservation *> * _Nullable observations, NSError * _Nullable error) {
    [weakSelf handleFacialFeatureDetectionForImage:image observations:observations error:error];
  }];
  _editorView.image = image;
}

#pragma mark - Private Methods

- (void)handleFacialFeatureDetectionForImage:(UIImage *)image observations:(nullable NSArray<VNDetectedObjectObservation *> *)observations error:(nullable NSError *)error {
  if (error || !observations) {
    // TODO: Handle error.
    return;
  }
  
  BLRImageMetadata *metadata = [BLRImageMetadata metadataWithFaceObservations:observations];
  
  __weak __typeof__(self) weakSelf = self;
  [_imagePipeline processImage:image withMetaData:metadata completion:^(UIImage * _Nonnull processedImage) {
    __typeof__(self) strongSelf = weakSelf;
    strongSelf->_editorView.image = processedImage;
  }];
}

@end
