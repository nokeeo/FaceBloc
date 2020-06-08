//
//  BLRImageViewController.m
//  Blur
//
//  Created by Eric Lee on 6/6/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import "BLRImageViewController.h"

#import "BLRImage.h"
#import "BLRImageView.h"

@implementation BLRImageViewController {
  BLRImage *_image;
}

- (instancetype)initWithImage:(BLRImage *)image {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _image = image;
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
  if (self.imageView.image || !_image) {
    return;
  }
  
  CGSize safeAreaInsetSize = UIEdgeInsetsInsetRect(self.view.bounds, self.view.safeAreaInsets).size;
  CGFloat scale = UIScreen.mainScreen.scale;
  CGFloat imageMaxPixelSize = MAX(safeAreaInsetSize.width, safeAreaInsetSize.height) * scale;
  
  __weak __typeof__(self) weakSelf = self;
  [_image templateImageWithDimension:imageMaxPixelSize completion:^(UIImage * _Nonnull image) {
    [weakSelf handleImageLoad:image];
  }];
}

- (void)handleImageLoad:(UIImage *)image {
  _imageView.image = image;
  [_delegate imageViewController:self didLoadImage:image];
}

@end
