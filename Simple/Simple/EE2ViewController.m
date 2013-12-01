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
    
    NSLog(@" ** dismiss viewController");
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender {
    
}


@end
