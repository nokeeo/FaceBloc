//
//  UIViewController+NSError.h
//  Blur
//
//  Created by Eric Lee on 6/7/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (NSError)

- (void)blr_presentError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
