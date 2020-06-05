//
//  BLRImageMetaData.m
//  Blur
//
//  Created by Eric Lee on 6/4/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import "BLRImageMetadata.h"

@implementation BLRImageMetadata

+ (instancetype)metadataWithFaceObservations:(NSArray<VNDetectedObjectObservation *> *)faceObservations {
  return [[self alloc] initWithFaceObservations:faceObservations];
}

- (instancetype)initWithFaceObservations:(NSArray<VNDetectedObjectObservation *> *)faceObservations {
  self = [super init];
  if (self) {
    _faceObservations = faceObservations;
  }
  
  return self;
}

@end
