//
//  FBLCEditorBottomNavigationButton.m
//  Blur
//
//  Created by Eric Lee on 6/6/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import "FBLCEditorBottomNavigationButton.h"

static const CGFloat insets = 3;

@implementation FBLCEditorBottomNavigationButton

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setTintColor:UIColor.whiteColor];
    self.contentEdgeInsets = UIEdgeInsetsMake(insets, insets, insets, insets);
  }
  
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  self.layer.cornerRadius = floor(CGRectGetHeight(self.bounds) / 4);
}

#pragma mark - UIControl

- (void)sendActionsForControlEvents:(UIControlEvents)controlEvents {
  if ((controlEvents & UIControlEventTouchUpInside) != 0) {
    self.on = !self.on;
  }
  
  [super sendActionsForControlEvents:controlEvents];
}

#pragma mark - Setters

- (void)setOn:(BOOL)on {
  _on = on;
  
  UIColor *foregroundColor = on ? UIColor.blackColor : UIColor.whiteColor;
  UIColor *backgroundColor = on ? UIColor.whiteColor : UIColor.blackColor;
  self.tintColor = foregroundColor;
  self.backgroundColor = backgroundColor;
}

- (void)setOn:(BOOL)on animated:(BOOL)animated {
  void (^animationBlock)(void) = ^{
    self.on = on;
  };
  
  if (animated) {
    [UIView animateWithDuration:0.25 animations:animationBlock];
  } else {
    animationBlock();
  }
}

@end
