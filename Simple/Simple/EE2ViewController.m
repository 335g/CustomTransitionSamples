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
- (void)viewDidLoad {
    [super viewDidLoad];
	
}

#pragma mark - Action
- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender {
    
}

#pragma mark - Interface Orientation
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    NSLog(@"%s", __func__);
    NSLog(@"topLayoutGuide.length:%f", [self.topLayoutGuide length]);
    NSLog(@"bottomLayoutGuide.length:%f", [self.bottomLayoutGuide length]);
}
@end
