//
//  UIView+AutoLayout.m
//  Blur
//
//  Created by Eric Lee on 6/6/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import "UIView+AutoLayout.h"

@interface BLREdgeConstraints ()

- (instancetype)initWithLeading:(NSLayoutConstraint *)leading trailing:(NSLayoutConstraint *)trailing top:(NSLayoutConstraint *)top bottom:(NSLayoutConstraint *)bottom;

@end

@implementation BLREdgeConstraints

+ (instancetype)edgeConstraintsWithLeading:(NSLayoutConstraint *)leading trailing:(NSLayoutConstraint *)trailing top:(NSLayoutConstraint *)top bottom:(NSLayoutConstraint *)bottom {
  return [[self alloc] initWithLeading:leading trailing:trailing top:top bottom:bottom];
}

- (instancetype)initWithLeading:(NSLayoutConstraint *)leading trailing:(NSLayoutConstraint *)trailing top:(NSLayoutConstraint *)top bottom:(NSLayoutConstraint *)bottom {
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

@implementation UIView (AutoLayout)

- (BLREdgeConstraints *)blr_constraintsAttachedToSuperviewEdges {
  UIView *superview = self.superview;
  NSLayoutConstraint *leading = [self.leadingAnchor constraintEqualToAnchor:superview.leadingAnchor];
  NSLayoutConstraint *trailing = [self.trailingAnchor constraintEqualToAnchor:superview.trailingAnchor];
  NSLayoutConstraint *top = [self.topAnchor constraintEqualToAnchor:superview.topAnchor];
  NSLayoutConstraint *bottom = [self.bottomAnchor constraintEqualToAnchor:superview.bottomAnchor];
  
  return [BLREdgeConstraints edgeConstraintsWithLeading:leading trailing:trailing top:top bottom:bottom];
}

- (BLREdgeConstraints *)blr_constraintsAttachedToLayoutGuideEdges:(UILayoutGuide *)layoutGuide {
  NSLayoutConstraint *leading = [self.leadingAnchor constraintEqualToAnchor:layoutGuide.leadingAnchor];
  NSLayoutConstraint *trailing = [self.trailingAnchor constraintEqualToAnchor:layoutGuide.trailingAnchor];
  NSLayoutConstraint *top = [self.topAnchor constraintEqualToAnchor:layoutGuide.topAnchor];
  NSLayoutConstraint *bottom = [self.bottomAnchor constraintEqualToAnchor:layoutGuide.bottomAnchor];
  
  return [BLREdgeConstraints edgeConstraintsWithLeading:leading trailing:trailing top:top bottom:bottom];
}

- (void)blr_addConstraints:(id<BLRViewConstraining>)constraints {
  [self addConstraints:[constraints constraints]];
}

@end
