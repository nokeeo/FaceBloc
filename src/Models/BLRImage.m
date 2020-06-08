//
//  BLRImage.m
//  Blur
//
//  Created by Eric Lee on 6/7/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import "BLRImage.h"

#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

#import "BLRPhotoLibraryService.h"

BLRImageLoadOptionKey BLRImageLoadOptionTemplateMaxDimension = @"BLRImageLoadOptionTemplateMaxDimension";

static CGImageSourceRef CreateImageSource(NSURL *URL) {
  NSDictionary<NSString *, id> *imageSourceOptions = @{
    (__bridge NSString *)kCGImageSourceShouldCache : @(NO),
  };
  return CGImageSourceCreateWithURL((__bridge CFURLRef)URL, (__bridge CFDictionaryRef)imageSourceOptions);
}

static NSDictionary<NSString *, id> *CreateTemplateImageOptions(NSNumber *maxDimension) {
  return @{
    (__bridge NSString *)kCGImageSourceCreateThumbnailFromImageAlways : @(YES),
    (__bridge NSString *)kCGImageSourceShouldCacheImmediately : @(YES),
    (__bridge NSString *)kCGImageSourceThumbnailMaxPixelSize : maxDimension,
  };
}

static NSDictionary<NSString *, id> *CreateSourceImageOptions() {
  return @{
    (__bridge NSString *)kCGImageSourceCreateThumbnailFromImageAlways : @(NO),
    (__bridge NSString *)kCGImageSourceShouldCacheImmediately : @(YES),
    (__bridge NSString *)kCGImageSourceCreateThumbnailFromImageIfAbsent : @(NO),
  };
}

static void CallImageLoadCompletionBlock(BLRImageLoadCompletion completion, UIImage *image) {
  dispatch_async(dispatch_get_main_queue(), ^{
    completion(image);
  });
}

static NSNumber *_Nullable GetTemplateImageDimensions(NSDictionary<BLRImageLoadOptionKey, id> *_Nullable options) {
  id value = options[BLRImageLoadOptionTemplateMaxDimension];
  if ([value isKindOfClass:[NSNumber class]]) {
    return (NSNumber *)value;
  }
  
  return nil;
}

@implementation BLRImage {
  CGImageSourceRef _imageSource;
  
  UIImage *_Nullable _templateImage;
  NSNumber *_templateImageDimension;
  
  UIImage *_Nullable _sourceImage;
  
  BLRPhotoLibraryService *_photoLibraryService;
}

- (instancetype)initWithURL:(NSURL *)URL {
  self = [super init];
  if (self) {
    _URL = URL;
    _imageSource = CreateImageSource(URL);
    _photoLibraryService = [[BLRPhotoLibraryService alloc] init];
  }
  
  return self;
}

- (void)dealloc {
  CFRelease(_imageSource);
}

- (void)imageOfType:(BLRImageType)type options:(NSDictionary<BLRImageLoadOptionKey,id> *)options onQueue:(dispatch_queue_t)onQueue completion:(nonnull BLRImageLoadCompletion)completion {
  dispatch_async(onQueue, ^{
    UIImage *image = [self imageOfType:type options:options];
    CallImageLoadCompletionBlock(completion, image);
  });
}

- (UIImage *)imageOfType:(BLRImageType)type options:(NSDictionary *)options {
  switch (type) {
    case BLRImageTypeTemplate:
      return [self loadTemplateImageWithOptions:options];
      break;
    case BLRImageTypeSource:
      return [self loadSourceImage];
      break;
  }
}

#pragma mark - Private Methods

- (UIImage *)loadTemplateImageWithOptions:(NSDictionary<BLRImageLoadOptionKey, id>*)options {
  NSNumber *maxDimension = GetTemplateImageDimensions(options);
  if (_templateImage && [maxDimension isEqualToNumber:_templateImageDimension]) {
    return _templateImage;
  }
  
  _templateImage = nil;
  _templateImageDimension = maxDimension;
  
  CFDictionaryRef templateOptions = (__bridge CFDictionaryRef)CreateTemplateImageOptions(maxDimension);
  CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(self->_imageSource, 0, templateOptions);
  UIImage *image = [UIImage imageWithCGImage:imageRef];
  CFRelease(imageRef);
  
  _templateImage = image;
  
  return _templateImage;
}

- (UIImage *)loadSourceImage {
  if (_sourceImage) {
    return _sourceImage;
  }
  
  CFDictionaryRef options = (__bridge CFDictionaryRef)CreateSourceImageOptions();
  CGImageRef imageRef = CGImageSourceCreateImageAtIndex(self->_imageSource, 0, options);
  UIImage *image = [UIImage imageWithCGImage:imageRef];
  CGImageRelease(imageRef);
  
  self->_sourceImage = image;
  
  return _sourceImage;
}

@end
