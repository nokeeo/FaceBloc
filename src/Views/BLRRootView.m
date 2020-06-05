//
//  BLRRootView.m
//  Blur
//
//  Created by Eric Lee on 6/4/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import "BLRRootView.h"

#import "LocalizationIDs.h"

static UIButton *CreateImportButton() {
  UIButton *button = [[UIButton alloc] init];
  [button setTitle:NSLocalizedString(BLRImportButtonStringID, @"Import photos button") forState:UIControlStateNormal];
  
  return button;
}

@implementation BLRRootView {
  UIButton *_importButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _importButton = CreateImportButton();
    _importButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_importButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [_importButton addTarget:self action:@selector(didTouchUpInsideImportButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_importButton];
    
    NSArray<NSLayoutConstraint *> *importButtonConstraint = @[
      [_importButton.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
      [_importButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
      [_importButton.leftAnchor constraintGreaterThanOrEqualToAnchor:self.leftAnchor],
      [_importButton.rightAnchor constraintLessThanOrEqualToAnchor:self.rightAnchor],
    ];
    [self addConstraints:importButtonConstraint];
    
    self.backgroundColor = UIColor.whiteColor;
  }
  
  return self;
}

#pragma mark - Target Actions

- (void)didTouchUpInsideImportButton:(id)sender {
  [_delegate rootViewDidSelectImportNewPhoto:self];
}

@end
