// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.txt, included with
// this project.

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^FBLCSavePhotoCompletionBlock)(NSError *_Nullable error);

@interface FBLCPhotoLibraryService : NSObject

- (void)savePhotoToLibrary:(UIImage *)image
                     queue:(dispatch_queue_t)queue
                completion:(FBLCSavePhotoCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
