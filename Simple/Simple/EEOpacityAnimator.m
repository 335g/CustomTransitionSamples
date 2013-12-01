//
//  EEOpacityAnimator.m
//  Simple
//
//  Created by Yoshiki Kudo on 2013/12/01.
//  Copyright (c) 2013年 Yoshiki Kudo. All rights reserved.
//

#import "EEOpacityAnimator.h"
#import "UIView+Log.h"

@implementation EEOpacityAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    // ----------------------------------------------------------------------------------------------->> log (by my category)
    [fromVC.view logWithID:@"fromVC.view"];
    [toVC.view logWithID:@"toVC.view"];
    [containerView logWithID:@"containerView"];
    //  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - << log (by my category)
    
    if (self.presenting) {
        toVC.view.alpha = 0.0;
        [containerView addSubview:toVC.view];
        
    }else {
        [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         if (self.presenting) {
                             toVC.view.alpha = 1.0;
                         }else {
                             fromVC.view.alpha = 0.0;
                         }
                         
                     }
                     completion:^(BOOL finished){
                         BOOL isCompleted = ! [transitionContext transitionWasCancelled];
                         [transitionContext completeTransition:isCompleted];
                         
                     }];
}

@end
