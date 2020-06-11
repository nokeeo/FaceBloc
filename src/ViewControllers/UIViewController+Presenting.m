//
//  UIViewController+Presenting.m
//  Blur
//
//  Created by Eric Lee on 6/6/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import "UIViewController+Presenting.h"

@implementation UIViewController (Presenting)

- (void)fblc_dismissViewController:(id)sender {
  UIViewController *targetViewController = [self targetViewControllerForAction:@selector(fblc_dismissViewController:) sender:self];
  if (targetViewController) {
    [targetViewController fblc_dismissViewController:self];
  } else {
    [self dismissViewControllerAnimated:YES completion:nil];
  }
}

@end
