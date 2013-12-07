//
//  EE12ViewController.m
//  Nav
//
//  Created by Yoshiki Kudo on 2013/12/07.
//  Copyright (c) 2013年 Yoshiki Kudo. All rights reserved.
//

#import "EE12ViewController.h"
#import "EEOpacityAnimator.h"

@interface EE12ViewController ()
    <
    UINavigationControllerDelegate
    >

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic) UIPercentDrivenInteractiveTransition *interactiveTransitionController;
@end

@implementation EE12ViewController
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self valueChanged:self.segmentedControl];
}

#pragma mark - Action
- (IBAction)tap:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)valueChanged:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.navigationController.delegate = nil;
            break;
        case 1:
            self.navigationController.delegate = self;
            break;
    }
}
- (IBAction)pan:(UIPanGestureRecognizer *)recognizer {
    
    UIGestureRecognizerState state = recognizer.state;
    UIView *view = recognizer.view;
    
    if (state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [recognizer translationInView:view];
        CGFloat longer = CGRectGetWidth(view.bounds) > CGRectGetHeight(view.bounds) ? view.bounds.size.width : view.bounds.size.height;
        CGFloat ratio = fabsf(sqrtf(powf(translation.x, 2.0) + powf(translation.y, 2.0))/longer);
        [self.interactiveTransitionController updateInteractiveTransition:ratio];
        
    }else if (state == UIGestureRecognizerStateBegan) {
        
        self.interactiveTransitionController = [UIPercentDrivenInteractiveTransition new];
        [self tap:nil];
        
    }else if (state == UIGestureRecognizerStateEnded) {
        
        [self.interactiveTransitionController finishInteractiveTransition];
        self.interactiveTransitionController = nil;
        
    }else if (state == UIGestureRecognizerStateCancelled) {
        
        [self.interactiveTransitionController cancelInteractiveTransition];
        self.interactiveTransitionController = nil;
    }
}

#pragma mark - Delegate (Nav)
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    
    if (operation == UINavigationControllerOperationPop) {
        return [self animatorWithPresenting:NO];
    }else {
        return [self animatorWithPresenting:YES];
    }
    
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    
    return self.interactiveTransitionController;
}

#pragma mark - Private
- (id <UIViewControllerAnimatedTransitioning>)animatorWithPresenting:(BOOL)presenting {
    
    EEOpacityAnimator *animator = [EEOpacityAnimator new];
    animator.presenting = presenting;
    return animator;
}

@end
