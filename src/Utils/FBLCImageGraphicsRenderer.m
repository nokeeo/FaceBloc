// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.md, included with
// this project.

#import "FBLCImageGraphicsRenderer.h"

#import <UIKit/UIKit.h>

#import "FBLCCGUtils.h"
#import "UIImage+Utils.h"

/**
 * Renders the geometry in an image of the given size and scale.
 * @param size The size in points to render the geometry.
 * @param scale The scale to multiply the size and geometry data by.
 * @param geometry The figures to render in the returned image.
 * @param options An object describing global rendering configuration.
 */
static UIImage *RenderGeometryImage(CGSize size, CGFloat scale, UIImageOrientation orientation,
                                    FBLCImageGeometryData *geometry, FBLCRenderingOptions *options) {
  UIGraphicsImageRendererFormat *format = [[UIGraphicsImageRendererFormat alloc] init];
  format.scale = scale;

  UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:size format:format];
  UIImage *geometryImage = [renderer imageWithActions:^(UIGraphicsImageRendererContext *_Nonnull rendererContext) {
    CGContextRef context = rendererContext.CGContext;
    FBLCDrawImageGeometryInContext(context, geometry, options);
  }];

  return [UIImage imageWithCGImage:geometryImage.CGImage scale:1 orientation:UIImageOrientationUp];
}

/** Transforms the first image such that the returned image has the same orientation as the second. */
static CIImage *OrientFirstImageToSecond(UIImage *image1, UIImage *image2) {
  CIImage *image1CI = image1.fblc_CIImage;
  CGAffineTransform transform = [image1CI imageTransformForCGOrientation:[image2 fblc_CGOrientation]];
  return [image1CI imageByApplyingTransform:transform];
}

/** Composites the given foreground image on the given background image. */
static UIImage *CompositeImages(UIImage *foregroundImage, UIImage *backgroundImage) {
  CIImage *foregroundCIImage = OrientFirstImageToSecond(foregroundImage, backgroundImage);
  CIImage *backgroundCIImage = [CIImage imageWithCGImage:backgroundImage.CGImage];

  CIFilter *compositeFilter = [CIFilter filterWithName:@"CISourceAtopCompositing"
                                   withInputParameters:@{
                                     @"inputImage" : foregroundCIImage,
                                     @"inputBackgroundImage" : backgroundCIImage,
                                   }];

  return [UIImage imageWithCIImage:compositeFilter.outputImage
                             scale:backgroundImage.scale
                       orientation:backgroundImage.imageOrientation];
}

@implementation FBLCImageGraphicsRenderer

- (UIImage *)renderImage:(UIImage *)image
                geometry:(FBLCImageGeometryData *)geometry
                 options:(FBLCRenderingOptions *)options {
  UIImage *geometryImage = RenderGeometryImage(image.size, image.scale, image.imageOrientation, geometry, options);

  return CompositeImages(geometryImage, image);
}

@end
