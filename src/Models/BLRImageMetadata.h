#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UIBezierPath;
@class VNDetectedObjectObservation;

@interface BLRImageMetadata : NSObject <NSMutableCopying>

@property(nonatomic, readonly, nullable) NSArray<VNDetectedObjectObservation *> *faceObservations;

@property(nonatomic, readonly, nullable) NSArray<UIBezierPath *> *obfuscationPaths;

+ (instancetype)metadataWithFaceObservations:(nullable NSArray<VNDetectedObjectObservation *> *)faceObservations obfuscationPaths:(nullable NSArray<UIBezierPath *> *)obfuscationPaths;

- (instancetype)init NS_UNAVAILABLE;

@end

@interface BLRMutableImageMetadata : BLRImageMetadata

@property(nonatomic, readwrite, nullable) NSArray<VNDetectedObjectObservation *> *faceObservations;

@end

NS_ASSUME_NONNULL_END
