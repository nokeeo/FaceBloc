//
//  BLRGeometryOverylayView.m
//  Blur
//
//  Created by Eric Lee on 6/7/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import "BLRGeometryOverylayView.h"

#import "BLRCGUtils.h"

@implementation BLRGeometryOverylayView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.opaque = NO;
  }
  
  return self;
}

- (void)drawRect:(CGRect)rect {
  if (!_geometry) {
    return;
  }
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGSize viewSize = self.bounds.size;
  CGContextClearRect(context, rect);
  CGContextClipToRect(context, rect);
  
  CGContextScaleCTM(context, viewSize.width, viewSize.height);
  BLRDrawImageGeometryInContext(context, _geometry);
}

#pragma mark - Setters

- (void)setGeometry:(BLRImageGeometryData *)geometry {
  _geometry = geometry;
  [self setNeedsDisplay];
}

@end
