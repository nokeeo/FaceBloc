//
//  UIViewController+NSError.m
//  Blur
//
//  Created by Eric Lee on 6/7/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import "UIViewController+NSError.h"

#import "LocalizationIDs.h"

@implementation UIViewController (NSError)

- (void)blr_presentError:(NSError *)error {
  NSString *localizedDescription = error.localizedDescription;
  if (localizedDescription.length == 0) {
    return;
  }
  
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:localizedDescription preferredStyle:UIAlertControllerStyleAlert];
  
  NSString *title = NSLocalizedString(BLRErrorDialogConfirmationTitle, nil);
  
  // Use weak to avoid potential retain cycle:
  //  Alert VC->Action->Action Block->Alert VC
  __weak UIAlertController *weakAlertController = alertController;
  UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    [weakAlertController dismissViewControllerAnimated:YES completion:nil];
  }];
  [alertController addAction:confirmAction];
  
  [self presentViewController:alertController animated:YES completion:nil];
}

@end
