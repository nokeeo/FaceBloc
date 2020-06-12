// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.txt, included with
// this project.

#import "UIView+AutoLayout.h"

@interface FBLCEdgeConstraints ()

- (instancetype)initWithLeading:(NSLayoutConstraint *)leading
                       trailing:(NSLayoutConstraint *)trailing
                            top:(NSLayoutConstraint *)top
                         bottom:(NSLayoutConstraint *)bottom;

@end

@implementation FBLCEdgeConstraints

+ (instancetype)edgeConstraintsWithLeading:(NSLayoutConstraint *)leading
                                  trailing:(NSLayoutConstraint *)trailing
                                       top:(NSLayoutConstraint *)top
                                    bottom:(NSLayoutConstraint *)bottom {
  return [[self alloc] initWithLeading:leading trailing:trailing top:top bottom:bottom];
}

- (instancetype)initWithLeading:(NSLayoutConstraint *)leading
                       trailing:(NSLayoutConstraint *)trailing
                            top:(NSLayoutConstraint *)top
                         bottom:(NSLayoutConstraint *)bottom {
  self = [super init];
  if (self) {
    _leading = leading;
    _trailing = trailing;
    _top = top;
    _bottom = bottom;
  }

  return self;
}

- (NSArray<NSLayoutConstraint *> *)constraints {
  return @[
    _leading,
    _trailing,
    _top,
    _bottom,
  ];
}

@end

#pragma mark -

@implementation FBLCCenterConstraints

- (instancetype)initWithX:(NSLayoutConstraint *)x y:(NSLayoutConstraint *)y {
  self = [super init];
  if (self) {
    _x = x;
    _y = y;
  }

  return self;
}

+ (instancetype)centerConstraintWithX:(NSLayoutConstraint *)x y:(NSLayoutConstraint *)y {
  return [[self alloc] initWithX:x y:y];
}

- (NSArray<NSLayoutConstraint *> *)constraints {
  return @[
    _x,
    _y,
  ];
}

@end

#pragma mark -

@implementation UIView (AutoLayout)

- (FBLCEdgeConstraints *)fblc_constraintsAttachedToSuperviewEdges {
  UIView *superview = self.superview;
  NSLayoutConstraint *leading = [self.leadingAnchor constraintEqualToAnchor:superview.leadingAnchor];
  NSLayoutConstraint *trailing = [self.trailingAnchor constraintEqualToAnchor:superview.trailingAnchor];
  NSLayoutConstraint *top = [self.topAnchor constraintEqualToAnchor:superview.topAnchor];
  NSLayoutConstraint *bottom = [self.bottomAnchor constraintEqualToAnchor:superview.bottomAnchor];

  return [FBLCEdgeConstraints edgeConstraintsWithLeading:leading trailing:trailing top:top bottom:bottom];
}

- (FBLCEdgeConstraints *)fblc_constraintsAttachedToLayoutGuideEdges:(UILayoutGuide *)layoutGuide {
  NSLayoutConstraint *leading = [self.leadingAnchor constraintEqualToAnchor:layoutGuide.leadingAnchor];
  NSLayoutConstraint *trailing = [self.trailingAnchor constraintEqualToAnchor:layoutGuide.trailingAnchor];
  NSLayoutConstraint *top = [self.topAnchor constraintEqualToAnchor:layoutGuide.topAnchor];
  NSLayoutConstraint *bottom = [self.bottomAnchor constraintEqualToAnchor:layoutGuide.bottomAnchor];

  return [FBLCEdgeConstraints edgeConstraintsWithLeading:leading trailing:trailing top:top bottom:bottom];
}

- (FBLCEdgeConstraints *)fblc_constraintsAttachedToView:(UIView *)view {
  NSLayoutConstraint *leading = [self.leadingAnchor constraintEqualToAnchor:view.leadingAnchor];
  NSLayoutConstraint *trailing = [self.trailingAnchor constraintEqualToAnchor:view.trailingAnchor];
  NSLayoutConstraint *top = [self.topAnchor constraintEqualToAnchor:view.topAnchor];
  NSLayoutConstraint *bottom = [self.bottomAnchor constraintEqualToAnchor:view.bottomAnchor];

  return [FBLCEdgeConstraints edgeConstraintsWithLeading:leading trailing:trailing top:top bottom:bottom];
}

- (FBLCCenterConstraints *)fblc_constraintsCenteredInSuperview {
  UIView *superview = self.superview;
  NSLayoutConstraint *x = [self.centerXAnchor constraintEqualToAnchor:superview.centerXAnchor];
  NSLayoutConstraint *y = [self.centerYAnchor constraintEqualToAnchor:superview.centerYAnchor];

  return [FBLCCenterConstraints centerConstraintWithX:x y:y];
}

- (void)fblc_addConstraints:(id<FBLCViewConstraining>)constraints {
  [self addConstraints:[constraints constraints]];
}

@end
