// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.md, included with
// this project.

#import <UIKit/UIKit.h>

@protocol FBLCImageViewDelegate;

NS_ASSUME_NONNULL_BEGIN

/** The object that hosts a given UIImage. Supports panning and zooming the image. */
@interface FBLCImageView : UIView <UIScrollViewDelegate>

/** The image to display in the view. */
@property(nonatomic, nullable) UIImage *image;

/** The view that is displaying the image content of the receiver. */
@property(nonatomic, readonly) UIView *contentView;

/**
 * The current zoom scale factor being applied to the content.
 * @see UIScrollView#zoomScale
 */
@property(nonatomic, readonly) CGFloat zoomScale;

@end

NS_ASSUME_NONNULL_END
