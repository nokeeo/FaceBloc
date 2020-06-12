// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.txt, included with
// this project.

#import <UIKit/UIKit.h>

#import "FBLCEditorBottomNavigationView.h"

#import "FBLCImageViewController.h"

@protocol FBLCEditorViewControllerDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface FBLCEditorViewController : UIViewController <FBLCEditorBottomNavigationViewDelegate, FBLCImageViewControllerDelegate>

@property(nonatomic, nullable, weak) id<FBLCEditorViewControllerDelegate> delegate;

- (instancetype)initWithImageURL:(nullable NSURL *)imageURL;

@end

@protocol FBLCEditorViewControllerDelegate <NSObject>

- (void)editorViewControllerDidCancelEditing:(FBLCEditorViewController *)editorViewController;

- (void)editorViewController:(FBLCEditorViewController *)editorViewController didFinishEditingWithFinalImage:(UIImage *)finalImage;

@end

NS_ASSUME_NONNULL_END
