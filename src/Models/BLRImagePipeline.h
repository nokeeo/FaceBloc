//
//  BLRImagePipeline.h
//  Blur
//
//  Created by Eric Lee on 6/4/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreImage/CoreImage.h>

@class BLRImageMetadata;
@class UIImage;

NS_ASSUME_NONNULL_BEGIN

typedef void (^BLRImagePipelineCompletion)(UIImage *processedImage);

@interface BLRImagePipeline : NSObject

- (void)processImage:(UIImage *)image withMetaData:(BLRImageMetadata *)metadata completion:(BLRImagePipelineCompletion)completion;

@end

NS_ASSUME_NONNULL_END
