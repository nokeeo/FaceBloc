//
//  BLRPhotoLibraryService.h
//  Blur
//
//  Created by Eric Lee on 6/6/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import<UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^BLRSavePhotoCompletionBlock)(NSError *_Nullable error);

@interface BLRPhotoLibraryService : NSObject

- (void)savePhotoToLibrary:(UIImage *)image queue:(dispatch_queue_t)queue completion:(BLRSavePhotoCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
