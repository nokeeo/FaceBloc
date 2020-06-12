// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.txt, included with
// this project.

#import "FBLCStrokeWidthIndicatorLayer.h"

static CGPathRef CreatePathForStrokeWidth(CGSize imageSize, CGRect bounds, CGFloat strokeWidth, CGFloat zoomLevel) {
  CGFloat indicatorRadius = floor((imageSize.width * strokeWidth) / 2.f * zoomLevel);
  CGPoint indicatorCenter = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));

  CGMutablePathRef path = CGPathCreateMutable();
  CGPathAddArc(path, nil, indicatorCenter.x, indicatorCenter.y, indicatorRadius, 0, M_PI * 2, 1);
  
  return path;
}

@implementation FBLCStrokeWidthIndicatorLayer

@synthesize normalStrokeWidth = _normalStrokeWidth, zoomLevel = _zoomLevel;

- (instancetype)initWithNormalStrokeWidth:(CGFloat)normalStrokeWidth zoomLevel:(CGFloat)zoomLevel {
  self = [super init];
  if (self) {
    _normalStrokeWidth = normalStrokeWidth;
    _zoomLevel = zoomLevel;
    
    self.fillColor = UIColor.clearColor.CGColor;
    self.strokeColor = [UIColor colorWithRed:45.f/255.f green:153.f/255.f blue:252.f/255.f alpha:1].CGColor;
    self.lineDashPattern = @[@5, @5];
    self.lineWidth = 2.5;
  }
  
  return self;
}

- (void)layoutSublayers {
  [super layoutSublayers];
  
  CGPathRef path = CreatePathForStrokeWidth(CGSizeZero, self.bounds, _normalStrokeWidth, _zoomLevel);
  self.path = path;
  CGPathRelease(path);
}

- (void)setNormalStrokeWidth:(CGFloat)normalStrokeWidth zoomLevel:(CGFloat)zoomLevel imageSize:(CGSize)imageSize {
  _normalStrokeWidth = normalStrokeWidth;
  _zoomLevel = zoomLevel;
  
  CGPathRef path = CreatePathForStrokeWidth(imageSize, self.bounds, _normalStrokeWidth, _zoomLevel);
  self.path = path;
  CGPathRelease(path);
}

@end
