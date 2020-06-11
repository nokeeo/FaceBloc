//
//  FBLCPhotoLibraryService.m
//  Blur
//
//  Created by Eric Lee on 6/6/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import "FBLCPhotoLibraryService.h"

#import <Photos/Photos.h>

#import "LocalizationIDs.h"

typedef void (^FBLCPhotoRequestPermissionCompletion)(NSError *_Nullable);

static NSString *const kPhotoServiceErrorDomain = @"com.nokeeo.photoService";

static const NSInteger kPhotoServicePermissionDeniedErrorCode = 1;

static void CallSaveCompletion(FBLCSavePhotoCompletionBlock completion, NSError *_Nullable error, dispatch_queue_t queue) {
  dispatch_async(queue, ^{
    completion(error);
  });
}

static NSError *CreateErrorForPermissionDenied() {
  NSMutableDictionary<NSErrorUserInfoKey, id> *userInfo = [NSMutableDictionary dictionary];
  NSString *localizedDescription = NSLocalizedString(FBLCPhotoPermissionsDeniedError, nil);
  if (localizedDescription) {
    userInfo[NSLocalizedDescriptionKey] = localizedDescription;
  }
  
  return [NSError errorWithDomain:kPhotoServiceErrorDomain code:kPhotoServicePermissionDeniedErrorCode userInfo:userInfo];
}

static void RequestPermissions(FBLCPhotoRequestPermissionCompletion completion) {
  [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
    switch (status) {
      case PHAuthorizationStatusAuthorized:
      case PHAuthorizationStatusRestricted:
        completion(/*error=*/nil);
        break;
      case PHAuthorizationStatusNotDetermined:
      case PHAuthorizationStatusDenied:
        completion(CreateErrorForPermissionDenied());
        break;
    }
  }];
}

static void RequestPermissionsIfNeeded(FBLCPhotoRequestPermissionCompletion completion) {
  PHAuthorizationStatus authorizationStatus = PHPhotoLibrary.authorizationStatus;
  switch (authorizationStatus) {
    case PHAuthorizationStatusDenied:
      completion(CreateErrorForPermissionDenied());
      break;
    case PHAuthorizationStatusNotDetermined:
      RequestPermissions(completion);
      break;
    case PHAuthorizationStatusAuthorized:
    case PHAuthorizationStatusRestricted:
      completion(/*error*/nil);
  }
}

@implementation FBLCPhotoLibraryService

- (void)savePhotoToLibrary:(UIImage *)image queue:(dispatch_queue_t)queue completion:(FBLCSavePhotoCompletionBlock)completion {
  PHPhotoLibrary *library = PHPhotoLibrary.sharedPhotoLibrary;
  RequestPermissionsIfNeeded(^(NSError *authorizationError) {
    if (authorizationError) {
      CallSaveCompletion(completion, authorizationError, queue);
      return;
    }
    
    [library performChanges:^{
      NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
      if (!imageData) {
        return;
      }
      
      PHAssetCreationRequest *creationRequest = [PHAssetCreationRequest creationRequestForAsset];
      [creationRequest addResourceWithType:PHAssetResourceTypePhoto data:imageData options:nil];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
      CallSaveCompletion(completion, error, queue);
    }];
  });
}

@end
