#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class VNDetectedObjectObservation;

@interface BLRImageMetadata : NSObject

@property(nonatomic, readonly) NSArray<VNDetectedObjectObservation *> *faceObservations;

+ (instancetype)metadataWithFaceObservations:(NSArray<VNDetectedObjectObservation *> *)faceObservations;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
