// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.md, included with
// this project.

#import "FBLCRootViewController.h"

#import "FBLCEditorViewController.h"
#import "FBLCPhotoLibraryService.h"
#import "FBLCRootView.h"
#import "UIViewController+Presenting.h"

@implementation FBLCRootViewController {
  /**
   * The view controller that is displayed to select an image from the photos library. Nil if not currently selected a
   * photo.
   */
  UIImagePickerController *_Nullable _mediaPickerController;
  
  /** The view controller presented to edit a user photo. Nil if not currently editing a photo. */
  FBLCEditorViewController *_Nullable _editorViewController;
}

- (void)loadView {
  FBLCRootView *rootView = [[FBLCRootView alloc] init];
  rootView.delegate = self;
  self.view = rootView;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationController.navigationBarHidden = YES;
}

#pragma mark - FBLCEditoViewControllerDelegate

- (void)editorViewControllerDidCancelEditing:(FBLCEditorViewController *)editorViewController {
  [_editorViewController fblc_dismissViewController:self];
  _editorViewController = nil;
}

- (void)editorViewController:(FBLCEditorViewController *)editorViewController
    didFinishEditingWithFinalImage:(UIImage *)finalImage {
  [_editorViewController fblc_dismissViewController:self];
  _editorViewController = nil;
}

#pragma mark - FBLCRootViewDelegate

- (void)rootViewDidSelectImportNewPhoto:(FBLCRootView *)rootView {
  // TODO: Check if source is available.
  [self presentMediaPicker];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
    didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
  NSURL *imageURL = info[UIImagePickerControllerImageURL];
  [picker dismissViewControllerAnimated:YES completion:nil];
  [self showEditorViewControllerWithImageURL:imageURL];
}

#pragma mark - Private Methods

/** Presents the photo picker view controller. */
- (void)presentMediaPicker {
  if (!_mediaPickerController) {
    _mediaPickerController = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
      _mediaPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else {
      _mediaPickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    _mediaPickerController.delegate = self;
  }

  if (_mediaPickerController.isBeingPresented || _mediaPickerController.presentedViewController) {
    return;
  }

  [self presentViewController:_mediaPickerController animated:YES completion:nil];
}

/** Presents the view controller used to edit an image. */
- (void)showEditorViewControllerWithImageURL:(NSURL *)imageURL {
  _editorViewController = [[FBLCEditorViewController alloc] initWithImageURL:imageURL];
  _editorViewController.delegate = self;
  [self showViewController:_editorViewController sender:self];
}

@end
