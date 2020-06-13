// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.md, included with
// this project.

#import "UIViewController+Presenting.h"

@implementation UIViewController (Presenting)

- (void)fblc_dismissViewController:(id)sender {
  UIViewController *targetViewController = [self targetViewControllerForAction:@selector(fblc_dismissViewController:)
                                                                        sender:self];
  if (targetViewController) {
    [targetViewController fblc_dismissViewController:self];
  } else {
    [self dismissViewControllerAnimated:YES completion:nil];
  }
}

@end
