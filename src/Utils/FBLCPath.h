// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.txt, included with
// this project.

#import <Foundation/Foundation.h>

#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBLCPath : NSObject <NSMutableCopying>

- (instancetype)initWithPath:(CGPathRef)path NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (CGPathRef)CGPathForSize:(CGSize)size;

- (CGFloat)strokeWidth;

@end

@interface FBLCMutablePath : FBLCPath

@property(nonatomic) CGFloat strokeWidth;

- (instancetype)init;

- (void)addPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
