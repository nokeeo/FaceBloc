//
//  BLRImageView.m
//  Blur
//
//  Created by Eric Lee on 6/4/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import "BLRImageView.h"

static UIScrollView *CreateImageScrollView() {
  UIScrollView *view = [[UIScrollView alloc] init];
  view.bouncesZoom = YES;
  view.bounces = YES;
  view.scrollEnabled = YES;
  view.alwaysBounceVertical = YES;
  view.alwaysBounceHorizontal = YES;
  view.minimumZoomScale = 1;
  view.showsVerticalScrollIndicator = NO;
  view.showsHorizontalScrollIndicator = NO;
  
  return view;
}

static UIImageView *CreateImageView() {
  UIImageView *view = [[UIImageView alloc] init];
  view.contentMode = UIViewContentModeScaleAspectFit;
  
  return view;
}

static NSArray<NSLayoutConstraint *> *CreateImageScrollViewConstraints(UIView *scrollView) {
  UIView *superview = scrollView.superview;
  return @[
    [scrollView.leadingAnchor constraintEqualToAnchor:superview.leadingAnchor],
    [scrollView.trailingAnchor constraintEqualToAnchor:superview.trailingAnchor],
    [scrollView.topAnchor constraintEqualToAnchor:superview.topAnchor],
    [scrollView.bottomAnchor constraintEqualToAnchor:superview.bottomAnchor],
  ];
}

@implementation BLRImageView {
  UIScrollView *_imageScrollView;
  UIImageView *_imageView;
  
  NSLayoutConstraint *_imageViewTopConstraint;
  NSLayoutConstraint *_imageViewLeadingConstrint;
  NSLayoutConstraint *_imageViewBottomConstraint;
  NSLayoutConstraint *_imageViewTrailingConstraint;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    
    _imageScrollView = CreateImageScrollView();
    _imageScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_imageScrollView];
    [self addConstraints:CreateImageScrollViewConstraints(_imageScrollView)];
    
    _imageView = CreateImageView();
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    _imageViewTopConstraint = [_imageView.topAnchor constraintEqualToAnchor:_imageScrollView.topAnchor];
    _imageViewLeadingConstrint = [_imageView.leadingAnchor constraintEqualToAnchor:_imageScrollView.leadingAnchor];
    _imageViewTrailingConstraint = [_imageView.trailingAnchor constraintEqualToAnchor:_imageScrollView.trailingAnchor];
    _imageViewBottomConstraint = [_imageView.bottomAnchor constraintEqualToAnchor:_imageScrollView.bottomAnchor];
    [_imageScrollView addSubview:_imageView];
    [self addConstraints:@[
      _imageViewTopConstraint,
      _imageViewLeadingConstrint,
      _imageViewTrailingConstraint,
      _imageViewBottomConstraint,
    ]];
    _imageScrollView.delegate = self;
  }
  
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGSize imageSize = _imageView.image.size;
  CGRect scrollViewSafeArea = UIEdgeInsetsInsetRect(_imageScrollView.bounds, _imageScrollView.safeAreaInsets);
  CGFloat verticalZoomScale = CGRectGetHeight(scrollViewSafeArea) / imageSize.height;
  CGFloat horizontalZoomScale = CGRectGetWidth(scrollViewSafeArea) / imageSize.width;
  CGFloat minZoomScale = MIN(verticalZoomScale, horizontalZoomScale);
  
  _imageScrollView.minimumZoomScale = minZoomScale;
  _imageScrollView.zoomScale = minZoomScale;
  // TODO: Fix initial positioning. The initial positioning of the image should be centered.
}

#pragma mark - Getters

- (UIImage *)image {
  return _imageView.image;
}

#pragma mark - Setters

- (void)setImage:(UIImage *)image {
  _imageView.image = image;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
  [self updateScrollViewConstraintsForImageViewSize:_imageView.frame.size];
}

- (void)updateScrollViewConstraintsForImageViewSize:(CGSize)size {
  CGRect scrollViewSafeArea = UIEdgeInsetsInsetRect(_imageScrollView.bounds, _imageScrollView.safeAreaInsets);
  CGFloat imageViewYOffset = floorf(MAX(0, CGRectGetHeight(scrollViewSafeArea) - size.height) / 2.f);
  _imageViewTopConstraint.constant = imageViewYOffset;
  _imageViewBottomConstraint.constant = imageViewYOffset;
  
  CGFloat imageViewXOffset = floorf(MAX(0, CGRectGetWidth(scrollViewSafeArea) - size.width) / 2.f);
  _imageViewLeadingConstrint.constant = imageViewXOffset;
  _imageViewTrailingConstraint.constant = imageViewYOffset;
}

@end
