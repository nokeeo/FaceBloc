//
//  UIView+AutoLayout.h
//  Blur
//
//  Created by Eric Lee on 6/6/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BLRViewConstraining <NSObject>

- (NSArray<NSLayoutConstraint *> *)constraints;

@end

@interface BLREdgeConstraints : NSObject <BLRViewConstraining>

@property(nonatomic, readonly) NSLayoutConstraint *leading;

@property(nonatomic, readonly) NSLayoutConstraint *trailing;

@property(nonatomic, readonly) NSLayoutConstraint *top;

@property(nonatomic, readonly) NSLayoutConstraint *bottom;

+ (instancetype)edgeConstraintsWithLeading:(NSLayoutConstraint *)leading trailing:(NSLayoutConstraint *)trailing top:(NSLayoutConstraint *)top bottom:(NSLayoutConstraint *)bottom;

- (instancetype)init NS_UNAVAILABLE;

@end

@interface BLRCenterConstraints : NSObject <BLRViewConstraining>

@property(nonatomic, readonly) NSLayoutConstraint *x;

@property(nonatomic, readonly) NSLayoutConstraint *y;

+ (instancetype)centerConstraintWithX:(NSLayoutConstraint *)x y:(NSLayoutConstraint *)y;

- (instancetype)init NS_UNAVAILABLE;

@end

@interface UIView (AutoLayout)

- (BLREdgeConstraints *)blr_constraintsAttachedToSuperviewEdges;

- (BLREdgeConstraints *)blr_constraintsAttachedToLayoutGuideEdges:(UILayoutGuide *)layoutGuide;

- (BLREdgeConstraints *)blr_constraintsAttachedToView:(UIView *)view;

- (BLRCenterConstraints *)blr_constraintsCenteredInSuperview;

- (void)blr_addConstraints:(id<BLRViewConstraining>)constraints;

@end

NS_ASSUME_NONNULL_END
