// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.md, included with
// this project.

#import <Foundation/Foundation.h>

@class UIImage;
@class VNDetectedObjectObservation;

NS_ASSUME_NONNULL_BEGIN

/** The type of block that is executed when face detection has finished. */
typedef void (^FBLCObjectDetectorCompletionBlock)(NSArray<VNDetectedObjectObservation *> *_Nullable observations,
                                                   NSError *_Nullable error);

@interface FBLCFeatureDetector : NSObject

/**
 * Begins facial detection on the given image.
 * @param image The image to perform facial recognition on.
 * @param dispatchQueue The queue in which to execute the callback.
 * @param completionBlock The block to execute upon the completion of the facial recognition analysis.
 */
- (void)detectFeaturesForImage:(UIImage *)image
                 dispatchQueue:(dispatch_queue_t)dispatchQueue
                    completion:(FBLCObjectDetectorCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
