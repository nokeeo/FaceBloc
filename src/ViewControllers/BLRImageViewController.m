//
//  BLRImageViewController.m
//  Blur
//
//  Created by Eric Lee on 6/6/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import "BLRImageViewController.h"

#import "BLRImageView.h"

@implementation BLRImageViewController

- (void)loadView {
  _imageView = [[BLRImageView alloc] init];
  self.view = _imageView;
}

@end
