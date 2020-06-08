//
//  BLRImage.h
//  Blur
//
//  Created by Eric Lee on 6/7/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^BLRImageLoadComletion)(UIImage *image);

@interface BLRImage : NSObject

@property(nonatomic, readonly) NSURL *URL;

- (instancetype)initWithURL:(NSURL *)URL NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (void)templateImageWithDimension:(size_t)dimension completion:(BLRImageLoadComletion)completion;

@end

NS_ASSUME_NONNULL_END
