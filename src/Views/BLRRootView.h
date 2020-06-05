//
//  BLRRootView.h
//  Blur
//
//  Created by Eric Lee on 6/4/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BLRRootView;

@protocol BLRRootViewDelegate <NSObject>

- (void)rootViewDidSelectImportNewPhoto:(BLRRootView *)rootView;

@end

@interface BLRRootView : UIView

@property(nonatomic, nullable, weak) id<BLRRootViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
