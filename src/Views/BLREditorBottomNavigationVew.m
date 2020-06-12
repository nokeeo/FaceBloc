//
//  BLREditorBottomNavigationVew.m
//  Blur
//
//  Created by Eric Lee on 6/5/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import "BLREditorBottomNavigationView.h"

#import "BLREditorBottomNavigationButton.h"
#import "UIView+AutoLayout.h"

static UIStackView *CreateItemStackView() {
  UIStackView *view = [[UIStackView alloc] init];
  view.axis = UILayoutConstraintAxisHorizontal;

  return view;
}

@implementation BLREditorBottomNavigationView {
  UIStackView *_itemStackView;

  BLREditorBottomNavigationButton *_faceObfuscationButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _itemStackView = CreateItemStackView();

    BLREditorBottomNavigationButton *_faceObfuscationButton = [[BLREditorBottomNavigationButton alloc] init];
    _faceObfuscationButton.on = YES;

    UIImage *image = [[UIImage imageNamed:@"person"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_faceObfuscationButton setImage:image forState:UIControlStateNormal];
    [_faceObfuscationButton setContentHuggingPriority:UILayoutPriorityDefaultHigh
                                              forAxis:UILayoutConstraintAxisHorizontal];
    [_faceObfuscationButton addTarget:self
                               action:@selector(didTouchUpInsideFaceObfuscationButton)
                     forControlEvents:UIControlEventTouchUpInside];
    [_itemStackView addArrangedSubview:_faceObfuscationButton];

    [self addSubview:_itemStackView];

    UILayoutGuide *safeAreaLayoutGuide = self.safeAreaLayoutGuide;
    _itemStackView.translatesAutoresizingMaskIntoConstraints = NO;
    BLREdgeConstraints *itemConstraints =
        [_itemStackView blr_constraintsAttachedToLayoutGuideEdges:self.safeAreaLayoutGuide];
    [self addConstraints:@[
      itemConstraints.top,
      itemConstraints.bottom,
      [_itemStackView.leftAnchor constraintGreaterThanOrEqualToAnchor:safeAreaLayoutGuide.leftAnchor],
      [_itemStackView.rightAnchor constraintLessThanOrEqualToAnchor:safeAreaLayoutGuide.rightAnchor],
      [_itemStackView.centerXAnchor constraintEqualToAnchor:safeAreaLayoutGuide.centerXAnchor],
    ]];
  }

  return self;
}

#pragma mark - Target Actions

- (void)didTouchUpInsideFaceObfuscationButton {
  BOOL shouldObfuscateFaces = ![_faceObfuscationButton isOn];
  _faceObfuscationButton = shouldObfuscateFaces;
}

@end
