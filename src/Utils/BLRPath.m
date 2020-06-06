//
//  BLRTouchCollector.m
//  Blur
//
//  Created by Eric Lee on 6/6/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import "BLRPath.h"

#import <CoreGraphics/CoreGraphics.h>

@implementation BLRPath {
  CGMutablePathRef _path;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _path = CGPathCreateMutable();
  }
  
  return self;
}

- (void)dealloc {
  CGPathRelease(_path);
}

- (void)addPoint:(CGPoint)point {
  if (!CGPathIsEmpty(_path)) {
     CGPathAddLineToPoint(_path, nil, point.x, point.y);
  }
  
   CGPathMoveToPoint(_path, nil, point.x, point.y);
}

- (void)clear {
  CGPathRelease(_path);
  _path = CGPathCreateMutable();
}

#pragma mark - Getters

- (CGPathRef)CGPath {
  return CGPathCreateCopy(_path);
}

@end
