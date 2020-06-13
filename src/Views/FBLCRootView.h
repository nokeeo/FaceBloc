// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.md, included with
// this project.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FBLCRootView;

@protocol FBLCRootViewDelegate <NSObject>

- (void)rootViewDidSelectImportNewPhoto:(FBLCRootView *)rootView;

@end

@interface FBLCRootView : UIView

@property(nonatomic, nullable, weak) id<FBLCRootViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
