// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.md, included with
// this project.

#import <UIKit/UIKit.h>

#import "FBLCEditorViewController.h"
#import "FBLCRootView.h"

/** The root view controller of the application's navigation controller. */
@interface FBLCRootViewController : UIViewController <FBLCEditorViewControllerDelegate,
                                                      FBLCRootViewDelegate,
                                                      UIImagePickerControllerDelegate,
                                                      UINavigationControllerDelegate>
@end
