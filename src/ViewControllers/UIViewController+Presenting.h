// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.txt, included with
// this project.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** An extension of the navigation controller to handle context independent presentation requests. */
@interface UIViewController (Presenting)

/**
 * Searches up the view controller hierarchy for the first view controller that overrides this method and calls this
 * method on said view controller. If no container view controller overrides this method, the modal dismiss,
 * @c dismissViewControllerAnimated:completion is called on the receiver.
 */
- (void)fblc_dismissViewController:(id)sender;

@end

NS_ASSUME_NONNULL_END
