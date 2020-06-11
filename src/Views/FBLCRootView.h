//
//  FBLCRootView.h
//  Blur
//
//  Created by Eric Lee on 6/4/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

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
