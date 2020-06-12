// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.txt, included with
// this project.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBLCStrokeWidthIndicatorLayer : CAShapeLayer

@property(nonatomic, readonly) CGFloat normalStrokeWidth;

@property(nonatomic, readonly) CGFloat zoomLevel;

- (instancetype)initWithNormalStrokeWidth:(CGFloat)normalStrokeWidth zoomLevel:(CGFloat)zoomLevel NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (void)setNormalStrokeWidth:(CGFloat)normalStrokeWidth zoomLevel:(CGFloat)zoomLevel imageSize:(CGSize)imageSize;

@end

NS_ASSUME_NONNULL_END
