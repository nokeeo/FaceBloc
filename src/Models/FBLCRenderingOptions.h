//
//  FBLCRenderingOptions.h
//  Blur
//
//  Created by Eric Lee on 6/7/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBLCRenderingOptions : NSObject

@property (nonatomic) BOOL shouldObscureFaces;

@property (nonatomic) CGSize targetSize;

+ (instancetype)optionsWithTargetSize:(CGSize)targetSize shouldObscureFaces:(BOOL)shouldObscureFaces;

- (instancetype)init NS_UNAVAILABLE;

@end
NS_ASSUME_NONNULL_END
