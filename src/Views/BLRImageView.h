//
//  BLRImageView.h
//  Blur
//
//  Created by Eric Lee on 6/4/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLRImageView : UIView <UIScrollViewDelegate>

@property(nonatomic, nullable) UIImage *image;

@end

NS_ASSUME_NONNULL_END
