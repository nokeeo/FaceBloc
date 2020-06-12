// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.txt, included with
// this project.

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
