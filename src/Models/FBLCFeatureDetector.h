// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.txt, included with
// this project.

#import <Foundation/Foundation.h>

@class UIImage;
@class VNDetectedObjectObservation;

NS_ASSUME_NONNULL_BEGIN

typedef void (^FBLCObjectDetectorCompleitionBlock)(NSArray<VNDetectedObjectObservation *> *_Nullable observations,
                                                   NSError *_Nullable error);

@interface FBLCFeatureDetector : NSObject

- (void)detectFeaturesForImage:(UIImage *)image
                 dispatchQueue:(dispatch_queue_t)dispatchQueue
                    completion:(FBLCObjectDetectorCompleitionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
