//
//  FBLCEditorBottomNavigationVew.h
//  Blur
//
//  Created by Eric Lee on 6/5/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

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
