//
//  TCVideoSignalCtrlViewController.h
//  TC
//
//  Created by 郭志伟 on 15/11/16.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLSignalCtrlerInfo.h"
#import "TVCamInfo.h"

@protocol TCVideoSignalCtrlViewControllerDelegate;

@interface TCVideoSignalCtrlViewController : UIViewController

@property(nonatomic, weak) id<TCVideoSignalCtrlViewControllerDelegate> delegate;

- (void)addSignalContrller:(TLSignalCtrlerInfo *)scInfo;
- (void)removeSignalController:(TLSignalCtrlerInfo *)scInfo;

- (void)resumeAll;

@property(nonatomic, strong)NSArray *selectedCamArray;
@property(nonatomic,strong)NSArray *selectedScArray;
@end

@protocol TCVideoSignalCtrlViewControllerDelegate <NSObject>

- (void)TCVideoSignalCtrlViewControllerBackToMapBtnPressed:(TCVideoSignalCtrlViewController *)videoSignalCtrlViewController;

- (void)TCVideoSignalCtrlViewController:(TCVideoSignalCtrlViewController *)videoSignalCtrlViewController didDeleteScInfo:(TLSignalCtrlerInfo *)scInfo;

- (void)TCVideoSignalCtrlViewController:(TCVideoSignalCtrlViewController *)videoSignalCtrlViewController camDidClosed:(TVCamInfo *)camInfo;

@end