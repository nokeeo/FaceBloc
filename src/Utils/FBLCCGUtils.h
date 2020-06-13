// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.md, included with
// this project.

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

@class FBLCImageGeometryData;
@class FBLCRenderingOptions;

NS_ASSUME_NONNULL_BEGIN

/**
 * Draws the given geometry data in the given context.
 * @param context The context in which to draw the geometry.
 * @param geometry The geometry to render.
 * @param options The global rendering configuration.
 */
extern void FBLCDrawImageGeometryInContext(CGContextRef context, FBLCImageGeometryData *geometry,
                                           FBLCRenderingOptions *options);

/**
 * Normalizes the x and y values in respect to the given bounds. The returned point's coordinate values range
 * from zero to one.
 */
extern CGPoint FBLCNormalizePoint(CGPoint point, CGSize bounds);

/** Converts the given normalized point to the target size. */
extern CGPoint FBLCPointForNormalPoint(CGPoint normalPoint, CGSize bounds);

/** Converts a normalized rect to the target render size. */
extern CGRect FBLCRectForNormalRect(CGRect rect, CGSize bounds);

NS_ASSUME_NONNULL_END
