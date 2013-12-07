//
//  EEHorizontalAnimator.m
//  Simple
//
//  Created by Yoshiki Kudo on 2013/12/01.
//  Copyright (c) 2013年 Yoshiki Kudo. All rights reserved.
//

#import "EEHorizontalAnimator.h"
#import "UIView+Log.h"

@implementation EEHorizontalAnimator
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
    
    CGPoint toCenter;
    if (self.presenting) {
        
        toVC.view.bounds = fromVC.view.bounds;
        toCenter = fromVC.view.center;
        
        
        // addSubviewしてから座標系修正すると問題無し
        //[containerView addSubview:toVC.view];
        
        // ----------------------------------------------------------------------------------------------->> addSubviewする前に上下にずらして配置するとtopLayoutGuideが0に
        CGFloat deltaX, deltaY;
        switch (fromVC.interfaceOrientation) {
            case UIInterfaceOrientationPortrait:
                NSLog(@"Portrait");
                deltaX = fromVC.view.bounds.size.width;
                deltaY = 0.0; // <-------------------------- これを少しでもずらすとtopLayoutGuideが0.0に
                break;
            case UIInterfaceOrientationLandscapeRight:
                NSLog(@"LandscapeRight"); // 座標系が90°回転してる
                deltaX = 0.0; // <-------------------------- これを少しでもずらすとtopLayoutGuideが0.0に
                deltaY = fromVC.view.bounds.size.width;
                break;
            case UIInterfaceOrientationLandscapeLeft:
                NSLog(@"LandscapeLeft"); // 座標系が90°回転してる
                deltaX = 0.0; // <-------------------------- これを少しでもずらすとtopLayoutGuideが0.0に
                deltaY = - fromVC.view.bounds.size.width;
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                NSLog(@"PortraitUpsideDown");
                deltaX = - fromVC.view.bounds.size.width;
                deltaY = 0.0; // <-------------------------- これを少しでもずらすとtopLayoutGuideが0.0に
                break;
        }
        toVC.view.center = CGPointMake(toCenter.x + deltaX, toCenter.y + deltaY);
        //  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - <<
        
        // addSubviewする前に座標系修正すると問題有り
        [containerView addSubview:toVC.view];
        
        
    }else {
        
        CGFloat deltaX, deltaY;
        switch (fromVC.interfaceOrientation) {
            case UIInterfaceOrientationPortrait:
                NSLog(@"Portrait");
                deltaX = fromVC.view.bounds.size.width;
                deltaY = 0.0;
                break;
            case UIInterfaceOrientationLandscapeRight:
                NSLog(@"LandscapeRight");
                deltaX = 0.0;
                deltaY = fromVC.view.bounds.size.width;
                break;
            case UIInterfaceOrientationLandscapeLeft:
                NSLog(@"LandscapeLeft");
                deltaX = 0.0;
                deltaY = - fromVC.view.bounds.size.width;
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                NSLog(@"PortraitUpsideDown");
                deltaX = - fromVC.view.bounds.size.width;
                deltaY = 0.0;
                break;
        }
        toCenter = CGPointMake(fromVC.view.center.x + deltaX, fromVC.view.center.y + deltaY);
        
        [containerView insertSubview:toVC.view belowSubview:fromVC.view];
        toVC.view.center = fromVC.view.center;
        
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         if (self.presenting) {
                             toVC.view.center = toCenter;
                         }else {
                             fromVC.view.center = toCenter;
                         }
                         
                     }
                     completion:^(BOOL finished){
                         BOOL isCompleted = ! [transitionContext transitionWasCancelled];
                         [transitionContext completeTransition:isCompleted];
                         
                     }];
    
}
@end
