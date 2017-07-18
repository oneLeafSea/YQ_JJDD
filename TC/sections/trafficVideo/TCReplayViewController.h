//
//  TCReplayViewController.h
//  TC
//
//  Created by 郭志伟 on 15/11/30.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TVCamInfo.h"
#import "AppDelegate.h"

@protocol TCReplayViewControllerDelgate;

@interface TCReplayViewController : UIViewController

@property(nonatomic, strong) TVCamInfo *camInfo;

@property(nonatomic, strong) UVResourceInfo *resInfo;

@property(nonatomic, weak) id<TCReplayViewControllerDelgate> delegate;

@end

@protocol TCReplayViewControllerDelgate <NSObject>

- (void)TCReplayViewControllerDidClose:(TCReplayViewController *)relpalyVC;
@end
