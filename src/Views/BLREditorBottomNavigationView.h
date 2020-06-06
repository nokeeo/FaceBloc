//
//  BLREditorBottomNavigationVew.h
//  Blur
//
//  Created by Eric Lee on 6/5/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BLREditorBottomNavigationViewDelegate;

@interface BLREditorBottomNavigationView : UIView

@property(nonatomic, readonly) BOOL shouldObscureFaces;

@property(nonatomic, nullable, weak) id<BLREditorBottomNavigationViewDelegate> delegate;

@end

@protocol BLREditorBottomNavigationViewDelegate <NSObject>

- (void)editorBottomNavigationView:(BLREditorBottomNavigationView *)editorBottomNavigationView didChangeFaceObfuscation:(BOOL)shouldFaceObfuscate;

@end

NS_ASSUME_NONNULL_END
