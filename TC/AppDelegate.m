//
//  AppDelegate.m
//  TC
//
//  Created by 郭志伟 on 15/10/14.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "AppDelegate.h"
#import "TC-swift.h"

#import "TLAPI.h"
#import "TLMgr.h"
#import "env.h"
#import "LogLevel.h"
#import "DDFileLogger.h"
#import "RTWSContstants.h"


@interface AppDelegate () <RTWSMgrDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initLogger];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary    dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    [self setDefaults];
    self.tlMgr = [[TLMgr alloc] init];
    self.tvMgr = [[TVMgr alloc] init];
    self.wsMgr = [[RTWSMgr alloc] initWithAddr:kWsAddr];
    self.wsMgr.delegate = self;
    self.tgMgr = [[TCTollgateMgr alloc] init];
    return YES;
}


- (void)initLoginMgr {
    self.loginMgr = [[LoginMgr alloc] init];
    [self.loginMgr loginWithUserName:@"gzw" password:@"11" completion:^(BOOL finished, NSError *error) {
        
    }];
}

- (TCNavMainViewController *)buildMainController {
    TCNavMainViewController *mvc = [TCNavMainViewController navMainViewController];
    self.window.rootViewController = mvc;
    return mvc;
}

- (void)setDefaults {
    NSUserDefaults *ud =  [NSUserDefaults standardUserDefaults];
#ifndef YUAN_QU_DA_DUI
//    [ud setObject:@"114.242.167.119" forKey:@"tv.ip"];
//    [ud setObject:@52060 forKey:@"tv.port"];
//    [ud setObject:@"yangfa" forKey:@"tv.user"];
//    [ud setObject:@"yangfa" forKey:@"tv.pwd"];
    [ud setObject:@"60.12.249.162" forKey:@"tv.ip"];
    [ud setObject:@52060 forKey:@"tv.port"];
    [ud setObject:@"guest1" forKey:@"tv.user"];
    [ud setObject:@"uniview" forKey:@"tv.pwd"];
#else
    [ud setObject:@"10.100.8.199" forKey:@"tv.ip"];
    [ud setObject:@52060 forKey:@"tv.port"];
    [ud setObject:@"gzw" forKey:@"tv.user"];
    [ud setObject:@"gzw" forKey:@"tv.pwd"];
//    [ud setObject:@"gzw" forKey:@"tv.user"];
//    [ud setObject:@"gzw" forKey:@"tv.pwd"];
#endif
}

- (void)changeRootViewController:(UIViewController*)viewController {
    
    if (!self.window.rootViewController) {
        self.window.rootViewController = viewController;
        return;
    }
    
    UIView *snapShot = [self.window snapshotViewAfterScreenUpdates:YES];
    [viewController.view addSubview:snapShot];
    
    self.window.rootViewController = viewController;
    
    [UIView animateWithDuration:0.5 animations:^{
        snapShot.layer.opacity = 0;
        snapShot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
    } completion:^(BOOL finished) {
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)RTWSMgr:(RTWSMgr *)wsMgr socketDidCloseWithReason:(NSString *)reason {
    NSLog(@"ws 断开");
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



@end
