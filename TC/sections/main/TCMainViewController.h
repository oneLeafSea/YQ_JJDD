//
//  TCMainViewController.h
//  TC
//
//  Created by 郭志伟 on 15/11/12.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "MainViewController.h"

@interface TCMainViewController : MainViewController

+ (TCMainViewController *)Instance;

- (void)hideLeftViewController:(BOOL)hide;
- (void)hideCloseLeftViewControllerButton:(BOOL)hide;

@end
