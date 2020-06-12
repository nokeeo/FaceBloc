// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.txt, included with
// this project.

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

@class FBLCImageGeometryData;
@class FBLCRenderingOptions;

NS_ASSUME_NONNULL_BEGIN

extern void FBLCDrawImageGeometryInContext(CGContextRef context, FBLCImageGeometryData *geometry, FBLCRenderingOptions *options);

extern CGPoint FBLCNormalizePoint(CGPoint point, CGSize bounds);

extern CGPoint FBLCPointForNormalPoint(CGPoint normalPoint, CGSize bounds);

extern CGRect FBLCRectForNormalRect(CGRect rect, CGSize bounds);

NS_ASSUME_NONNULL_END
