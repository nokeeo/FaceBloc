//
//  FBLCImageView.h
//  Blur
//
//  Created by Eric Lee on 6/4/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FBLCImageViewDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface FBLCImageView : UIView <UIScrollViewDelegate>

@property(nonatomic, nullable) UIImage *image;

@property(nonatomic, readonly) UIView *contentView;

@property(nonatomic, readonly) CGFloat zoomScale;

@end

NS_ASSUME_NONNULL_END
