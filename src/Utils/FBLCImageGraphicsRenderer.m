//
//  FBLCImageGraphicsRenderer.m
//  Blur
//
//  Created by Eric Lee on 6/8/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import "FBLCImageGraphicsRenderer.h"

#import <UIKit/UIKit.h>

#import "FBLCCGUtils.h"

static UIImage *RenderGeometryImage(CGSize size, CGFloat scale, FBLCImageGeometryData *geometry, FBLCRenderingOptions *options) {
  UIGraphicsImageRendererFormat *format = [[UIGraphicsImageRendererFormat alloc] init];
  format.scale = scale;
  
  UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:size format:format];
  UIImage *geometryImage = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
    CGContextRef context = rendererContext.CGContext;
    FBLCDrawImageGeometryInContext(context, geometry, options);
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

@implementation FBLCImageGraphicsRenderer

- (UIImage *)renderImage:(UIImage *)image geometry:(FBLCImageGeometryData *)geometry options:(FBLCRenderingOptions *)options {
  UIImage *geometryImage = RenderGeometryImage(image.size, image.scale, geometry, options);
  
  return CompositeImages(geometryImage, image);
}

@end
