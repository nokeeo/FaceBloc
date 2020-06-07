//
//  BLRActivityViewController.m
//  Blur
//
//  Created by Eric Lee on 6/7/20.
//  Copyright © 2020 Nokeeo. All rights reserved.
//

#import "BLRActivityViewController.h"

#import "UIView+AutoLayout.h"

static const CGFloat kActivityIndicatorSize = 95;

static UIActivityIndicatorViewStyle GetIndicatorStyle() {
  if (@available(iOS 13.0, *)) {
    return UIActivityIndicatorViewStyleWhiteLarge;
  }
  
  return UIActivityIndicatorViewStyleWhite;
}

static UIBlurEffectStyle GetBlurEffectStyle() {
  if (@available(iOS 13.0, *)) {
    return UIBlurEffectStyleSystemChromeMaterialDark;
  }
  
  return UIBlurEffectStyleDark;
}

static CGAffineTransform GetInitialTransform() {
  CGAffineTransform scaleTransform = CGAffineTransformScale(CGAffineTransformIdentity, 0.75, 0.75);
  return CGAffineTransformTranslate(scaleTransform, 0, 6);
}

#pragma mark -

@implementation BLRActivityViewPresentationController

- (BOOL)shouldPresentInFullscreen {
  return NO;
}

- (CGRect)frameOfPresentedViewInContainerView {
  CGSize indicatorSize = CGSizeMake(kActivityIndicatorSize, kActivityIndicatorSize);
  
  CGRect containerBounds = self.containerView.bounds;
  CGFloat x = (CGRectGetWidth(containerBounds) - indicatorSize.width) / 2.f;
  CGFloat y = (CGRectGetHeight(containerBounds) - indicatorSize.height) / 2.f;
  CGRect viewFrame = CGRectMake(x, y, indicatorSize.width, indicatorSize.height);
  
  return CGRectIntegral(viewFrame);
}

@end

#pragma mark -

@interface BLRActivityViewControllerTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property(nonatomic, getter=isPresenting) BOOL presenting;

- (instancetype)initWithPresenting:(BOOL)isPresenting;

- (instancetype)init NS_UNAVAILABLE;

@end

@implementation BLRActivityViewControllerTransitionAnimator

- (instancetype)initWithPresenting:(BOOL)isPresenting {
  self = [super init];
  if (self) {
    _presenting = isPresenting;
  }
  
  return self;
}

#pragma mark UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.2;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  if (_presenting) {
    [self performTransitionForAppearing:transitionContext];
  } else {
    [self performTransitionForDisappearing:transitionContext];
  }
}

#pragma mark Private Methods

- (void)performTransitionForAppearing:(id<UIViewControllerContextTransitioning>)transitionContext {
  UIViewController *activityViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  CGRect finalFrame = [transitionContext finalFrameForViewController:activityViewController];
  UIView *activityView = activityViewController.view;
  activityView.alpha = 0;
  activityView.transform = GetInitialTransform();
  
  // Set the center and bounds instead of the frame because the transform is set. As of writing this,
  // setting the frame with a non identity tranform has undefined behavior.
  activityView.center = CGPointMake(CGRectGetMidX(finalFrame), CGRectGetMidY(finalFrame));
  activityView.bounds = CGRectMake(0, 0, CGRectGetWidth(finalFrame), CGRectGetHeight(finalFrame));
  
  UIView *containerView = transitionContext.containerView;
  [containerView addSubview:activityView];
  
  NSTimeInterval duration = [self transitionDuration:transitionContext];
  [UIView animateWithDuration:duration animations:^{
    activityView.alpha = 1;
    activityView.transform = CGAffineTransformIdentity;
    [transitionContext completeTransition:YES];
  }];
}

- (void)performTransitionForDisappearing:(id<UIViewControllerContextTransitioning>)transitionContext {
  UIViewController *activityViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIView *activityView = activityViewController.view;
  
  NSTimeInterval duration = [self transitionDuration:transitionContext];
  [UIView animateWithDuration:duration animations:^{
    activityView.alpha = 0;
    activityView.transform = GetInitialTransform();
  } completion:^(BOOL finished) {
    [activityView removeFromSuperview];
    [transitionContext completeTransition:YES];
  }];
}

@end

#pragma mark -

@implementation BLRActivityViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
  }
  
  return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:GetIndicatorStyle()];
  indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
  [indicatorView startAnimating];
  
  UIBlurEffect *visualEffect = [UIBlurEffect effectWithStyle:GetBlurEffectStyle()];
  UIVisualEffectView *visualEffectsView = [[UIVisualEffectView alloc] initWithEffect:visualEffect];
  visualEffectsView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:visualEffectsView];
  
  [visualEffectsView.contentView addSubview:indicatorView];
  
  BLRCenterConstraints *indicatorCenterConstraints = [indicatorView blr_constraintsCenteredInSuperview];
  BLREdgeConstraints *visualEffectsConstraints = [visualEffectsView blr_constraintsAttachedToSuperviewEdges];
  [self.view blr_addConstraints:visualEffectsConstraints];
  [self.view blr_addConstraints:indicatorCenterConstraints];
  
  self.view.clipsToBounds = YES;
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  
  CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
  self.view.layer.cornerRadius = viewHeight / 3.7;
  
}

#pragma mark UIViewControllerTransitioningDelegate

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
  return [[BLRActivityViewPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
  return [[BLRActivityViewControllerTransitionAnimator alloc] initWithPresenting:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
  return [[BLRActivityViewControllerTransitionAnimator alloc] initWithPresenting:NO];
}

@end
