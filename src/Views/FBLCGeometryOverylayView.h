// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.txt, included with
// this project.

#import <UIKit/UIKit.h>

@class FBLCImageGeometryData;
@class FBLCRenderingOptions;

NS_ASSUME_NONNULL_BEGIN

@interface FBLCGeometryOverylayView : UIView

@property(nonatomic) FBLCImageGeometryData *geometry;

@property(nonatomic) FBLCRenderingOptions *renderingOptions;

@end

NS_ASSUME_NONNULL_END
