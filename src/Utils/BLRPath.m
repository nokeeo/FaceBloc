//
//  BLRTouchCollector.m
//  Blur
//
//  Created by Eric Lee on 6/6/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import "BLRPath.h"

#import <CoreGraphics/CoreGraphics.h>

#import "BLRCGUtils.h"

struct BLRPathNormalizePathInfo {
  CGMutablePathRef outputPath;
  CGSize targetSize;
};

static void ProcessNormalizedPath(void *info, const CGPathElement *element) {
  struct BLRPathNormalizePathInfo normalizeInfo = *(struct BLRPathNormalizePathInfo *)info;
  switch (element->type) {
    case kCGPathElementMoveToPoint: {
      CGPoint point = BLRPointForNormalPoint(element->points[0], normalizeInfo.targetSize);
      CGPathMoveToPoint(normalizeInfo.outputPath, nil, point.x, point.y);
      break;
    }
    case kCGPathElementAddLineToPoint: {
      CGPoint point = BLRPointForNormalPoint(element->points[0], normalizeInfo.targetSize);
      CGPathAddLineToPoint(normalizeInfo.outputPath, nil, point.x, point.y);
      break;
    }
    case kCGPathElementAddCurveToPoint: {
      CGSize targetSize = normalizeInfo.targetSize;
      CGPoint controlPoint1 = BLRPointForNormalPoint(element->points[0], targetSize);
      CGPoint controlPoint2 = BLRPointForNormalPoint(element->points[1], targetSize);
      CGPoint endPoint = BLRPointForNormalPoint(element->points[2], targetSize);
      CGPathAddCurveToPoint(normalizeInfo.outputPath, nil, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, endPoint.x, endPoint.y);
      break;
    }
    case kCGPathElementAddQuadCurveToPoint: {
      CGSize targetSize = normalizeInfo.targetSize;
      CGPoint controlPoint = BLRPointForNormalPoint(element->points[0], targetSize);
      CGPoint endPoint = BLRPointForNormalPoint(element->points[1], targetSize);
      CGPathAddQuadCurveToPoint(normalizeInfo.outputPath, nil, controlPoint.x, controlPoint.y, endPoint.x, endPoint.y);
      break;
    }
    case kCGPathElementCloseSubpath:
      CGPathCloseSubpath(normalizeInfo.outputPath);
  }
}

@implementation BLRPath {
  CGPathRef _path;
  
  CGPathRef _denormalizedPath;
  CGSize _denormalizedTargetSize;
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
  
  if (_denormalizedPath) {
    CGPathRelease(_denormalizedPath);
  }
}

- (CGPathRef)CGPathForSize:(CGSize)size {
  if (_denormalizedPath && CGSizeEqualToSize(size, _denormalizedTargetSize)) {
    return _denormalizedPath;
  }
  
  if (_denormalizedPath) {
    CGPathRelease(_denormalizedPath);
    _denormalizedPath = NULL;
  }
  
  CGMutablePathRef denormalizedPath = CGPathCreateMutable();
  struct BLRPathNormalizePathInfo info = {
    .outputPath = denormalizedPath,
    .targetSize = size
  };
  
  CGPathApply(_path, &info, ProcessNormalizedPath);
  _denormalizedPath = denormalizedPath;
  
  return denormalizedPath;
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
