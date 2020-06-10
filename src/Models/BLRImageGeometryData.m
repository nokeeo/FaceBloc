//
//  BLRImageMetaData.m
//  Blur
//
//  Created by Eric Lee on 6/4/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import "BLRImageGeometryData.h"

@implementation BLRImageGeometryData

+ (instancetype)geometryWithFaceObservations:(NSArray<VNDetectedObjectObservation *> *)faceObservations obfuscationPaths:(nullable NSArray<BLRPath *> *)obfuscationPaths {
  return [[self alloc] initWithFaceObservations:faceObservations obfuscationPaths:obfuscationPaths];
}

- (instancetype)initWithFaceObservations:(NSArray<VNDetectedObjectObservation *> *)faceObservations obfuscationPaths:(nullable NSArray<BLRPath *> *)obfuscationPaths {
  self = [super init];
  if (self) {
    _faceObservations = faceObservations;
    _obfuscationPaths = obfuscationPaths;
  }
  
  return self;
}

@end

