//
//  LoginMgr.h
//  TC
//
//  Created by 郭志伟 on 15/11/6.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TC-swift.h"

@interface LoginMgr : NSObject

- (void)loginWithCompletion:(void(^)(BOOL finished, NSError *error))completion;

- (void)loginWithUserName:(NSString *)username
                 password:(NSString *)password
               completion:(void(^)(BOOL finished, NSError *error))completion;


@property(nonatomic, strong)   RTSession *session;

@property(nonatomic, copy) NSString *username;
@property(nonatomic, copy) NSString *password;
@property(nonatomic, copy) NSString *ip;
@property(nonatomic, assign) UInt32 port;

@end
