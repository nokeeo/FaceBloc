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

static CGImageSourceRef CreateImageSource(NSURL *URL) {
  NSDictionary<NSString *, id> *imageSourceOptions = @{
    (__bridge NSString *)kCGImageSourceShouldCache : @(NO),
  };
  return CGImageSourceCreateWithURL((__bridge CFURLRef)URL, (__bridge CFDictionaryRef)imageSourceOptions);
}

static NSDictionary<NSString *, id> *CreateTemplateImageOptions(size_t maxDimension) {
  return @{
    (__bridge NSString *)kCGImageSourceCreateThumbnailFromImageAlways : @(YES),
    (__bridge NSString *)kCGImageSourceShouldCacheImmediately : @(YES),
    (__bridge NSString *)kCGImageSourceThumbnailMaxPixelSize : @(maxDimension),
  };
}

static void CallImageLoadCompletionBlock(BLRImageLoadComletion completion, UIImage *image) {
  dispatch_async(dispatch_get_main_queue(), ^{
    completion(image);
  });
}

@implementation BLRImage {
  CGImageSourceRef _imageSource;
  
  UIImage *_Nullable _templateImage;
  size_t _templateImageDimension;
}

- (instancetype)initWithURL:(NSURL *)URL {
  self = [super init];
  if (self) {
    _URL = URL;
    _imageSource = CreateImageSource(URL);
  }
  
  return self;
}

- (void)dealloc {
  CFRelease(_imageSource);
}

- (void)templateImageWithDimension:(size_t)dimension completion:(BLRImageLoadComletion)completion {
  if (_templateImage && dimension == _templateImageDimension) {
    completion(_templateImage);
    return;
  }
  
  _templateImage = nil;
  _templateImageDimension = dimension;
  
  dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
    CFDictionaryRef options = (__bridge CFDictionaryRef)CreateTemplateImageOptions(dimension);
    CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(self->_imageSource, 0, options);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CFRelease(imageRef);
    
    self->_templateImage = image;
    CallImageLoadCompletionBlock(completion, image);
  });
}

@end
