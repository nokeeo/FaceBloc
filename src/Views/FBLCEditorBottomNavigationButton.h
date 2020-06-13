// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.md, included with
// this project.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** The button that appears in the bottom navigation view. */
@interface FBLCEditorBottomNavigationButton : UIButton

/** Indicates if the button is styled as selected. */
@property(nonatomic, getter=isOn) BOOL on;

/** Sets @c on . */
- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
