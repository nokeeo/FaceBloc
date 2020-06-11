//
//  FBLCImageGraphicsRenderer.h
//  Blur
//
//  Created by Eric Lee on 6/8/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FBLCImageGeometryData;
@class FBLCRenderingOptions;
@class UIImage;

NS_ASSUME_NONNULL_BEGIN

@interface FBLCImageGraphicsRenderer : NSObject

- (UIImage *)renderImage:(UIImage *)image geometry:(FBLCImageGeometryData *)geometry options:(FBLCRenderingOptions *)options;

@end

NS_ASSUME_NONNULL_END
