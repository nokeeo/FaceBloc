// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.md, included with
// this project.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** An extension of UIViewController used to display NSErrors. */
@interface UIViewController (NSError)

/**
 * Displays the UI for the given error. If the given error does not have a localized description, this method results in
 * a nil op.
 */
- (void)fblc_presentError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
