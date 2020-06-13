// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.md, included with
// this project.

#import "FBLCImageGraphicsRenderer.h"

#import <UIKit/UIKit.h>

#import "FBLCCGUtils.h"

/**
 * Renders the geometry in an image of the given size and scale.
 * @param size The size in points to render the geometry.
 * @param scale The scale to multiply the size and geometry data by.
 * @param geometry The figures to render in the returned image.
 * @param options An object describing global rendering configuration.
 */
static UIImage *RenderGeometryImage(CGSize size, CGFloat scale, FBLCImageGeometryData *geometry,
                                    FBLCRenderingOptions *options) {
  UIGraphicsImageRendererFormat *format = [[UIGraphicsImageRendererFormat alloc] init];
  format.scale = scale;

  UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:size format:format];
  UIImage *geometryImage = [renderer imageWithActions:^(UIGraphicsImageRendererContext *_Nonnull rendererContext) {
    CGContextRef context = rendererContext.CGContext;
    FBLCDrawImageGeometryInContext(context, geometry, options);
  }];

  return geometryImage;
}

/** Composites the given foreground image on the given background image. */
static UIImage *CompositeImages(UIImage *foregroundImage, UIImage *backgroundImage) {
  CIImage *foregroundCIImage = [CIImage imageWithCGImage:foregroundImage.CGImage];
  CIImage *backgroundCIImage = [CIImage imageWithCGImage:backgroundImage.CGImage];

  CIFilter *compositeFilter = [CIFilter filterWithName:@"CISourceAtopCompositing"
                                   withInputParameters:@{
                                     @"inputImage" : foregroundCIImage,
                                     @"inputBackgroundImage" : backgroundCIImage,
                                   }];

  return [UIImage imageWithCIImage:compositeFilter.outputImage];
}

@implementation FBLCImageGraphicsRenderer

- (UIImage *)renderImage:(UIImage *)image
                geometry:(FBLCImageGeometryData *)geometry
                 options:(FBLCRenderingOptions *)options {
  UIImage *geometryImage = RenderGeometryImage(image.size, image.scale, geometry, options);

  return CompositeImages(geometryImage, image);
}

@end
