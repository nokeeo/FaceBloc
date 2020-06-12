// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.txt, included with
// this project.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FBLCEditorBottomNavigationViewDelegate;

@interface FBLCEditorBottomNavigationView : UIView

@property(nonatomic, readonly) BOOL shouldObscureFaces;

@property(nonatomic, getter=isDrawingEnabled, readonly) BOOL drawingEnabled;

@property(nonatomic, nullable, weak) id<FBLCEditorBottomNavigationViewDelegate> delegate;

@end

@protocol FBLCEditorBottomNavigationViewDelegate <NSObject>

- (void)editorBottomNavigationView:(FBLCEditorBottomNavigationView *)editorBottomNavigationView didChangeFaceObfuscation:(BOOL)shouldFaceObfuscate;

- (void)editorBottomNavigationView:(FBLCEditorBottomNavigationView *)editorBottomNavigationView didEnableDrawing:(BOOL)enabled;

- (void)editorBottomNavigationViewDidCancelEditing:(FBLCEditorBottomNavigationView *)bottomNavigationView;

- (void)editorBottomNavigationViewDidTapSaveButton:(FBLCEditorBottomNavigationView *)bottomNavigationView;

@end

NS_ASSUME_NONNULL_END
