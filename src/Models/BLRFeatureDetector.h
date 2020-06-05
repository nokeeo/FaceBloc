//
//  BLRFeatureDetector.h
//  Blur
//
//  Created by Eric Lee on 6/4/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;
@class VNDetectedObjectObservation;

NS_ASSUME_NONNULL_BEGIN

typedef void (^BLRObjectDetectorCompleitionBlock)(NSArray<VNDetectedObjectObservation *> *_Nullable observations, NSError *_Nullable error);

@interface BLRFeatureDetector : NSObject

- (void)detectFeaturesForImage:(UIImage *)image dispatchQueue:(dispatch_queue_t)dispatchQueue completion:(BLRObjectDetectorCompleitionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
