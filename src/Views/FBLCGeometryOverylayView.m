// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.txt, included with
// this project.

#import "FBLCGeometryOverylayView.h"

#import "FBLCCGUtils.h"
#import "FBLCImageGeometryData.h"
#import "FBLCRenderingOptions.h"

@implementation FBLCGeometryOverylayView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _geometry = [FBLCImageGeometryData geometryWithFaceObservations:nil obfuscationPaths:nil];
    _renderingOptions = [FBLCRenderingOptions optionsWithTargetSize:frame.size shouldObscureFaces:YES];
    self.opaque = NO;
  }
  
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  FBLCRenderingOptions *options = [FBLCRenderingOptions optionsWithTargetSize:self.bounds.size shouldObscureFaces:_renderingOptions.shouldObscureFaces];
  self.renderingOptions = options;
}

- (void)drawRect:(CGRect)rect {
  if (!_geometry && !_renderingOptions) {
    return;
  }
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGContextClearRect(context, rect);
  CGContextClipToRect(context, rect);
  FBLCDrawImageGeometryInContext(context, _geometry, _renderingOptions);
}

#pragma mark - Setters

- (void)setGeometry:(FBLCImageGeometryData *)geometry {
  _geometry = geometry;
  [self setNeedsDisplay];
}

- (void)setRenderingOptions:(FBLCRenderingOptions *)renderingOptions {
  _renderingOptions = renderingOptions;
  [self setNeedsDisplay];
}

@end
