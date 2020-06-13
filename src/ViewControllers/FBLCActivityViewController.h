// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.md, included with
// this project.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** The object that coordinates the presentation of @c FBLCActivityViewController . */
@interface FBLCActivityViewPresentationController : UIPresentationController
@end

/**
 * The view controller that indicates that the application is busy. When presented modally, this view controller
 * prevents interaction with content beneath it.
 */
@interface FBLCActivityViewController : UIViewController <UIViewControllerTransitioningDelegate>
@end

NS_ASSUME_NONNULL_END
