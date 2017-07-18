//
//  TVMgr.h
//  TC
//
//  Created by 郭志伟 on 15/11/23.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AirIMOSIphoneSDK.h"
#import "UVRequest.h"

@interface TVMgr : NSObject

@property(nonatomic, strong) UVServiceManager *service;
@property(nonatomic, strong) UVRequest *request;

- (void)loginWithInView:(UIView *)view
             completion:(void(^)(BOOL finished, NSError *error))completion;

- (void)queryResourceWithKeyword:(NSString *)keyword completion:(void(^)(NSArray *resList, NSError *error))completion;

@end
