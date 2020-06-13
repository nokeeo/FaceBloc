// Copyright © 2020 Eric Lee All rights reserved.
// This file is subject to the terms and conditions defined in the file, LICENSE.md, included with
// this project.

#import "FBLCRootView.h"

#import "LocalizationIDs.h"
#import "UIView+AutoLayout.h"

static UIButton *CreateImportButton() {
  UIButton *button = [[UIButton alloc] init];
  button.backgroundColor = UIColor.grayColor;
  button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
  button.layer.cornerRadius = 15;
  button.clipsToBounds = YES;
  [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
  [button setTitle:NSLocalizedString(FBLCImportButtonStringID, @"Import photos button") forState:UIControlStateNormal];

  return button;
}

@implementation FBLCRootView {
  UIButton *_importButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _importButton = CreateImportButton();
    _importButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_importButton addTarget:self
                      action:@selector(didTouchUpInsideImportButton:)
            forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:_importButton];
    [self fblc_addConstraints:[_importButton fblc_constraintsCenteredInSuperview]];

    UILayoutGuide *safeAreaLayoutGuide = self.safeAreaLayoutGuide;
    CGSize importButtonIntrinsicSize = _importButton.intrinsicContentSize;
    [self addConstraints:@[
      [_importButton.leftAnchor constraintGreaterThanOrEqualToAnchor:safeAreaLayoutGuide.leftAnchor],
      [_importButton.rightAnchor constraintLessThanOrEqualToAnchor:safeAreaLayoutGuide.rightAnchor],
      [_importButton.widthAnchor constraintGreaterThanOrEqualToAnchor:self.widthAnchor multiplier:0.65 constant:0],
      [_importButton.heightAnchor constraintGreaterThanOrEqualToConstant:importButtonIntrinsicSize.height + 18],
    ]];

    self.backgroundColor = UIColor.blackColor;
  }

  return self;
}

#pragma mark - Target Actions

- (void)didTouchUpInsideImportButton:(id)sender {
  [_delegate rootViewDidSelectImportNewPhoto:self];
}

@end
