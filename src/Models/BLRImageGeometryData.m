//
//  BLRImageMetaData.m
//  Blur
//
//  Created by Eric Lee on 6/4/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import "BLRImageGeometryData.h"

@implementation BLRImageGeometryData

+ (instancetype)metadataWithFaceObservations:(NSArray<VNDetectedObjectObservation *> *)faceObservations obfuscationPaths:(nullable NSArray<UIBezierPath *> *)obfuscationPaths {
  return [[self alloc] initWithFaceObservations:faceObservations obfuscationPaths:obfuscationPaths];
}

- (instancetype)initWithFaceObservations:(NSArray<VNDetectedObjectObservation *> *)faceObservations obfuscationPaths:(nullable NSArray<UIBezierPath *> *)obfuscationPaths {
  self = [super init];
  if (self) {
    _faceObservations = faceObservations;
    _obfuscationPaths = obfuscationPaths;
  }
  
  return self;
}

# pragma mark NSMutableCopying

- (id)mutableCopyWithZone:(NSZone *)zone {
  return [BLRMutableImageMetadata metadataWithFaceObservations:[_faceObservations copy] obfuscationPaths:[_obfuscationPaths copy]];
}

@end

#pragma mark -

@implementation BLRMutableImageMetadata
@end

