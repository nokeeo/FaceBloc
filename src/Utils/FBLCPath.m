// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.md, included with
// this project.

#import "FBLCPath.h"

#import <CoreGraphics/CoreGraphics.h>

#import "FBLCCGUtils.h"

/** The object passed to the callback function used to parse a normalized CGPath and output a denormalized path. */
struct FBLCPathNormalizePathInfo {
  /** The mutable denormalized path. */
  CGMutablePathRef outputPath;
  
  /** The target render size. */
  CGSize targetSize;
};

/**
 * Parses the normalized path element and appends the denormalized point(s) to the output path stored in the info object
 * @param info Expecting a pointer to the FBLCPathNormalizePathInfo struct.
 */
static void ProcessNormalizedPath(void *info, const CGPathElement *element) {
  struct FBLCPathNormalizePathInfo normalizeInfo = *(struct FBLCPathNormalizePathInfo *)info;
  switch (element->type) {
    case kCGPathElementMoveToPoint: {
      CGPoint point = FBLCPointForNormalPoint(element->points[0], normalizeInfo.targetSize);
      CGPathMoveToPoint(normalizeInfo.outputPath, nil, point.x, point.y);
      break;
    }
    case kCGPathElementAddLineToPoint: {
      CGPoint point = FBLCPointForNormalPoint(element->points[0], normalizeInfo.targetSize);
      CGPathAddLineToPoint(normalizeInfo.outputPath, nil, point.x, point.y);
      break;
    }
    case kCGPathElementAddCurveToPoint: {
      CGSize targetSize = normalizeInfo.targetSize;
      CGPoint controlPoint1 = FBLCPointForNormalPoint(element->points[0], targetSize);
      CGPoint controlPoint2 = FBLCPointForNormalPoint(element->points[1], targetSize);
      CGPoint endPoint = FBLCPointForNormalPoint(element->points[2], targetSize);
      CGPathAddCurveToPoint(normalizeInfo.outputPath, nil, controlPoint1.x, controlPoint1.y, controlPoint2.x,
                            controlPoint2.y, endPoint.x, endPoint.y);
      break;
    }
    case kCGPathElementAddQuadCurveToPoint: {
      CGSize targetSize = normalizeInfo.targetSize;
      CGPoint controlPoint = FBLCPointForNormalPoint(element->points[0], targetSize);
      CGPoint endPoint = FBLCPointForNormalPoint(element->points[1], targetSize);
      CGPathAddQuadCurveToPoint(normalizeInfo.outputPath, nil, controlPoint.x, controlPoint.y, endPoint.x, endPoint.y);
      break;
    }
    case kCGPathElementCloseSubpath:
      CGPathCloseSubpath(normalizeInfo.outputPath);
  }
}

@implementation FBLCPath {
  /** The path backing this object. The path's points are in normalized form. */
  CGPathRef _path;

  /** A cached reference of the last denormalized path. NULL if not set. */
  CGPathRef _denormalizedPath;
  
  /** The target size of the last denormalized path. Check @c _denormalizedPath is not NULL before using. */
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
  struct FBLCPathNormalizePathInfo info = {.outputPath = denormalizedPath, .targetSize = size};

  CGPathApply(_path, &info, ProcessNormalizedPath);
  _denormalizedPath = denormalizedPath;

  return denormalizedPath;
}

- (CGFloat)strokeWidth {
  // Subclasses may override this methods.
  return 1;
}

#pragma mark - NSMutableCopying

- (id)mutableCopyWithZone:(NSZone *)zone {
  return [[FBLCMutablePath alloc] initWithPath:_path];
}

@end

@implementation FBLCMutablePath {
  /** A reference to the mutable path backing this object. The path's points are in normalized form. */
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
  NSAssert(point.x >= 0 && point.x <= 1, @"Trying to add x coordinate (%f) not in normalized form.", point.x);
  NSAssert(point.y >= 0 && point.y <= 1, @"Trying to add y coordinate (%f)not in normalized form.", point.y);
  if (!CGPathIsEmpty(_mutablePath)) {
    CGPathAddLineToPoint(_mutablePath, nil, point.x, point.y);
  }

  CGPathMoveToPoint(_mutablePath, nil, point.x, point.y);
}

@end
