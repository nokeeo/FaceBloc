// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.md, included with
// this project.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** An extension of the navigation controller to handle context independent presentation requests. */
@interface UINavigationController (Presenting)

- (void)fblc_dismissViewController:(id)sender;

@end

NS_ASSUME_NONNULL_END
