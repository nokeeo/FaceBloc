//
//  FBLCEditorBottomNavigationButton.h
//  Blur
//
//  Created by Eric Lee on 6/6/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBLCEditorBottomNavigationButton : UIButton

@property (nonatomic, getter=isOn) BOOL on;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
