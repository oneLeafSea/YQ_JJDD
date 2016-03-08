//
//  LoginMgr.m
//  TC
//
//  Created by 郭志伟 on 15/11/6.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "LoginMgr.h"

@interface LoginMgr() <RTSessionDelegate>

@property(nonatomic, strong) void(^completion)(BOOL finished, NSError *error);

@end

@implementation LoginMgr

- (instancetype)init {
    if (self = [super init]) {
        self.ip = @"10.22.1.47";
        self.port = 8000;
    }
    return self;
}

- (RTSession *)session {
    if (_session == nil) {
        _session = [[RTSession alloc] initWithIp:self.ip port:self.port];
        _session.delegate = self;
    }
    return _session;
}


- (void)loginWithCompletion:(void(^)(BOOL finished, NSError *error))completion {
    [self loginWithUserName:self.username password:self.password completion:completion];
}

- (void)loginWithUserName:(NSString *)username
                 password:(NSString *)password
               completion:(void(^)(BOOL finished, NSError *error))completion {
    self.username = username;
    self.password = password;
    NSAssert(self.username.length != 0, @"用户名不能为空！");
    NSAssert(self.password.length != 0, @"密码不能为空");
    [self.session connect];
}

- (NSError *)genErrorWithCode:(NSInteger)code errDesc:(NSString *)errDesc {
    NSError *err = [NSError errorWithDomain:@"TC.Login" code:code userInfo:@{@"desc":errDesc}];
    return err;
}

#pragma mark - RTSessionDelegate

- (void)sessionDidConnect:(RTSession *)session {
    NSLog(@"链接成功");
    
}

- (void)sessionDidDisconnect:(RTSession *)session error:(NSError *)error {
    
}

- (void)sessionDidReceiveData:(RTSession *)session data:(NSData *)data {
    
}

@end
