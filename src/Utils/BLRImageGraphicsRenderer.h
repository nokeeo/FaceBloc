//
//  BLRImageGraphicsRenderer.h
//  Blur
//
//  Created by Eric Lee on 6/8/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BLRImageGeometryData;
@class BLRRenderingOptions;
@class UIImage;

NS_ASSUME_NONNULL_BEGIN

@interface BLRImageGraphicsRenderer : NSObject

- (UIImage *)renderImage:(UIImage *)image geometry:(BLRImageGeometryData *)geometry options:(BLRRenderingOptions *)options;

@end

NS_ASSUME_NONNULL_END
