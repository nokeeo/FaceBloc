// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.txt, included with
// this project.

#import "FBLCImage.h"

#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

#import "FBLCPhotoLibraryService.h"

FBLCImageLoadOptionKey FBLCImageLoadOptionTemplateMaxDimension = @"FBLCImageLoadOptionTemplateMaxDimension";

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

static void CallImageLoadCompletionBlock(FBLCImageLoadCompletion completion, UIImage *image) {
  dispatch_async(dispatch_get_main_queue(), ^{
    completion(image);
  });
}

static NSNumber *_Nullable GetTemplateImageDimensions(NSDictionary<FBLCImageLoadOptionKey, id> *_Nullable options) {
  id value = options[FBLCImageLoadOptionTemplateMaxDimension];
  if ([value isKindOfClass:[NSNumber class]]) {
    return (NSNumber *)value;
  }
  
  return nil;
}

@implementation FBLCImage {
  CGImageSourceRef _imageSource;
  
  UIImage *_Nullable _templateImage;
  NSNumber *_templateImageDimension;
  
  UIImage *_Nullable _sourceImage;
  
  FBLCPhotoLibraryService *_photoLibraryService;
}

- (instancetype)initWithURL:(NSURL *)URL {
  self = [super init];
  if (self) {
    _URL = URL;
    _imageSource = CreateImageSource(URL);
    _photoLibraryService = [[FBLCPhotoLibraryService alloc] init];
  }
  
  return self;
}

- (void)dealloc {
  CFRelease(_imageSource);
}

- (void)imageOfType:(FBLCImageType)type options:(NSDictionary<FBLCImageLoadOptionKey,id> *)options onQueue:(dispatch_queue_t)onQueue completion:(nonnull FBLCImageLoadCompletion)completion {
  dispatch_async(onQueue, ^{
    UIImage *image = [self imageOfType:type options:options];
    CallImageLoadCompletionBlock(completion, image);
  });
}

- (UIImage *)imageOfType:(FBLCImageType)type options:(NSDictionary *)options {
  switch (type) {
    case FBLCImageTypeTemplate:
      return [self loadTemplateImageWithOptions:options];
      break;
    case FBLCImageTypeSource:
      return [self loadSourceImage];
      break;
  }
}

#pragma mark - Private Methods

- (UIImage *)loadTemplateImageWithOptions:(NSDictionary<FBLCImageLoadOptionKey, id>*)options {
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
