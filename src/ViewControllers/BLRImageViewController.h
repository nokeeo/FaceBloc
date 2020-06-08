//
//  BLRImageViewController.h
//  Blur
//
//  Created by Eric Lee on 6/6/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLRImage;
@class BLRImageView;
@protocol BLRImageViewControllerDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface BLRImageViewController : UIViewController

@property(nonatomic) BLRImageView *imageView;

@property(nonatomic, nullable, weak) id<BLRImageViewControllerDelegate> delegate;

- (instancetype)initWithImage:(BLRImage *)image;

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

@end

@protocol BLRImageViewControllerDelegate <NSObject>

- (void)imageViewController:(BLRImageViewController *)viewController didLoadImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
