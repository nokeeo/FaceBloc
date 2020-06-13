// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.md, included with
// this project.

// File containing Utils in attempts to make working with AutoLayout constraints less verbose in most cases.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** Objects that conform to this protocol have the ability to generate constraints based on their current state. */
@protocol FBLCViewConstraining <NSObject>

/** Returns an array of newly created constraints representing the receiver's current state. */
- (NSArray<NSLayoutConstraint *> *)constraints;

@end

/** Represents constraints pinning a view to all four edges of another view. */
@interface FBLCEdgeConstraints : NSObject <FBLCViewConstraining>

@property(nonatomic, readonly) NSLayoutConstraint *leading;

@property(nonatomic, readonly) NSLayoutConstraint *trailing;

@property(nonatomic, readonly) NSLayoutConstraint *top;

@property(nonatomic, readonly) NSLayoutConstraint *bottom;

+ (instancetype)edgeConstraintsWithLeading:(NSLayoutConstraint *)leading
                                  trailing:(NSLayoutConstraint *)trailing
                                       top:(NSLayoutConstraint *)top
                                    bottom:(NSLayoutConstraint *)bottom;

- (instancetype)init NS_UNAVAILABLE;

@end

/** Represents a constraints pinning a view to the center of another view. */
@interface FBLCCenterConstraints : NSObject <FBLCViewConstraining>

@property(nonatomic, readonly) NSLayoutConstraint *x;

@property(nonatomic, readonly) NSLayoutConstraint *y;

+ (instancetype)centerConstraintWithX:(NSLayoutConstraint *)x y:(NSLayoutConstraint *)y;

- (instancetype)init NS_UNAVAILABLE;

@end

/** An extension of UIView for generating constraint objects and adding generated constraints to a view. */
@interface UIView (AutoLayout)

/** Creates constraints pinning the receiver to its superview's edges. Returned constraints still must be added. */
- (FBLCEdgeConstraints *)fblc_constraintsAttachedToSuperviewEdges;

/** Creates constraints pinning the receiver to the given layout guide. Returned constraints still must be added. */
- (FBLCEdgeConstraints *)fblc_constraintsAttachedToLayoutGuideEdges:(UILayoutGuide *)layoutGuide;

/**
 * Creates constraints pinning the receiver to the edges of the given view. Returned constraints still must be added.
 */
- (FBLCEdgeConstraints *)fblc_constraintsAttachedToView:(UIView *)view;

/**
 * Creates constraints pinning the receiver's center to the center of its superview. Returned constraints still must be
 * added.
 */
- (FBLCCenterConstraints *)fblc_constraintsCenteredInSuperview;

/** Adds the given constraints to the view and activates them. */
- (void)fblc_addConstraints:(id<FBLCViewConstraining>)constraints;

@end

NS_ASSUME_NONNULL_END
