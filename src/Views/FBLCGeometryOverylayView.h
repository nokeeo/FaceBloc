//
//  FBLCGeometryOverylayView.h
//  Blur
//
//  Created by Eric Lee on 6/7/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FBLCImageGeometryData;
@class FBLCRenderingOptions;

NS_ASSUME_NONNULL_BEGIN

@interface FBLCGeometryOverylayView : UIView

@property(nonatomic) FBLCImageGeometryData *geometry;

@property(nonatomic) FBLCRenderingOptions *renderingOptions;

@end

NS_ASSUME_NONNULL_END
