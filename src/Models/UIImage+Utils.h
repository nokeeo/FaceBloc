//
// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.txt, included with
// this project.

#import <UIKit/UIKit.h>

@class CIImage;

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Utils)

@property(nonatomic, readonly) CIImage *fblc_CIImage;

@property(nonatomic, readonly) CGImagePropertyOrientation fblc_CGOrientation;

@end

NS_ASSUME_NONNULL_END
