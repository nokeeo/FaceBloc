//
//  UINavigationController+Presenting.m
//  Blur
//
//  Created by Eric Lee on 6/6/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

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
