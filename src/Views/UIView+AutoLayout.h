// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.txt, included with
// this project.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FBLCViewConstraining <NSObject>

- (NSArray<NSLayoutConstraint *> *)constraints;

@end

@interface FBLCEdgeConstraints : NSObject <FBLCViewConstraining>

@property(nonatomic, readonly) NSLayoutConstraint *leading;

@property(nonatomic, readonly) NSLayoutConstraint *trailing;

@property(nonatomic, readonly) NSLayoutConstraint *top;

@property(nonatomic, readonly) NSLayoutConstraint *bottom;

+ (instancetype)edgeConstraintsWithLeading:(NSLayoutConstraint *)leading trailing:(NSLayoutConstraint *)trailing top:(NSLayoutConstraint *)top bottom:(NSLayoutConstraint *)bottom;

- (instancetype)init NS_UNAVAILABLE;

@end

@interface FBLCCenterConstraints : NSObject <FBLCViewConstraining>

@property(nonatomic, readonly) NSLayoutConstraint *x;

@property(nonatomic, readonly) NSLayoutConstraint *y;

+ (instancetype)centerConstraintWithX:(NSLayoutConstraint *)x y:(NSLayoutConstraint *)y;

- (instancetype)init NS_UNAVAILABLE;

@end

@interface UIView (AutoLayout)

- (FBLCEdgeConstraints *)fblc_constraintsAttachedToSuperviewEdges;

- (FBLCEdgeConstraints *)fblc_constraintsAttachedToLayoutGuideEdges:(UILayoutGuide *)layoutGuide;

- (FBLCEdgeConstraints *)fblc_constraintsAttachedToView:(UIView *)view;

- (FBLCCenterConstraints *)fblc_constraintsCenteredInSuperview;

- (void)fblc_addConstraints:(id<FBLCViewConstraining>)constraints;

@end

NS_ASSUME_NONNULL_END
