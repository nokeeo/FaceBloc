//
//  BLRGeometryOverylayView.m
//  Blur
//
//  Created by Eric Lee on 6/7/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import "BLRGeometryOverylayView.h"

#import "BLRCGUtils.h"
#import "BLRImageGeometryData.h"
#import "BLRRenderingOptions.h"

@implementation BLRGeometryOverylayView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _geometry = [BLRImageGeometryData geometryWithFaceObservations:nil obfuscationPaths:nil];
    _renderingOptions = [BLRRenderingOptions optionsWithShouldObscureFaces:YES];
    self.opaque = NO;
  }
  
  return self;
}

- (void)drawRect:(CGRect)rect {
  if (!_geometry && !_renderingOptions) {
    return;
  }
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGSize viewSize = self.bounds.size;
  CGContextClearRect(context, rect);
  CGContextClipToRect(context, rect);
  
  // The geometry in the plain old data object is normalized. Scale the coordinate system to
  // the size of the view.
  CGContextScaleCTM(context, viewSize.width, viewSize.height);
  BLRDrawImageGeometryInContext(context, _geometry, _renderingOptions);
}

#pragma mark - Setters

- (void)setGeometry:(BLRImageGeometryData *)geometry {
  _geometry = geometry;
  [self setNeedsDisplay];
}

- (void)setRenderingOptions:(BLRRenderingOptions *)renderingOptions {
  _renderingOptions = renderingOptions;
  [self setNeedsDisplay];
}

@end
