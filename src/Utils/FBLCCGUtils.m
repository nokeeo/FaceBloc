// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.md, included with
// this project.

#import "FBLCCGUtils.h"

#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import <Vision/Vision.h>

#import "FBLCImageGeometryData.h"
#import "FBLCPath.h"
#import "FBLCRenderingOptions.h"

/** Returns the color to render geometry. */
static CGColorRef GetRenderingColor() {
  static UIColor *color;
  static dispatch_once_t token;
  dispatch_once(&token, ^{
    color = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
  });

  return color.CGColor;
}

/** Draws the rects that obscure the faces in a photo. */
static void DrawFaceObfuscationRects(CGContextRef context, NSArray<VNDetectedObjectObservation *> *observations,
                                     CGSize targetSize) {
  CGContextSaveGState(context);

  CGContextScaleCTM(context, 1, -1);
  CGContextTranslateCTM(context, 0, -targetSize.height);
  CGContextSetFillColorWithColor(context, GetRenderingColor());
  for (VNDetectedObjectObservation *observation in observations) {
    CGRect faceRect = FBLCRectForNormalRect(observation.boundingBox, targetSize);
    CGContextFillRect(context, faceRect);
  }

  CGContextRestoreGState(context);
}

/** Renders the path that the user has drawn. */
static void DrawObfuscationPaths(CGContextRef context, NSArray<FBLCPath *> *paths, CGSize targetSize) {
  CGContextSaveGState(context);

  CGContextSetStrokeColorWithColor(context, GetRenderingColor());
  for (FBLCPath *path in paths) {
    CGContextAddPath(context, [path CGPathForSize:targetSize]);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, [path strokeWidth] * targetSize.width);
    CGContextStrokePath(context);
  }

  CGContextRestoreGState(context);
}

void FBLCDrawImageGeometryInContext(CGContextRef context, FBLCImageGeometryData *geometry,
                                    FBLCRenderingOptions *options) {
  CGSize targetSize = options.targetSize;
  if (options.shouldObscureFaces) {
    DrawFaceObfuscationRects(context, geometry.faceObservations, targetSize);
  }

  DrawObfuscationPaths(context, geometry.obfuscationPaths, targetSize);
}

CGPoint FBLCNormalizePoint(CGPoint point, CGSize bounds) {
  return CGPointMake(point.x / bounds.width, point.y / bounds.height);
}

CGPoint FBLCPointForNormalPoint(CGPoint normalPoint, CGSize bounds) {
  return CGPointMake(normalPoint.x * bounds.width, normalPoint.y * bounds.height);
}

CGRect FBLCRectForNormalRect(CGRect rect, CGSize bounds) {
  return CGRectMake(CGRectGetMinX(rect) * bounds.width, CGRectGetMinY(rect) * bounds.height,
                    CGRectGetWidth(rect) * bounds.width, CGRectGetHeight(rect) * bounds.height);
}
