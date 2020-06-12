// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.txt, included with
// this project.

#import <UIKit/UIKit.h>

@class FBLCImage;
@class FBLCImageView;
@protocol FBLCImageViewControllerDelegate;

NS_ASSUME_NONNULL_BEGIN

/** Loads and displays a given image with a view. The image is pan and zoom-able.*/
@interface FBLCImageViewController : UIViewController

/** The image to display in the view. */
@property(nonatomic) FBLCImage *image;

/** The view that this controller owns. */
@property(nonatomic) FBLCImageView *imageView;

/** The object to receive updates on the status of loading the image. */
@property(nonatomic, nullable, weak) id<FBLCImageViewControllerDelegate> delegate;

- (instancetype)initWithImage:(FBLCImage *)image;

// Please use `initWithImage:`.
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil
                         bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

@end

/** Objects conform to this protocol to receive updates on the status of loading an image. */
@protocol FBLCImageViewControllerDelegate <NSObject>

/** Is called when the image has completely loaded.*/
- (void)imageViewController:(FBLCImageViewController *)viewController didLoadImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
