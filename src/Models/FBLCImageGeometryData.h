// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.txt, included with
// this project.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FBLCPath;
@class UIBezierPath;
@class VNDetectedObjectObservation;

@interface FBLCImageGeometryData : NSObject

@property(nonatomic, readonly, nullable) NSArray<VNDetectedObjectObservation *> *faceObservations;

@property(nonatomic, readonly, nullable) NSArray<FBLCPath *> *obfuscationPaths;

+ (instancetype)geometryWithFaceObservations:(nullable NSArray<VNDetectedObjectObservation *> *)faceObservations
                            obfuscationPaths:(nullable NSArray<FBLCPath *> *)obfuscationPaths;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
