// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.md, included with
// this project.

#import <UIKit/UIKit.h>

@class FBLCImageGeometryData;
@class FBLCRenderingOptions;

NS_ASSUME_NONNULL_BEGIN

/** The view that renders given image geometry. */
@interface FBLCGeometryOverlayView : UIView

/** The geometry to render in the receiver. Setting this value may redraw the receiver's content. */
@property(nonatomic) FBLCImageGeometryData *geometry;

/** The global rendering configurations. Setting this value may redraw the receiver's content. */
@property(nonatomic) FBLCRenderingOptions *renderingOptions;

@end

NS_ASSUME_NONNULL_END
