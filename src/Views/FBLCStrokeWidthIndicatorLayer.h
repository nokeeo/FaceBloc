// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.md, included with
// this project.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** The layer that renders the geometry that visualizes the width of the draw tool. */
@interface FBLCStrokeWidthIndicatorLayer : CAShapeLayer

/** The stroke width in normal form. Value must range from 0 to 1. */
@property(nonatomic, readonly) CGFloat normalStrokeWidth;

/** The zoom level of the image. The stroke is scaled based on this value. */
@property(nonatomic, readonly) CGFloat zoomLevel;

- (instancetype)initWithNormalStrokeWidth:(CGFloat)normalStrokeWidth
                                zoomLevel:(CGFloat)zoomLevel NS_DESIGNATED_INITIALIZER;

// Please use `initWithNormalStrokeWidth:zoomLevel:`.
- (instancetype)init NS_UNAVAILABLE;

/**
 * Updates the properties of this layer.
 * @param normalStrokeWidth The stroke width in normal form with respect to the width.
 * @param zoomLevel The amount the image is zoomed. The stroke width will be scaled by this value.
 * @param imageSize The size of the image. This is used to denormalize the stroke width.
 */
- (void)setNormalStrokeWidth:(CGFloat)normalStrokeWidth zoomLevel:(CGFloat)zoomLevel imageSize:(CGSize)imageSize;

@end

NS_ASSUME_NONNULL_END
