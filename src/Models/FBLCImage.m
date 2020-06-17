// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.md, included with
// this project.

#import "FBLCImage.h"

#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

#import "FBLCPhotoLibraryService.h"

FBLCImageLoadOptionKey FBLCImageLoadOptionTemplateMaxDimension = @"FBLCImageLoadOptionTemplateMaxDimension";

/** Returns the object responsible for loading an image from disk. */
static CGImageSourceRef CreateImageSource(NSURL *URL) {
  NSDictionary<NSString *, id> *imageSourceOptions = @{
    (__bridge NSString *)kCGImageSourceShouldCache : @(NO),
  };
  return CGImageSourceCreateWithURL((__bridge CFURLRef)URL, (__bridge CFDictionaryRef)imageSourceOptions);
}

/** Creates the load options for a template image with the given size. */
static NSDictionary<NSString *, id> *CreateTemplateImageOptions(NSNumber *maxDimension) {
  return @{
    (__bridge NSString *)kCGImageSourceCreateThumbnailFromImageAlways : @(YES),
    (__bridge NSString *)kCGImageSourceShouldCacheImmediately : @(YES),
    (__bridge NSString *)kCGImageSourceThumbnailMaxPixelSize : maxDimension,
  };
}

/** Creates the load options for a source image. */
static NSDictionary<NSString *, id> *CreateSourceImageOptions() {
  return @{
    (__bridge NSString *)kCGImageSourceCreateThumbnailFromImageAlways : @(NO),
    (__bridge NSString *)kCGImageSourceShouldCacheImmediately : @(YES),
    (__bridge NSString *)kCGImageSourceCreateThumbnailFromImageIfAbsent : @(NO),
  };
}

/** Calls the given load completion block on the main thread. */
static void CallImageLoadCompletionBlock(FBLCImageLoadCompletion completion, UIImage *image) {
  dispatch_async(dispatch_get_main_queue(), ^{
    completion(image);
  });
}

/** Retrieves the template image dimension from the given options dictionary. */
static NSNumber *_Nullable GetTemplateImageDimensions(NSDictionary<FBLCImageLoadOptionKey, id> *_Nullable options) {
  id value = options[FBLCImageLoadOptionTemplateMaxDimension];
  if ([value isKindOfClass:[NSNumber class]]) {
    return (NSNumber *)value;
  }

  return nil;
}

@implementation FBLCImage {
  /** The object used to load the image from disk. */
  CGImageSourceRef _imageSource;

  /** The cached loaded template image. Nil if a template image has not been loaded yet. */
  UIImage *_Nullable _templateImage;
  
  /** The dimension of the last loaded @c _templateImage . */
  NSNumber *_Nullable _templateImageDimension;

  /** The cached loaded source image. */
  UIImage *_Nullable _sourceImage;

  UIImageOrientation _orientation;
}

- (instancetype)initWithURL:(NSURL *)URL orientation:(UIImageOrientation)orientation {
  self = [super init];
  if (self) {
    _URL = URL;
    _imageSource = CreateImageSource(URL);
    _orientation = orientation;
  }

  return self;
}

- (instancetype)initWithURL:(NSURL *)URL {
  return [self initWithURL:URL orientation:UIImageOrientationUp];
}

- (void)dealloc {
  CFRelease(_imageSource);
}

- (void)imageOfType:(FBLCImageType)type
            options:(NSDictionary<FBLCImageLoadOptionKey, id> *)options
            onQueue:(dispatch_queue_t)onQueue
         completion:(nonnull FBLCImageLoadCompletion)completion {
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

- (UIImage *)loadTemplateImageWithOptions:(NSDictionary<FBLCImageLoadOptionKey, id> *)options {
  NSNumber *maxDimension = GetTemplateImageDimensions(options);
  if (_templateImage && [maxDimension isEqualToNumber:_templateImageDimension]) {
    return _templateImage;
  }

  _templateImage = nil;
  _templateImageDimension = maxDimension;

  CFDictionaryRef templateOptions = (__bridge CFDictionaryRef)CreateTemplateImageOptions(maxDimension);
  CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(self->_imageSource, 0, templateOptions);
  UIImage *image = [UIImage imageWithCGImage:imageRef scale:1 orientation:_orientation];
  CFRelease(imageRef);

  _templateImage = image;

  return _templateImage;
}

#pragma mark - Private Methods

/** Synchronously loads the source image. */
- (UIImage *)loadSourceImage {
  if (_sourceImage) {
    return _sourceImage;
  }

  CFDictionaryRef options = (__bridge CFDictionaryRef)CreateSourceImageOptions();
  CGImageRef imageRef = CGImageSourceCreateImageAtIndex(self->_imageSource, 0, options);
  UIImage *image = [UIImage imageWithCGImage:imageRef scale:1 orientation:_orientation];
  CGImageRelease(imageRef);

  self->_sourceImage = image;

  return _sourceImage;
}

@end
