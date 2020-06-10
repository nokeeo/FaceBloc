//
//  BLRImage.h
//  Blur
//
//  Created by Eric Lee on 6/7/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^BLRImageLoadCompletion)(UIImage *image);

typedef NS_ENUM(NSUInteger, BLRImageType) {
  BLRImageTypeSource,
  BLRImageTypeTemplate
};

typedef NSString *const BLRImageLoadOptionKey NS_TYPED_ENUM;

extern BLRImageLoadOptionKey BLRImageLoadOptionTemplateMaxDimension;

extern

@interface BLRImage : NSObject

@property(nonatomic, readonly) NSURL *URL;

- (instancetype)initWithURL:(NSURL *)URL NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (void)imageOfType:(BLRImageType)type options:(nullable NSDictionary<BLRImageLoadOptionKey, id> *)options onQueue:(dispatch_queue_t)onQueue completion:(BLRImageLoadCompletion)completion;

- (UIImage *)imageOfType:(BLRImageType)type options:(nullable NSDictionary<BLRImageLoadOptionKey, id> *)options;

@end

NS_ASSUME_NONNULL_END
