//
//  FBLCCGUtils.h
//  Blur
//
//  Created by Eric Lee on 6/7/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

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
