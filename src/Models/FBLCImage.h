// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.md, included with
// this project.

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * The completion handler that is called when the image is loaded.
 * @param image The loaded image.
 */
typedef void (^FBLCImageLoadCompletion)(UIImage *image);

/** Represents the type of images that can be loaded. */
typedef NS_ENUM(NSUInteger, FBLCImageType) {
  /** The full quality image. */
  FBLCImageTypeSource,
  
  /** A smaller image. Image dimensions are specified using @c FBLCImageLoadOptionTemplateMaxDimension . */
  FBLCImageTypeTemplate
};

/** The type of the keys within the options dictionary when performing the load operation. */
typedef NSString *const FBLCImageLoadOptionKey NS_TYPED_ENUM;

/**
 * The key of the value that holds the dimension of the template image. This key only applies to loads of image type
 * @c FBLCImageTypeTemplate , otherwise it is ignored. This mapped value should be a NSNumber.
 */
extern FBLCImageLoadOptionKey FBLCImageLoadOptionTemplateMaxDimension;


/** Represents an image that can be loaded from an external source. */
@interface FBLCImage : NSObject

/** The URL of the image on the file system. */
@property(nonatomic, readonly) NSURL *URL;

- (instancetype)initWithURL:(NSURL *)URL orientation:(UIImageOrientation)orientation NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithURL:(NSURL *)URL;

// Please use `initWithURL:`.
- (instancetype)init NS_UNAVAILABLE;

/**
 * Asynchronously loads the image with the given type of the given thread.
 * @param type The variation of the image to load.
 * @param options The dictionary that contains parameters of loading the image.
 * @param onQueue The queue on which to perform the load.
 * @param completion The block that executed upon completion of the load. This block is called on the main thread.
 */
- (void)imageOfType:(FBLCImageType)type
            options:(nullable NSDictionary<FBLCImageLoadOptionKey, id> *)options
            onQueue:(dispatch_queue_t)onQueue
         completion:(FBLCImageLoadCompletion)completion;

/**
 * Synchronously loads the image of the given variation.
 * @param type The variation of the image to load.
 * @param options The dictionary that contains parameters of loading the image.
 */
- (UIImage *)imageOfType:(FBLCImageType)type options:(nullable NSDictionary<FBLCImageLoadOptionKey, id> *)options;

@end

NS_ASSUME_NONNULL_END
