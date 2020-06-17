// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.md, included with
// this project.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FBLCEditorBottomNavigationViewDelegate;

/** The view that appears at the bottom of the editor view with navigation elements. */
@interface FBLCEditorBottomNavigationView : UIView

/** Indicates if the should obscure faces button has been selected. */
@property(nonatomic, readonly) BOOL shouldObscureFaces;

/** Indicates if the draw button is enabled. */
@property(nonatomic, getter=isDrawingEnabled, readonly) BOOL drawingEnabled;

/** The object that observes changes to the state of the receiver. */
@property(nonatomic, nullable, weak) id<FBLCEditorBottomNavigationViewDelegate> delegate;

@end

/** Objects conform to this protocol to receive updates on changes to the bottom navigation view. */
@protocol FBLCEditorBottomNavigationViewDelegate <NSObject>

/** Indicates that the face obscuring button has changed. */
- (void)editorBottomNavigationView:(FBLCEditorBottomNavigationView *)editorBottomNavigationView
          didChangeFaceObfuscation:(BOOL)shouldFaceObfuscate;

/** Indicates that the user has enabled or disabled drawing mode. */
- (void)editorBottomNavigationView:(FBLCEditorBottomNavigationView *)editorBottomNavigationView
                  didEnableDrawing:(BOOL)enabled;

/** Indicates if the user has requested to end editing. */
- (void)editorBottomNavigationViewDidCancelEditing:(FBLCEditorBottomNavigationView *)bottomNavigationView;

/** Indicates that the user wants to save the image. */
- (void)editorBottomNavigationViewDidTapSaveButton:(FBLCEditorBottomNavigationView *)bottomNavigationView;

@end

NS_ASSUME_NONNULL_END
