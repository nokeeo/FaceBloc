//
//  FBLCPhotoLibraryService.h
//  Blur
//
//  Created by Eric Lee on 6/6/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import<UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^FBLCSavePhotoCompletionBlock)(NSError *_Nullable error);

@interface FBLCPhotoLibraryService : NSObject

- (void)savePhotoToLibrary:(UIImage *)image queue:(dispatch_queue_t)queue completion:(FBLCSavePhotoCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
