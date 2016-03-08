//
//  AppDelegate.h
//  TC
//
//  Created by 郭志伟 on 15/10/14.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginMgr.h"
#import "TLMgr.h"
#import "TVMgr.h"
#import "TCNavMainViewController.h"

#import "RTWSMgr.h"
#import "TCTollgateMgr.h"
#import "TCUser.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) LoginMgr *loginMgr;

- (void)changeRootViewController:(UIViewController*)viewController;

- (TCNavMainViewController *)buildMainController;

@property(nonatomic, strong) TLMgr *tlMgr;

@property(nonatomic, strong) TVMgr *tvMgr;

@property(nonatomic, strong) RTWSMgr *wsMgr;

@property(nonatomic, strong) TCTollgateMgr *tgMgr;

@property(nonatomic, strong) TCUser *usr;

@end

#define APP_DELEGATE ((AppDelegate*)[[UIApplication sharedApplication] delegate])