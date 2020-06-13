// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.md, included with
// this project.

#import <Foundation/Foundation.h>

#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

/** A data object that configures rendering of the image. */
@interface FBLCRenderingOptions : NSObject

/** True if face obfuscation rects should be drawn. */
@property(nonatomic) BOOL shouldObscureFaces;

/** The size in screen points of the render target. */
@property(nonatomic) CGSize targetSize;

+ (instancetype)optionsWithTargetSize:(CGSize)targetSize shouldObscureFaces:(BOOL)shouldObscureFaces;

- (instancetype)init NS_UNAVAILABLE;

@end
NS_ASSUME_NONNULL_END
