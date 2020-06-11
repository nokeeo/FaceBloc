//
//  BLRImageGraphicsRenderer.m
//  Blur
//
//  Created by Eric Lee on 6/8/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import "BLRImageGraphicsRenderer.h"

#import <UIKit/UIKit.h>

#import "BLRCGUtils.h"

static UIImage *RenderGeometryImage(CGSize size, CGFloat scale, BLRImageGeometryData *geometry, BLRRenderingOptions *options) {
  UIGraphicsImageRendererFormat *format = [[UIGraphicsImageRendererFormat alloc] init];
  format.scale = scale;
  
  UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:size format:format];
  UIImage *geometryImage = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
    CGContextRef context = rendererContext.CGContext;
    BLRDrawImageGeometryInContext(context, geometry, options);
  }];
  
  return geometryImage;
}

static UIImage *CompositeImages(UIImage *foregroundImage, UIImage *backgroundImage) {
  CIImage *foregroundCIImage = [CIImage imageWithCGImage:foregroundImage.CGImage];
  CIImage *backgroundCIImage = [CIImage imageWithCGImage:backgroundImage.CGImage];
  
  CIFilter *compositeFilter = [CIFilter filterWithName:@"CISourceAtopCompositing" withInputParameters:@{
    @"inputImage" : foregroundCIImage,
    @"inputBackgroundImage" : backgroundCIImage,
  }];
  
  return [UIImage imageWithCIImage:compositeFilter.outputImage];
}

@implementation BLRImageGraphicsRenderer

- (UIImage *)renderImage:(UIImage *)image geometry:(BLRImageGeometryData *)geometry options:(BLRRenderingOptions *)options {
  UIImage *geometryImage = RenderGeometryImage(image.size, image.scale, geometry, options);
  
  return CompositeImages(geometryImage, image);
}

@end
