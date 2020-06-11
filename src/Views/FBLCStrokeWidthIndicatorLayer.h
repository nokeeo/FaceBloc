//
//  FBLCStrokeWidthIndicatorView.h
//  Blur
//
//  Created by Eric Lee on 6/9/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

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
