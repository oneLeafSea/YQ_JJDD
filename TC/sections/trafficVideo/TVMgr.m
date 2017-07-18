//
//  TVMgr.m
//  TC
//
//  Created by 郭志伟 on 15/11/23.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TVMgr.h"
#import "AppDelegate.h"
@implementation TVMgr

- (instancetype)init {
    if (self = [super init]) {
           
    }
    return self;
}
-(UVServiceManager*)service{
     if (_service == nil) {
        _service = [UVServiceManager instance];
        [_service enableDebug:NO];
    }
    return _service;
}

- (UVRequest *)request {
    if (_request == nil) {
        _request = [UVRequest instance];
    }
    return _request;
}

- (void)loginWithInView:(UIView *)view
             completion:(void(^)(BOOL finished, NSError *error))completion {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    //NSString *ip = [ud objectForKey:@"tv.ip"];
    //NSNumber *port = [ud objectForKey:@"tv.port"];
   // NSString *usr=APP_DELEGATE.
    NSString *usr = [ud objectForKey:@"tv.user"];
    NSString *pwd = [ud objectForKey:@"tv.pwd"];
    NSString *ip=@"10.100.8.199";
    NSNumber *port=@52060;
//    NSString *usr=@"xiangsy";
//    NSString *pwd=@"xiangsy";
    __block UVLoginParam *lp = [[UVLoginParam alloc] init];
    lp.server = ip;
    lp.port = [port intValue];
   lp.username = usr;
    lp.password = [UVUtils md5passwd:pwd];
    NSLog(@"%@,%d,%@,%@",lp.server,lp.port,lp.username,lp.password);
    
   [self.request execRequest:^{
        [self.service login:lp];
    
   } finish:^(UVError *error){
    
        if (error == nil) {
            completion(YES, nil);
        } else {
           NSError *err = [NSError errorWithDomain:@"tvMgr.login" code:error.code userInfo:@{@"desc": error.message ? error.message  : @""}];
           completion(NO, err);
           NSLog(@"后台通信出错");
        }
       }showProgressInView:view message:@"登录视频服务器"];
}
- (void)queryResourceWithKeyword:(NSString *)keyword completion:(void(^)(NSArray *resList, NSError *error))completion {
    UVQueryCondition *condition = [[UVQueryCondition alloc] init];
    [condition setIsQuerySub:YES];
    [condition setOffset:0];
    [condition setLimit:50];
    if (keyword.length == 0) {
        keyword = @"";
    }
    
    __block UVQueryResourceParam *param = [[UVQueryResourceParam alloc] init];
    [param setOrgCode:@""];
    [param setMatchString:keyword];
    [param setQueryCondition:condition];
    
    __block NSArray *resList = nil;
    [self.request execRequest:^{
        resList = [self.service queryResource:param];
        
    } finish:^(UVError *error) {
        if (error == nil) {
            completion(resList, nil);
        } else {
            NSError *err = [NSError errorWithDomain:@"tvMgr.QueryResource" code:1 userInfo:@{@"desc":self.service}];
            NSLog(@"--err---%@",err);
            completion(nil, err);
           
        }
    }
     ];
}

@end
