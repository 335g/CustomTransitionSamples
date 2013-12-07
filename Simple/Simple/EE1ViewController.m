//
//  EE1ViewController.m
//  Simple
//
//  Created by Yoshiki Kudo on 2013/12/01.
//  Copyright (c) 2013年 Yoshiki Kudo. All rights reserved.
//

#import "EE1ViewController.h"
#import "EE2ViewController.h"
#import "EEOpacityAnimator.h"
#import "EEHorizontalAnimator.h"

#pragma mark - Constants
typedef NS_ENUM (NSUInteger, EETransitionStyle) {
    EETransitionStyleDefault,
    EETransitionStyleOpacity,
    EETransitionStyleHorizon
};

#pragma mark
@interface EE1ViewController ()
    <
    UIViewControllerTransitioningDelegate
    >

@property (nonatomic) EETransitionStyle transitionStyle;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic) UIPercentDrivenInteractiveTransition *interactiveTransitionController;

- (void)myPresentViewController;
- (id<UIViewControllerAnimatedTransitioning>)animatorWithPresenting:(BOOL)presenting;
- (void)handleScreenEdgePan:(UIScreenEdgePanGestureRecognizer *)recognizer;
@end

#pragma mark
@implementation EE1ViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self valueChanged:self.segmentedControl];
    
    // ----------------------------------------------------------------------------------------------->> pan for interactive present
    UIScreenEdgePanGestureRecognizer *recognizer;
    recognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleScreenEdgePan:)];
    recognizer.edges = UIRectEdgeRight;
    [self.view addGestureRecognizer:recognizer];
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  << pan for interactive present
}


#pragma mark - Private
- (void)myPresentViewController {
    
    EE2ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"2"];
    
    if (self.transitionStyle != EETransitionStyleDefault) {
        vc.modalPresentationStyle = UIModalPresentationCustom;
        vc.transitioningDelegate = self;
    }
    
    // ----------------------------------------------------------------------------------------------->> log
    NSString *type;
    switch (self.transitionStyle) {
        case EETransitionStyleDefault:
            type = @"Default";
            break;
        case EETransitionStyleOpacity:
            type = @"Opacity";
            break;
        case EETransitionStyleHorizon:
            type = @"Horizon";
            break;
    }
    NSLog(@" ");
    NSLog(@" -> present viewController (%@)", type);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  << log
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (id <UIViewControllerAnimatedTransitioning>)animatorWithPresenting:(BOOL)presenting {
    
    if (self.transitionStyle == EETransitionStyleOpacity) {
        
        EEOpacityAnimator *animator = [EEOpacityAnimator new];
        animator.presenting = presenting;
        return animator;
        
    }else if (self.transitionStyle == EETransitionStyleHorizon) {
        
        EEHorizontalAnimator *animator = [EEHorizontalAnimator new];
        animator.presenting = presenting;
        return animator;
    }
    
    return nil;
}

#pragma mark - Action
- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self myPresentViewController];
}

- (void)handleScreenEdgePan:(UIScreenEdgePanGestureRecognizer *)recognizer {
    
    UIGestureRecognizerState state = recognizer.state;
    UIView *view = recognizer.view;
    
    if (state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [recognizer translationInView:view];
        CGFloat ratio = fabsf(translation.x/CGRectGetWidth(view.bounds));
        [self.interactiveTransitionController updateInteractiveTransition:ratio];
        
    }else if (state == UIGestureRecognizerStateBegan) {
        
        self.interactiveTransitionController = [UIPercentDrivenInteractiveTransition new];
        [self myPresentViewController];
        
    }else if (state == UIGestureRecognizerStateEnded) {
        
        CGPoint point = [recognizer locationInView:view];
        CGPoint velocity = [recognizer velocityInView:view];
        if (point.x < 270.0 && velocity.x < 0.0) {
            [self.interactiveTransitionController finishInteractiveTransition];
        }else {
            [self.interactiveTransitionController cancelInteractiveTransition];
        }
        self.interactiveTransitionController = nil;
        
    }else if (state == UIGestureRecognizerStateCancelled) {
        
        [self.interactiveTransitionController cancelInteractiveTransition];
        self.interactiveTransitionController = nil;
    }
    
}

- (IBAction)valueChanged:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.transitionStyle = EETransitionStyleDefault;
            break;
        case 1:
            self.transitionStyle = EETransitionStyleOpacity;
            break;
        case 2:
            self.transitionStyle = EETransitionStyleHorizon;
            break;
    }
}

#pragma mark - Delegate (Transition)
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source {
    return [self animatorWithPresenting:YES];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [self animatorWithPresenting:NO];
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.interactiveTransitionController;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return ((EE2ViewController *)self.presentedViewController).interactiveTransitionController;
}

#pragma mark - Interface Orientation
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

@end
