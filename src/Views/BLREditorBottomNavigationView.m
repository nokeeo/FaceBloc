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
#import "LocalizationIDs.h"

static const CGFloat kHorizonalEdgePadding = 8;

static UIStackView *CreateItemStackView() {
  UIStackView *view = [[UIStackView alloc] init];
  view.axis = UILayoutConstraintAxisHorizontal;
  view.spacing = 12;
  
  return view;
}

static UIButton *CreateTextButton(NSString *title) {
  UIButton *button = [[UIButton alloc] init];
  [button setTitle:title forState:UIControlStateNormal];
  [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
  
  return button;
}

@implementation BLREditorBottomNavigationView {
  UIStackView *_itemStackView;
  
  BLREditorBottomNavigationButton *_faceObfuscationButton;
  BLREditorBottomNavigationButton *_drawButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _itemStackView = CreateItemStackView();
    _itemStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _faceObfuscationButton = [[BLREditorBottomNavigationButton alloc] init];
    _faceObfuscationButton.on = YES;
    
    UIImage *personIcon = [[UIImage imageNamed:@"person"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_faceObfuscationButton setImage:personIcon forState:UIControlStateNormal];
    [_faceObfuscationButton setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [_faceObfuscationButton addTarget:self action:@selector(didTouchUpInsideFaceObfuscationButton) forControlEvents:UIControlEventTouchUpInside];
    [_itemStackView addArrangedSubview:_faceObfuscationButton];
    
    _drawButton = [[BLREditorBottomNavigationButton alloc] init];
    UIImage *drawIcon = [[UIImage imageNamed:@"draw"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_drawButton setImage:drawIcon forState:UIControlStateNormal];
    [_drawButton setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [_drawButton addTarget:self action:@selector(didTapDrawButton) forControlEvents:UIControlEventTouchUpInside];
    [_itemStackView addArrangedSubview:_drawButton];
    
    UIButton *cancelButton = CreateTextButton(NSLocalizedString(BLRCancelButtonStringID, nil));
    cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [cancelButton addTarget:self action:@selector(didTapCancelButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *saveButton = CreateTextButton(NSLocalizedString(BLRSaveButtonStringID, nil));
    UIFont *currentSaveButtonFont = saveButton.titleLabel.font;
    saveButton.translatesAutoresizingMaskIntoConstraints = NO;
    saveButton.titleLabel.font = [UIFont boldSystemFontOfSize:currentSaveButtonFont.pointSize];
    [saveButton addTarget:self action:@selector(didTapSaveButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:cancelButton];
    [self addSubview:_itemStackView];
    [self addSubview:saveButton];
    
    UILayoutGuide *safeAreaLayoutGuide = self.safeAreaLayoutGuide;
    BLREdgeConstraints *itemStackViewConstraints = [_itemStackView blr_constraintsAttachedToLayoutGuideEdges:safeAreaLayoutGuide];
    [self addConstraints:@[
      itemStackViewConstraints.top,
      itemStackViewConstraints.bottom,
      [_itemStackView.leadingAnchor constraintGreaterThanOrEqualToAnchor:cancelButton.trailingAnchor],
      [_itemStackView.trailingAnchor constraintLessThanOrEqualToAnchor:safeAreaLayoutGuide.trailingAnchor],
      [_itemStackView.centerXAnchor constraintEqualToAnchor:safeAreaLayoutGuide.centerXAnchor],
    ]];
    
    BLREdgeConstraints *cancelButtonConstraints = [cancelButton blr_constraintsAttachedToLayoutGuideEdges:safeAreaLayoutGuide];
    [self addConstraints:@[
      [cancelButton.leadingAnchor constraintEqualToAnchor:safeAreaLayoutGuide.leadingAnchor constant:kHorizonalEdgePadding],
      cancelButtonConstraints.top,
      cancelButtonConstraints.bottom,
    ]];
    
    BLREdgeConstraints *saveButtonConstraints = [saveButton blr_constraintsAttachedToLayoutGuideEdges:safeAreaLayoutGuide];
    [self addConstraints:@[
      [saveButton.trailingAnchor constraintEqualToAnchor:safeAreaLayoutGuide.trailingAnchor constant:-kHorizonalEdgePadding],
      saveButtonConstraints.top,
      saveButtonConstraints.bottom,
    ]];
  }
  
  return self;
}

#pragma mark - Getters

- (BOOL)shouldObscureFaces {
  return _faceObfuscationButton.isOn;
}

- (BOOL)isDrawingEnabled {
  return [_drawButton isOn];
}

#pragma mark - Target Actions

- (void)didTouchUpInsideFaceObfuscationButton {
  BOOL shouldObfuscateFaces = ![_faceObfuscationButton isOn];
  [_faceObfuscationButton setOn:shouldObfuscateFaces animated:YES];
  [_delegate editorBottomNavigationView:self didChangeFaceObfuscation:shouldObfuscateFaces];
}

- (void)didTapDrawButton {
  BOOL drawingEnabled = ![_drawButton isOn];
  [_drawButton setOn:drawingEnabled animated:YES];
  [_delegate editorBottomNavigationView:self didEnableDrawing:drawingEnabled];
}

- (void)didTapCancelButton {
  [_delegate editorBottomNavigationViewDidCancelEditing:self];
}

- (void)didTapSaveButton {
  [_delegate editorBottomNavigationViewDidTapSaveButton:self];
}

@end
