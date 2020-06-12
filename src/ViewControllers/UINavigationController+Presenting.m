// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.txt, included with
// this project.

#import "UINavigationController+Presenting.h"

#import "UIViewController+Presenting.h"

@implementation UINavigationController (Presenting)

- (void)fblc_dismissViewController:(id)sender {
  NSUInteger index = [self.viewControllers indexOfObject:sender];
  if (index != NSNotFound && index != 0 && index < self.viewControllers.count) {
    UIViewController *viewControllerToPopTo = self.viewControllers[index - 1];
    [self popToViewController:viewControllerToPopTo animated:YES];
  } else {
    [self.parentViewController fblc_dismissViewController:sender];
  }
}

@end
