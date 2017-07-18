//
//  TCNavMainViewController.m
//  TC
//
//  Created by 郭志伟 on 15/11/12.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TCNavMainViewController.h"
#import "TCMainViewController.h"
#import "UIColor+Hexadecimal.h"

@implementation TCNavMainViewController

+ (TCNavMainViewController *)navMainViewController {
    TCMainViewController *mainVC = [TCMainViewController Instance];
    TCNavMainViewController *navVC = [[TCNavMainViewController alloc] initWithRootViewController:mainVC];
    navVC.navigationBar.barTintColor = [UIColor colorWithHex:@"#018bba"];
    navVC.navigationBar.tintColor = [UIColor whiteColor];
    return navVC;
}

@end
