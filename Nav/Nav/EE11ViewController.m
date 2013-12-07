//
//  EE11ViewController.m
//  Nav
//
//  Created by Yoshiki Kudo on 2013/12/07.
//  Copyright (c) 2013年 Yoshiki Kudo. All rights reserved.
//

#import "EE11ViewController.h"
#import "EEOpacityAnimator.h"

@interface EE11ViewController ()
    <
    UINavigationControllerDelegate,
    UINavigationBarDelegate
    >

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic) UIPercentDrivenInteractiveTransition *interactiveTransitionController;

- (id <UIViewControllerAnimatedTransitioning>)animatorWithPresenting:(BOOL)presenting;
- (void)handleScreenEdgePan:(UIScreenEdgePanGestureRecognizer *)recognizer;
@end

@implementation EE11ViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // ----------------------------------------------------------------------------------------------->> pan for interactive present
    UIScreenEdgePanGestureRecognizer *recognizer;
    recognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleScreenEdgePan:)];
    recognizer.edges = UIRectEdgeRight;
    [self.view addGestureRecognizer:recognizer];
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  << pan for interactive present
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self valueChanged:self.segmentedControl];
}

- (void)awakeFromNib {
    NSLog(@"nav.view.recognizers:%@", self.navigationController.view.gestureRecognizers);
}

#pragma mark - Action
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

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"12"];
    [self.navigationController pushViewController:vc animated:YES];
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
        [self tap:nil];
        
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
