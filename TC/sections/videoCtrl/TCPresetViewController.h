//
//  TCPresetViewController.h
//  TC
//
//  Created by 郭志伟 on 15/12/8.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AirIMOSIphoneSDK.h"
#import "TCVideosViewController.h"
@protocol TCPresetViewControllerDelegate;

@interface TCPresetViewController : UIViewController

@property(nonatomic, strong)UVResourceInfo *resInfo;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, weak)id<TCPresetViewControllerDelegate> delegate;
@property(nonatomic, strong)NSMutableArray  *presetList;
@end


@protocol TCPresetViewControllerDelegate <NSObject>

- (void)TCPresetViewController:(TCPresetViewController *)presetViewController SetPresetResult:(BOOL)sucess error:(UVError *)error;

@end