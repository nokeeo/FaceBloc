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
#import "BLRPhotoLibraryService.h"
#import "UIViewController+Presenting.h"

@implementation BLRRootViewController {
  UIImagePickerController *_Nullable _mediaPickerController;
  BLREditorViewController *_Nullable _editorViewController;
  
  BLRPhotoLibraryService *_photoLibraryService;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _photoLibraryService = [[BLRPhotoLibraryService alloc] init];
  }
  
  return self;
}

- (void)loadView {
  BLRRootView *rootView = [[BLRRootView alloc] init];
  rootView.delegate = self;
  self.view = rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  self.navigationController.navigationBarHidden = YES;
}

#pragma mark - BLREditoViewControllerDelegate

- (void)editorViewControllerDidCancelEditing:(BLREditorViewController *)editorViewController {
  [_editorViewController blr_dismissViewController:self];
  _editorViewController = nil;
}

- (void)editorViewController:(BLREditorViewController *)editorViewController didFinishEditingWithFinalImage:(UIImage *)finalImage {
  [_editorViewController blr_dismissViewController:self];
  _editorViewController = nil;
}

#pragma mark - BLRRootViewDelegate

- (void)rootViewDidSelectImportNewPhoto:(BLRRootView *)rootView {
  // TODO: Check if source is available.
  [self presentMediaPicker];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
  
  NSURL *imageURL = info[UIImagePickerControllerImageURL];
  [picker dismissViewControllerAnimated:YES completion:nil];
  [self showEditorViewControllerWithImageURL:imageURL];
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

- (void)showEditorViewControllerWithImageURL:(NSURL *)imageURL {
//  if (_editorViewController.parentViewController) {
//    _editorViewController.image = image;
//    return;
//  }
  
  
  _editorViewController = [[BLREditorViewController alloc] initWithImageURL:imageURL];
  _editorViewController.delegate = self;
  [self showViewController:_editorViewController sender:self];
}

@end
