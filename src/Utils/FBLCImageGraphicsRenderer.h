// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.md, included with
// this project.

#import <Foundation/Foundation.h>

@class FBLCImageGeometryData;
@class FBLCRenderingOptions;
@class UIImage;

NS_ASSUME_NONNULL_BEGIN

/** The object that renders geometry on a given image. */
@interface FBLCImageGraphicsRenderer : NSObject

/**
 * Renders the given geometry on the given image.
 * @param image The image that acts a the source image. All geometry is drawn on this image.
 * @param geometry An object that describes what is rendered on the image.
 * @param options Configures global rendering options.
 * @returns An image with the given geometry rendered on the given image.
 */
- (UIImage *)renderImage:(UIImage *)image
                geometry:(FBLCImageGeometryData *)geometry
                 options:(FBLCRenderingOptions *)options;

@end

NS_ASSUME_NONNULL_END
