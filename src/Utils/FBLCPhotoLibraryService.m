// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.md, included with
// this project.

#import "FBLCPhotoLibraryService.h"

#import <Photos/Photos.h>

#import "LocalizationIDs.h"

/**
 * The type of block executed when the request for permissions has completed.
 * @param error describing request failure. Nil if the operation succeeded and permission was granted.
 */
typedef void (^FBLCPhotoRequestPermissionCompletion)(NSError *_Nullable error);

/** The domain of errors produced by the photo service. */
static NSString *const kPhotoServiceErrorDomain = @"com.nokeeo.photoService";

/** The error code of a permission denied request. */
static const NSInteger kPhotoServicePermissionDeniedErrorCode = 1;

/** Returns the JPEG image compression constant. Value varies from 0.0 - 1.0. */
static CGFloat ImageQualityToJPEGCompressionQuality(FBLCSavePhotoQuality quality) {
  switch (quality) {
    case FBLCSavePhotoQualityFull:
      // Full quality images should export as PNGs.
      return 1;
    case FBLCSavePhotoQualityLarge:
      return 0.8;
    case FBLCSavePhotoQualityMedium:
      return 0.4;
    case FBLCSavePhotoQualitySmall:
      return 0;
  }
}

/** Returns the NSData representation of the given image with the given quality. */
static NSData *ImageToDataForQuality(UIImage *image, FBLCSavePhotoQuality quality) {
  if (quality == FBLCSavePhotoQualityFull) {
    return UIImagePNGRepresentation(image);
  }

  CGFloat compressionQuality = ImageQualityToJPEGCompressionQuality(quality);
  return UIImageJPEGRepresentation(image, compressionQuality);
}

/** Executes the given save completion block on the main thread. */
static void CallSaveCompletion(FBLCSavePhotoCompletionBlock completion, NSError *_Nullable error,
                               dispatch_queue_t queue) {
  dispatch_async(queue, ^{
    completion(error);
  });
}

/** Creates an error for a denied request for permissions. */
static NSError *CreateErrorForPermissionDenied() {
  NSMutableDictionary<NSErrorUserInfoKey, id> *userInfo = [NSMutableDictionary dictionary];
  NSString *localizedDescription = NSLocalizedString(FBLCPhotoPermissionsDeniedError, nil);
  if (localizedDescription) {
    userInfo[NSLocalizedDescriptionKey] = localizedDescription;
  }

  return [NSError errorWithDomain:kPhotoServiceErrorDomain
                             code:kPhotoServicePermissionDeniedErrorCode
                         userInfo:userInfo];
}

/** Requests permissions to access the photo library. */
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

/**
 * Requests permission if needed. If permissions have already been granted, this function immediately calls the given
 * block
 */
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
      completion(/*error*/ nil);
  }
}

@implementation FBLCPhotoLibraryService

- (void)savePhotoToLibrary:(UIImage *)image
                   quality:(FBLCSavePhotoQuality)quality
                     queue:(dispatch_queue_t)queue
                completion:(FBLCSavePhotoCompletionBlock)completion {
  PHPhotoLibrary *library = PHPhotoLibrary.sharedPhotoLibrary;
  RequestPermissionsIfNeeded(^(NSError *authorizationError) {
    if (authorizationError) {
      CallSaveCompletion(completion, authorizationError, queue);
      return;
    }

    [library
        performChanges:^{
          NSData *imageData = ImageToDataForQuality(image, quality);
          if (!imageData) {
            return;
          }

          PHAssetCreationRequest *creationRequest = [PHAssetCreationRequest creationRequestForAsset];
          [creationRequest addResourceWithType:PHAssetResourceTypePhoto data:imageData options:nil];
        }
        completionHandler:^(BOOL success, NSError *_Nullable error) {
          CallSaveCompletion(completion, error, queue);
        }];
  });
}

@end
