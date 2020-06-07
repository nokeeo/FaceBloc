//
//  ViewController.h
//  Blur
//
//  Created by Eric Lee on 6/4/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BLRRootView.h"
#import "BLREditorViewController.h"

@interface BLRRootViewController : UIViewController <BLREditorViewControllerDelegate, BLRRootViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@end

