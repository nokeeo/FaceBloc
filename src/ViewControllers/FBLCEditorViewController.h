// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.txt, included with
// this project.

#import <UIKit/UIKit.h>

#import "FBLCEditorBottomNavigationView.h"

#import "FBLCImageViewController.h"

@protocol FBLCEditorViewControllerDelegate;

NS_ASSUME_NONNULL_BEGIN

/** The view controller that presents the user interface for editing an imported photo. */
@interface FBLCEditorViewController
    : UIViewController <FBLCEditorBottomNavigationViewDelegate, FBLCImageViewControllerDelegate>

/** The object that receives callback events on the status of editing. */
@property(nonatomic, nullable, weak) id<FBLCEditorViewControllerDelegate> delegate;

/** Initializes the editor with a URL to an image on the device's file system. */
- (instancetype)initWithImageURL:(nullable NSURL *)imageURL;

@end

/** Objects conform to this protocol to receive status updates on the progress of editing. */
@protocol FBLCEditorViewControllerDelegate <NSObject>

/** Indicates that the user has cancelled editing. The given editor view controller should be dismissed. */
- (void)editorViewControllerDidCancelEditing:(FBLCEditorViewController *)editorViewController;

/**
 * Indicates that user has finished editing the image.
 * @param finalImage The edited image.
 */
- (void)editorViewController:(FBLCEditorViewController *)editorViewController
    didFinishEditingWithFinalImage:(UIImage *)finalImage;

@end

NS_ASSUME_NONNULL_END
