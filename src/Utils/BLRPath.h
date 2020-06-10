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

@interface BLRPath : NSObject <NSMutableCopying>

- (instancetype)initWithPath:(CGPathRef)path NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (CGPathRef)CGPath;

- (CGFloat)strokeWidth;

@end

@interface BLRMutablePath : BLRPath

@property(nonatomic) CGFloat strokeWidth;

- (instancetype)init;

- (void)addPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
