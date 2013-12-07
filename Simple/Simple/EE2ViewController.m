//
//  EE2ViewController.m
//  Simple
//
//  Created by Yoshiki Kudo on 2013/12/01.
//  Copyright (c) 2013年 Yoshiki Kudo. All rights reserved.
//

#import "EE2ViewController.h"

@interface EE2ViewController ()

@end

@implementation EE2ViewController

#pragma mark - Action
- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pan:(UIPanGestureRecognizer *)recognizer {
    
    UIGestureRecognizerState state = recognizer.state;
    UIView *view = recognizer.view;
    
    if (state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [recognizer translationInView:view];
        CGFloat ratio = 0.0;
        if (translation.x > 0) {
            ratio = translation.x/CGRectGetWidth(view.bounds);
        }
        [self.interactiveTransitionController updateInteractiveTransition:ratio];
        
    }else if (state == UIGestureRecognizerStateBegan) {
        
        self.interactiveTransitionController = [UIPercentDrivenInteractiveTransition new];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        
    }else if (state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [recognizer velocityInView:view];
        CGFloat boundary = view.bounds.size.width * 0.2;
        CGPoint translation = [recognizer translationInView:view];
        CGFloat dist = sqrt(pow(translation.x, 2.0) + pow(translation.y, 2.0));
        if (dist > boundary && velocity.x > 0.0) {
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

#pragma mark - Interface Orientation
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    
//    NSLog(@"%s", __func__);
//    NSLog(@"topLayoutGuide.length:%f", [self.topLayoutGuide length]);
//    NSLog(@"bottomLayoutGuide.length:%f", [self.bottomLayoutGuide length]);
//}
@end
