//
//  BLRTouchCollector.h
//  Blur
//
//  Created by Eric Lee on 6/6/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLRPath : NSObject

@property(nonatomic, readonly) CGPathRef CGPath;

- (void)addPoint:(CGPoint)point;

- (void)clear;

@end

NS_ASSUME_NONNULL_END
