// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.txt, included with
// this project.

#import <UIKit/UIKit.h>

@protocol FBLCImageViewDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface FBLCImageView : UIView <UIScrollViewDelegate>

@property(nonatomic, nullable) UIImage *image;

@property(nonatomic, readonly) UIView *contentView;

@property(nonatomic, readonly) CGFloat zoomScale;

@end

NS_ASSUME_NONNULL_END
