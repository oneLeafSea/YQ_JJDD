//
//  AppDelegate.m
//  TC
//
//  Created by 郭志伟 on 15/10/14.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "AppDelegate.h"
//#import "TC-swift.h"
#import<CoreLocation/CoreLocation.h>
#import "TLAPI.h"
#import "TLMgr.h"
#import "env.h"
#import "LogLevel.h"
#import "DDFileLogger.h"
#import "RTWSContstants.h"
#import "TCNotification.h"
#import "LoginViewController.h"
#import "TCFuncViewController.h"

#import "TCDYNotificatin.h"
@interface AppDelegate () <RTWSMgrDelegate, TCTollgateMgrDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    //[_window makeKeyAndVisible];
//    NSURL *url = [NSURL URLWithString:@"prefs:rooten = General & path = ManagedConfigurationList"];
//    [[UIApplication sharedApplication]openURL:url];
    
    [self initLogger];
    //如果已经获得发送通知的授权则创建本地通知，否则请求授权(注意：如果不请求授权在设置中是没有对应的通知设置项的，也就是说如果从来没有发送过请求，即使通过设置也打不开消息允许设置)
    if ([[UIApplication sharedApplication]currentUserNotificationSettings].types ==UIUserNotificationTypeNone)
    {
        [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound  categories:nil]];
    }
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary    dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    
    
    self.tlMgr = [[TLMgr alloc] init];
    self.tvMgr = [[TVMgr alloc] init];
    self.tDyC=[[TCTollgateDYViewController alloc]init];
    self.wsMgr = [[RTWSMgr alloc] initWithAddr:kWsAddr];
    self.wsMgr.delegate = self;
    self.tgMgr = [[TCTollgateMgr alloc] init];
    self.tgMgr.delegate = self;
   return YES;
}


- (void)initLoginMgr {
    self.loginMgr = [[LoginMgr alloc] init];
    [self.loginMgr loginWithUserName:@"gzw" password:@"11" completion:^(BOOL finished, NSError *error) {
        if (finished) {
            NSLog(@"gzw get in");
        }
        
    }];
}

- (TCNavMainViewController *)buildMainController {
    TCNavMainViewController *mvc = [TCNavMainViewController navMainViewController];
    self.window.rootViewController = mvc;
    return mvc;
}


- (void)changeRootViewController:(UIViewController*)viewController {
    
    if (!self.window.rootViewController) {
        self.window.rootViewController = viewController;
        return;
    }
    
    UIView *snapShot = [self.window snapshotViewAfterScreenUpdates:YES];
    [viewController.view addSubview:snapShot];
    
    self.window.rootViewController = viewController;
    
    [UIView animateWithDuration:1.5 animations:^{
        snapShot.layer.opacity = 0;
        snapShot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
    } completion:^(BOOL finished) {
        NSLog(@"%@",[NSDate date]);
        [snapShot removeFromSuperview];
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   
   [[UIApplication sharedApplication]setKeepAliveTimeout:600 handler:^{
       
       if (_webSocket == nil) return;
       
       NSMutableDictionary *allDict = [[NSMutableDictionary alloc] initWithCapacity:4];
       [allDict setValue:@"msgid" forKey:@"msgid"];
       [allDict setValue:@"ping" forKey:@"topic"];
       [allDict setValue:@"2016-09-28" forKey:@"timestamp"];
       
       NSData *data = [NSJSONSerialization dataWithJSONObject:allDict options:NSJSONWritingPrettyPrinted error:nil];
       
       NSString *finalParams = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
       [_webSocket send:finalParams];
   }];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication]clearKeepAliveTimeout];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];//进入前台取消应用消息图标

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)RTWSMgr:(RTWSMgr *)wsMgr socketDidCloseWithReason:(NSString *)reason {
   TCFuncViewController *func=[[TCFuncViewController alloc]init];
    [func handleExit];
}


- (void)initLogger {
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    UIColor *green = [UIColor colorWithRed:(0/255.0) green:(125/255.0) blue:(0/255.0) alpha:1.0];
    [[DDTTYLogger sharedInstance] setForegroundColor:green backgroundColor:nil forFlag:LOG_FLAG_INFO];
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
}

- (void)TCTollgateMgr:(TCTollgateMgr *)tgMgr newPushNotifications:(NSArray *)notifications {
    [notifications enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TCTollgateNotification *tgn = obj;
        [tgn insertToDbWithDbq:self.usr.dbq];
    }];
}
- (void)TCTollgateBKMgr:(TCTollgateMgr *)tgMgr newPushNotifications:(NSArray *)notifications{
    [notifications enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         TCTollgateNotification *tgn = obj;
        [tgn insertToDbBKWithDbq:self.usr.dbq];
    }];

}
- (void)TCTollgateDYMgr:(TCTollgateMgr *)tgMgr newPushNotifications:(NSArray *)notifications{
    [notifications enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TCDYNotificatin *tgn = obj;
        [tgn insertToDYDbWithDbq:self.usr.dbq];
    }];
    
}

@end
