//
//  BLRCGUtils.m
//  Blur
//
//  Created by Eric Lee on 6/7/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import "BLRCGUtils.h"

#import <CoreGraphics/CoreGraphics.h>
#import <Vision/Vision.h>
#import <UIKit/UIKit.h>

#import "BLRPath.h"
#import "BLRImageGeometryData.h"
#import "BLRRenderingOptions.h"

static CGColorRef GetRenderingColor() {
  static UIColor *color;
  static dispatch_once_t token;
  dispatch_once(&token, ^{
    color = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
  });
  
  return color.CGColor;
}

static void DrawFaceObfuscationRects(CGContextRef context, NSArray<VNDetectedObjectObservation *> *observations) {
  CGContextSaveGState(context);
  
  CGContextScaleCTM(context, 1, -1);
  CGContextTranslateCTM(context, 0, -1);
  CGContextSetFillColorWithColor(context, GetRenderingColor());
  for (VNDetectedObjectObservation *observation in observations) {
    CGContextFillRect(context, observation.boundingBox);
  }
  
  CGContextRestoreGState(context);
}

static void DrawObfuscationPaths(CGContextRef context, NSArray<BLRPath *> *paths) {
  CGContextSaveGState(context);
  
  CGContextSetStrokeColorWithColor(context, GetRenderingColor());
  for (BLRPath *path in paths) {
    CGContextAddPath(context, [path CGPath]);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, [path strokeWidth]);
    CGContextStrokePath(context);
  }
  
  CGContextRestoreGState(context);
}

void BLRDrawImageGeometryInContext(CGContextRef context, BLRImageGeometryData *geometry, BLRRenderingOptions *options) {
  if (options.shouldObscureFaces) {
    DrawFaceObfuscationRects(context, geometry.faceObservations);
  }
  
  DrawObfuscationPaths(context, geometry.obfuscationPaths);
}

CGPoint BLRNormalizePoint(CGPoint point, CGSize bounds) {
  return CGPointMake(point.x / bounds.width, point.y / bounds.height);
}
