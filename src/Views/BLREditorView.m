//
//  BLREditorView.m
//  Blur
//
//  Created by Eric Lee on 6/4/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import "BLREditorView.h"

@implementation BLREditorView {
  UIImageView *_imageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_imageView];
    
    UILayoutGuide *safeAreaLayoutGuide = self.safeAreaLayoutGuide;
    NSArray<NSLayoutConstraint *> *imageViewConstraints = @[
      [_imageView.leadingAnchor constraintEqualToAnchor:safeAreaLayoutGuide.leadingAnchor],
      [_imageView.trailingAnchor constraintEqualToAnchor:safeAreaLayoutGuide.trailingAnchor],
      [_imageView.topAnchor constraintEqualToAnchor:safeAreaLayoutGuide.topAnchor],
      [_imageView.bottomAnchor constraintEqualToAnchor:safeAreaLayoutGuide.bottomAnchor],
    ];
    [self addConstraints:imageViewConstraints];
  }
  
  return self;
}

#pragma mark - Getters

- (UIImage *)image {
  return _imageView.image;
}

#pragma mark - Setters

- (void)setImage:(UIImage *)image {
  _imageView.image = image;
}

@end
