//
//  MainViewController.h
//  TC
//
//  Created by 郭志伟 on 15/11/12.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

- (instancetype)initWithLeftViewController:(UIViewController *)leftViewController
                      centerViewController:(UIViewController *)centerViewController;

- (void)centerViewControllerWillShiftWithPreViewController:(UIViewController *)preViewController
                                     currentViewController:(UIViewController *)currentVewController;

@property(nonatomic, strong)UIViewController *centerViewController;
@property(nonatomic, strong)UIViewController *leftViewController;

@property(nonatomic, assign)BOOL showLeftViewController;

@property(nonatomic, assign)CGFloat leftViewControllerWidth;

@end
