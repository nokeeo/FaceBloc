// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.md, included with
// this project.

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** The quality to save the image. */
typedef NS_ENUM(NSUInteger, FBLCSavePhotoQuality) {
  /** The lossless version of the image. No data is lost. */
  FBLCSavePhotoQualityFull,
  FBLCSavePhotoQualityLarge,
  FBLCSavePhotoQualityMedium,
  FBLCSavePhotoQualitySmall,
};

/**
 * The callback executed when a save operation completes.
 * @param error The error describing a failure to save the photo. Nil if the operation succeeded.
 */
typedef void (^FBLCSavePhotoCompletionBlock)(NSError *_Nullable error);

/** A service for interfacing with the user's photo library. */
@interface FBLCPhotoLibraryService : NSObject

/** Saves the given photo to the user's photo library. The given completion block is executed on the given queue. */
- (void)savePhotoToLibrary:(UIImage *)image
                   quality:(FBLCSavePhotoQuality)quality
                     queue:(dispatch_queue_t)queue
                completion:(FBLCSavePhotoCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
