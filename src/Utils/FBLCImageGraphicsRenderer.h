// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.txt, included with
// this project.

#import <Foundation/Foundation.h>

@class FBLCImageGeometryData;
@class FBLCRenderingOptions;
@class UIImage;

NS_ASSUME_NONNULL_BEGIN

@interface FBLCImageGraphicsRenderer : NSObject

- (UIImage *)renderImage:(UIImage *)image
                geometry:(FBLCImageGeometryData *)geometry
                 options:(FBLCRenderingOptions *)options;

@end

NS_ASSUME_NONNULL_END
