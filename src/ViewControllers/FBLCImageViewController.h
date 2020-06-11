//
//  FBLCImageViewController.h
//  Blur
//
//  Created by Eric Lee on 6/6/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FBLCImage;
@class FBLCImageView;
@protocol FBLCImageViewControllerDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface FBLCImageViewController : UIViewController

@property(nonatomic) FBLCImage *image;

@property(nonatomic) FBLCImageView *imageView;

@property(nonatomic, nullable, weak) id<FBLCImageViewControllerDelegate> delegate;

- (instancetype)initWithImage:(FBLCImage *)image;

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

@end

@protocol FBLCImageViewControllerDelegate <NSObject>

- (void)imageViewController:(FBLCImageViewController *)viewController didLoadImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
