//
//  BLRRenderingOptions.h
//  Blur
//
//  Created by Eric Lee on 6/7/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLRRenderingOptions : NSObject

@property (nonatomic) BOOL shouldObscureFaces;

+ (instancetype)optionsWithShouldObscureFaces:(BOOL)shouldObscureFaces;

- (instancetype)init NS_UNAVAILABLE;

@end
NS_ASSUME_NONNULL_END
