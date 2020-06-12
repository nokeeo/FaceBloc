// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.txt, included with
// this project.

#import "UIViewController+NSError.h"

#import "LocalizationIDs.h"

@implementation UIViewController (NSError)

- (void)fblc_presentError:(NSError *)error {
  NSString *localizedDescription = error.localizedDescription;
  if (localizedDescription.length == 0) {
    return;
  }

  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                           message:localizedDescription
                                                                    preferredStyle:UIAlertControllerStyleAlert];

  NSString *title = NSLocalizedString(FBLCErrorDialogConfirmationTitle, nil);

  // Use weak to avoid potential retain cycle:
  //  Alert VC->Action->Action Block->Alert VC
  __weak UIAlertController *weakAlertController = alertController;
  UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:title
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *_Nonnull action) {
                                                          [weakAlertController dismissViewControllerAnimated:YES
                                                                                                  completion:nil];
                                                        }];
  [alertController addAction:confirmAction];

  [self presentViewController:alertController animated:YES completion:nil];
}

@end
