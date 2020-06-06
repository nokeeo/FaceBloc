//
//  BLRImageView.h
//  Blur
//
//  Created by Eric Lee on 6/4/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLRImageViewDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface BLRImageView : UIView <UIScrollViewDelegate>

@property(nonatomic, nullable) UIImage *image;

@property(nonatomic, getter=isTouchTrackingEnabled) BOOL touchTrackingEnabled;

@property(nonatomic, nullable, weak) id<BLRImageViewDelegate> delegate;

@end

@protocol BLRImageViewDelegate <NSObject>

- (void)imageView:(BLRImageView *)imageView didUpdatePath:(CGPathRef)path;

- (void)imageView:(BLRImageView *)imageView didFinishPath:(CGPathRef)path;

@end

NS_ASSUME_NONNULL_END
