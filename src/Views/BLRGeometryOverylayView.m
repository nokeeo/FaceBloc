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
    _renderingOptions = [BLRRenderingOptions optionsWithTargetSize:frame.size shouldObscureFaces:YES];
    self.opaque = NO;
  }
  
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  BLRRenderingOptions *options = [BLRRenderingOptions optionsWithTargetSize:self.bounds.size shouldObscureFaces:_renderingOptions.shouldObscureFaces];
  self.renderingOptions = options;
}

- (void)drawRect:(CGRect)rect {
  if (!_geometry && !_renderingOptions) {
    return;
  }
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGContextClearRect(context, rect);
  CGContextClipToRect(context, rect);
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
