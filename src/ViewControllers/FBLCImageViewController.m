// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.md, included with
// this project.

#import "FBLCImageViewController.h"

#import "FBLCImage.h"
#import "FBLCImageView.h"

@implementation FBLCImageViewController

- (instancetype)initWithImage:(FBLCImage *)image {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _image = image;
  }

  return self;
}

- (void)loadView {
  _imageView = [[FBLCImageView alloc] init];
  self.view = _imageView;
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];

  [self loadImageIfNeeded];
}

#pragma mark - Getters

- (FBLCImageView *)imageView {
  [self loadViewIfNeeded];
  return _imageView;
}

#pragma mark - Private Methods

/**
 * Fetches the image from disk and sets the image view's image to the loaded image. If the image is already loaded, this
 * method call is a no-op.
 */
- (void)loadImageIfNeeded {
  if (self.imageView.image || !_image) {
    return;
  }

  CGSize safeAreaInsetSize = UIEdgeInsetsInsetRect(self.view.bounds, self.view.safeAreaInsets).size;
  CGFloat scale = UIScreen.mainScreen.scale;
  CGFloat imageMaxPixelSize = MAX(safeAreaInsetSize.width, safeAreaInsetSize.height) * scale;
  NSDictionary<FBLCImageLoadOptionKey, id> *options = @{
    FBLCImageLoadOptionTemplateMaxDimension : @(imageMaxPixelSize),
  };

  __weak __typeof__(self) weakSelf = self;
  [_image imageOfType:FBLCImageTypeTemplate
              options:options
              onQueue:dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
           completion:^(UIImage *_Nonnull image) {
             [weakSelf handleImageLoad:image];
           }];
}

/** Is called when the images has finished loading from disk. */
- (void)handleImageLoad:(UIImage *)image {
  _imageView.image = image;
  [_delegate imageViewController:self didLoadImage:image];
}

@end
