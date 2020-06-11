//
//  BLRCGUtils.h
//  Blur
//
//  Created by Eric Lee on 6/7/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

@class BLRImageGeometryData;
@class BLRRenderingOptions;

NS_ASSUME_NONNULL_BEGIN

extern void BLRDrawImageGeometryInContext(CGContextRef context, BLRImageGeometryData *geometry, BLRRenderingOptions *options);

extern CGPoint BLRNormalizePoint(CGPoint point, CGSize bounds);

extern CGPoint BLRPointForNormalPoint(CGPoint normalPoint, CGSize bounds);

extern CGRect BLRRectForNormalRect(CGRect rect, CGSize bounds);

NS_ASSUME_NONNULL_END
