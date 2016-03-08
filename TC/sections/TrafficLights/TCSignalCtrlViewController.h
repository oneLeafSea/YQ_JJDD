//
//  TCSignalCtrlViewController.h
//  TC
//
//  Created by 郭志伟 on 15/11/16.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLSignalCtrlerInfo.h"

@protocol TCSignalCtrlViewControllerDelegate;

@interface TCSignalCtrlViewController : UIViewController

@property(weak, nonatomic) id<TCSignalCtrlViewControllerDelegate>delegate;

- (void)addSignalContrller:(TLSignalCtrlerInfo *)scInfo;
- (void)removeSignalController:(TLSignalCtrlerInfo *)scInfo;

@end

@protocol TCSignalCtrlViewControllerDelegate <NSObject>

- (void)TCSignalCtrlViewControllerBackToMapBtnPressed:(TCSignalCtrlViewController *)signalCtrlViewController;

- (void)TCSignalCtrlViewController:(TCSignalCtrlViewController *)signalCtrlViewController didDeleteScInfo:(TLSignalCtrlerInfo *)scInfo;

@end
