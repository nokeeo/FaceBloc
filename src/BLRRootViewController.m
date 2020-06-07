//
//  ViewController.m
//  Blur
//
//  Created by Eric Lee on 6/4/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import "BLRRootViewController.h"

#import "BLRRootView.h"
#import "BLREditorViewController.h"
#import "UIViewController+Presenting.h"

@implementation BLRRootViewController {
  UIImagePickerController *_Nullable _mediaPickerController;
  BLREditorViewController *_Nullable _editorViewController;
}

- (void)loadView {
  BLRRootView *rootView = [[BLRRootView alloc] init];
  rootView.delegate = self;
  self.view = rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - BLREditoViewControllerDelegate

- (void)editorViewControllerDidCancelEditing:(BLREditorViewController *)editorViewController {
  [_editorViewController blr_dismissViewController:self];
}

- (void)editorViewController:(BLREditorViewController *)editorViewController didFinishEditingWithFinalImage:(UIImage *)finalImage {
  [_editorViewController blr_dismissViewController:self];
  // TODO: Actually save the image.
}

#pragma mark - BLRRootViewDelegate

- (void)rootViewDidSelectImportNewPhoto:(BLRRootView *)rootView {
  // TODO: Check if source is available.
  [self presentMediaPicker];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
  UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
  BLREditorViewController *editorViewController = [[BLREditorViewController alloc] init];
  editorViewController.image = originalImage;
  
  [picker dismissViewControllerAnimated:YES completion:nil];
  [self showEditorViewControllerWithImage:originalImage];
}

#pragma mark - Private Methods

- (void)presentMediaPicker {
  if (!_mediaPickerController) {
    _mediaPickerController = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
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

- (void)showEditorViewControllerWithImage:(UIImage *)image {
  if (_editorViewController.parentViewController) {
    _editorViewController.image = image;
    return;
  }
  
  _editorViewController = [[BLREditorViewController alloc] init];
  _editorViewController.image = image;
  _editorViewController.delegate = self;
  [self showViewController:_editorViewController sender:self];
}

@end
