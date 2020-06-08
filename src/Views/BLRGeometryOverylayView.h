//
//  BLRGeometryOverylayView.h
//  Blur
//
//  Created by Eric Lee on 6/7/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLRImageGeometryData;
@class BLRRenderingOptions;

NS_ASSUME_NONNULL_BEGIN

@interface BLRGeometryOverylayView : UIView

@property(nonatomic) BLRImageGeometryData *geometry;

@property(nonatomic) BLRRenderingOptions *renderingOptions;

@end

NS_ASSUME_NONNULL_END
