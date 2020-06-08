#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UIBezierPath;
@class VNDetectedObjectObservation;

@interface BLRImageGeometryData : NSObject <NSMutableCopying>

@property(nonatomic, readonly, nullable) NSArray<VNDetectedObjectObservation *> *faceObservations;

@property(nonatomic, readonly, nullable) NSArray<UIBezierPath *> *obfuscationPaths;

+ (instancetype)metadataWithFaceObservations:(nullable NSArray<VNDetectedObjectObservation *> *)faceObservations obfuscationPaths:(nullable NSArray<UIBezierPath *> *)obfuscationPaths;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
