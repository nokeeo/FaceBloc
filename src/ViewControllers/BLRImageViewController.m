//
//  BLRImageViewController.m
//  Blur
//
//  Created by Eric Lee on 6/6/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import "BLRImageViewController.h"

#import "BLRImageView.h"

@implementation BLRImageViewController {
  NSURL *_imageURL;
}

- (instancetype)initWithImageURL:(NSURL *)imageURL {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _imageURL = imageURL;
  }
  
  return self;
}

- (void)loadView {
  _imageView = [[BLRImageView alloc] init];
  self.view = _imageView;
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  [self loadImageIfNeeded];
}

#pragma mark - Getters

- (BLRImageView *)imageView {
  [self loadViewIfNeeded];
  return _imageView;
}

#pragma mark - Private Methods

- (void)loadImageIfNeeded {
  if (self.imageView.image || !_imageURL) {
    return;
  }
  
  CGSize safeAreaInsetSize = UIEdgeInsetsInsetRect(self.view.bounds, self.view.safeAreaInsets).size;
  CGFloat scale = UIScreen.mainScreen.scale;
  CGFloat imageMaxPixelSize = MAX(safeAreaInsetSize.width, safeAreaInsetSize.height) * scale;
  NSDictionary<NSString *, id> *imageSourceOptions = @{
    (__bridge NSString *)kCGImageSourceShouldCache : @(NO),
  };
  CGImageSourceRef imageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)self->_imageURL, (__bridge CFDictionaryRef)imageSourceOptions);
  CFDictionaryRef thumbnailOptions = (__bridge CFDictionaryRef) @{
    (__bridge NSString *)kCGImageSourceCreateThumbnailFromImageAlways : @(YES),
    (__bridge NSString *)kCGImageSourceShouldCacheImmediately : @(YES),
    (__bridge NSString *)kCGImageSourceThumbnailMaxPixelSize : @(imageMaxPixelSize),
  };
  dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
    CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, thumbnailOptions);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CFRelease(imageSource);
    
    dispatch_async(dispatch_get_main_queue(), ^{
      self.imageView.image = image;
      [self->_delegate imageViewController:self didLoadImage:image];
    });
  });
}

@end
