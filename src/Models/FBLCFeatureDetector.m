// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.txt, included with
// this project.

#import "FBLCFeatureDetector.h"

#import <CoreImage/CoreImage.h>
#import <UIKit/UIKit.h>
#import <Vision/Vision.h>

static VNImageRequestHandler *RequestHandlerForImage(UIImage *image) {
  if (image.CGImage) {
    return [[VNImageRequestHandler alloc] initWithCGImage:image.CGImage options:@{}];
  }
  
  return [[VNImageRequestHandler alloc] initWithCIImage:image.CIImage options:@{}];
}

@implementation FBLCFeatureDetector {
  NSMutableSet<VNImageRequestHandler *> *_requestHandlers;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _requestHandlers = [NSMutableSet set];
  }
  
  return self;
}

- (void)detectFeaturesForImage:(UIImage *)image dispatchQueue:(dispatch_queue_t)dispatchQueue completion:(FBLCObjectDetectorCompleitionBlock)completion {
  VNImageRequestHandler *requestHandler = RequestHandlerForImage(image);
  
  __weak VNImageRequestHandler *weakHandler = requestHandler;
  __weak __typeof__(self) weakSelf = self;
  VNDetectFaceRectanglesRequest *request = [[VNDetectFaceRectanglesRequest alloc] initWithCompletionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
    [weakSelf handleResults:request.results error:error handler:weakHandler queue:dispatchQueue completion:completion];
  }];
  
  @synchronized (self) {
    [_requestHandlers addObject:requestHandler];
  }
  
  [self sendRequest:request withHandler:requestHandler errorBlock:^(NSError *error) {
    [weakSelf handleResults:nil error:error handler:weakHandler queue:dispatchQueue completion:completion];
  }];
}

#pragma mark - Private Methods

- (void)sendRequest:(VNRequest *)request withHandler:(VNImageRequestHandler *)handler errorBlock:(void(^)(NSError *error))errorBlock {
  dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
    NSError *error;
    BOOL successScheduling = [handler performRequests:@[request] error:&error];
    if (successScheduling && error) {
      errorBlock(error);
    }
  });
}

- (void)handleResults:(NSArray<VNDetectedObjectObservation *> *)observations error:(NSError *)error handler:(VNImageRequestHandler *)handler queue:(dispatch_queue_t)queue completion:(FBLCObjectDetectorCompleitionBlock)completion {
  @synchronized (self) {
    [_requestHandlers removeObject:handler];
  }
  
  dispatch_async(queue, ^{
    completion(observations, error);
  });
}

@end
