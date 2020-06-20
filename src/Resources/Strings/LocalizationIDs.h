//
//  LocalizationIDs.h
//  Blur
//
//  Created by Eric Lee on 6/4/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** Describes the button that imports assets on the root screen. */
extern NSString *const FBLCImportButtonStringID;

/** Describes the button that saves an image in the asset editor. */
extern NSString *const FBLCSaveButtonStringID;

/** Describes the button that cancels editing. */
extern NSString *const FBLCCancelButtonStringID;

/** Describes the error displayed when photo permissions have been denied. */
extern NSString *const FBLCPhotoPermissionsDeniedError;

/** The title of the action associated with confirming/dismissing an error alert. */
extern NSString *const FBLCErrorDialogConfirmationTitle;

/** The title of the action sheet for selecting image quality. */
extern NSString *const FBLCSaveQualityActionSheetTitle;

/** The subtitle of the action sheet for selecting image quality. */
extern NSString *const FBLCSaveQualityActionSheetSubtitle;

/** The title of the save action for a lossless image. */
extern NSString *const FBLCSaveQualityFullTitle;

/** The title of the save action for a large image. */
extern NSString *const FBLCSaveQualityHighTitle;

/** The title of a save action for a medium image. */
extern NSString *const FBLCSaveQualityMediumTitle;

/** The title of a save action for a small image. */
extern NSString *const FBLCSaveQualityLowTitle;

/** The title of the action that cancels saving an image. */
extern NSString *const FBLCSaveQualityCancelTitle;

NS_ASSUME_NONNULL_END
