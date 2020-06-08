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

NS_ASSUME_NONNULL_BEGIN

extern void BLRDrawImageGeometryInContext(CGContextRef context, BLRImageGeometryData *geometry);

extern CGPoint BLRNormalizePoint(CGPoint point, CGSize bounds);

NS_ASSUME_NONNULL_END
