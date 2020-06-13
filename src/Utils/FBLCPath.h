// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.md, included with
// this project.

#import <Foundation/Foundation.h>

#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * A wrapper object around CGPath. The underlying path's coordinates should be in normal form. Each coordinate must have
 * a value ranging from zero to one.
 */
@interface FBLCPath : NSObject <NSMutableCopying>

/**
 * Initializes the wrapper with a given path. */
- (instancetype)initWithPath:(CGPathRef)path NS_DESIGNATED_INITIALIZER;

// Please use `initWithPath:`.
- (instancetype)init NS_UNAVAILABLE;

/** Returns the denormalized CGPath for the given target size. */
- (CGPathRef)CGPathForSize:(CGSize)size;

/**
 * Returns the stroke width to draw the receiver. The default value is 1. Subclasses may override this method to provide
 * alternative values.
 */
- (CGFloat)strokeWidth;

@end

/**
 * A mutable corresponding class to FBLCPath. Allows adding points to the path through methods exposed in this class's
 * interface.
 */
@interface FBLCMutablePath : FBLCPath

/** @see FBLCPath#strokeWidth */
@property(nonatomic) CGFloat strokeWidth;

/** Initializes an empty path. */
- (instancetype)init;

/**
 * Appends the given point to the path. The given point must be in normal form meaning each coordinate must have a value
 * ranging from zero to one.
 */
- (void)addPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
