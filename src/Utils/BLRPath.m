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
  CGPathRef _path;
}

- (instancetype)initWithPath:(CGPathRef)path {
  self = [super init];
  if (self) {
    CGPathRetain(path);
    _path = path;
  }
  
  return self;
}

- (void)dealloc {
  CGPathRelease(_path);
}

- (CGPathRef)CGPath {
  return _path;
}

- (CGFloat)strokeWidth {
  return 1;
}

#pragma mark - NSMutableCopying

- (id)mutableCopyWithZone:(NSZone *)zone {
  return [[BLRMutablePath alloc] initWithPath:_path];
}

@end

@implementation BLRMutablePath {
  CGMutablePathRef _mutablePath;
}

- (instancetype)initWithPath:(CGPathRef)path {
  CGMutablePathRef mutablePath = CGPathCreateMutableCopy(path);
  self = [super initWithPath:mutablePath];
  if (!self) {
    CGPathRelease(mutablePath);
    return nil;
  }
  
  _mutablePath = mutablePath;
  
  return self;
}

- (instancetype)init {
  CGMutablePathRef mutablePath = CGPathCreateMutable();
  self = [super initWithPath:mutablePath];
  if (!self) {
    CGPathRelease(mutablePath);
    return nil;
  }
  
  _mutablePath = mutablePath;
  
  return self;
}

- (void)dealloc {
  CGPathRelease(_mutablePath);
}

- (void)addPoint:(CGPoint)point {
  if (!CGPathIsEmpty(_mutablePath)) {
     CGPathAddLineToPoint(_mutablePath, nil, point.x, point.y);
  }
  
   CGPathMoveToPoint(_mutablePath, nil, point.x, point.y);
}

@end
