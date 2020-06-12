// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.txt, included with
// this project.

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^FBLCImageLoadCompletion)(UIImage *image);

typedef NS_ENUM(NSUInteger, FBLCImageType) {
  FBLCImageTypeSource,
  FBLCImageTypeTemplate
};

typedef NSString *const FBLCImageLoadOptionKey NS_TYPED_ENUM;

extern FBLCImageLoadOptionKey FBLCImageLoadOptionTemplateMaxDimension;

extern

@interface FBLCImage : NSObject

@property(nonatomic, readonly) NSURL *URL;

- (instancetype)initWithURL:(NSURL *)URL NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (void)imageOfType:(FBLCImageType)type options:(nullable NSDictionary<FBLCImageLoadOptionKey, id> *)options onQueue:(dispatch_queue_t)onQueue completion:(FBLCImageLoadCompletion)completion;

- (UIImage *)imageOfType:(FBLCImageType)type options:(nullable NSDictionary<FBLCImageLoadOptionKey, id> *)options;

@end

NS_ASSUME_NONNULL_END
