//
//  UIView+Log.m
//  Simple
//
//  Created by Yoshiki Kudo on 2013/12/01.
//  Copyright (c) 2013年 Yoshiki Kudo. All rights reserved.
//

#import "UIView+Log.h"

@implementation UIView (Log)
- (void)logWithID:(NSString *)index {
    
    NSLog(@"%@", [NSString stringWithFormat:@"frame:%@, bounds:%@, center:%@, transform:%@ - (%@)",
                  NSStringFromCGRect(self.frame),
                  NSStringFromCGRect(self.bounds),
                  NSStringFromCGPoint(self.center),
                  NSStringFromCGAffineTransform(self.transform),
                  index]);
}


@end
