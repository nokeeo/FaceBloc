// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.txt, included with
// this project.

#import "FBLCImageGeometryData.h"

@implementation FBLCImageGeometryData

+ (instancetype)geometryWithFaceObservations:(NSArray<VNDetectedObjectObservation *> *)faceObservations obfuscationPaths:(nullable NSArray<FBLCPath *> *)obfuscationPaths {
  return [[self alloc] initWithFaceObservations:faceObservations obfuscationPaths:obfuscationPaths];
}

- (instancetype)initWithFaceObservations:(NSArray<VNDetectedObjectObservation *> *)faceObservations obfuscationPaths:(nullable NSArray<FBLCPath *> *)obfuscationPaths {
  self = [super init];
  if (self) {
    _faceObservations = faceObservations;
    _obfuscationPaths = obfuscationPaths;
  }
  
  return self;
}

@end

