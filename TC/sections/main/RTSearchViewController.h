//
//  RTSearchViewController.h
//  MainControllerDemo
//
//  Created by 郭志伟 on 15/11/12.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTSearchViewController : UIViewController

@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, assign) CGFloat maxTableViewHeight;

@end
