//
//  BLRStrokeWidthIndicatorView.m
//  Blur
//
//  Created by Eric Lee on 6/9/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import "BLRStrokeWidthIndicatorLayer.h"

static CGPathRef CreatePathForStrokeWidth(CGSize imageSize, CGRect bounds, CGFloat strokeWidth, CGFloat zoomLevel) {
  CGFloat indicatorRadius = floor((imageSize.width * strokeWidth) / 2.f * zoomLevel);
  CGPoint indicatorCenter = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));

  CGMutablePathRef path = CGPathCreateMutable();
  CGPathAddArc(path, nil, indicatorCenter.x, indicatorCenter.y, indicatorRadius, 0, M_PI * 2, 1);
  
  return path;
}

@implementation BLRStrokeWidthIndicatorLayer

@synthesize normalStrokeWidth = _normalStrokeWidth, zoomLevel = _zoomLevel;

- (instancetype)initWithNormalStrokeWidth:(CGFloat)normalStrokeWidth zoomLevel:(CGFloat)zoomLevel {
  self = [super init];
  if (self) {
    _normalStrokeWidth = normalStrokeWidth;
    _zoomLevel = zoomLevel;
    
    self.fillColor = UIColor.clearColor.CGColor;
    self.strokeColor = UIColor.redColor.CGColor;
    self.lineDashPattern = @[@5, @5];
    self.lineWidth = 2.5;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
    
  }
  
  return self;
}

- (void)layoutSublayers {
  [super layoutSublayers];
  
  CGPathRef path = CreatePathForStrokeWidth(CGSizeZero, self.bounds, _normalStrokeWidth, _zoomLevel);
  self.path = path;
  CGPathRelease(path);
}

- (void)setNormalStrokeWidth:(CGFloat)normalStrokeWidth zoomLevel:(CGFloat)zoomLevel imageSize:(CGSize)imageSize{
  _normalStrokeWidth = normalStrokeWidth;
  _zoomLevel = zoomLevel;
  
  CGPathRef path = CreatePathForStrokeWidth(imageSize, self.bounds, _normalStrokeWidth, _zoomLevel);
  self.path = path;
  CGPathRelease(path);
}

@end
