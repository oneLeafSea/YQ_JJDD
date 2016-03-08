//
//  TLSiemensSignalCtrlerInfo.m
//  TC
//
//  Created by 郭志伟 on 16/2/18.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import "TLSiemensSignalCtrlerInfo.h"
#import "TLAPI.h"

@implementation TLSiemensSignalCtrlerInfo

- (void)getCrossRunInfoWithToken:(NSString *)token
                      Completion:(void(^)(NSString *jsonResult, BOOL finished))completion {
    [TLAPI getCrossRunInfoWithCrossId:self.crossId token:token Completion:^(NSString *jsonResult, BOOL finished) {
        completion(jsonResult, finished);
    }];
}

- (void)setCrossRunStageWithLockTime:(NSString *)lockTime
                            userName:(NSString *)username
                          manTrigger:(BOOL)manTrigger
                             stageSn:(NSString *)stageSn
                               token:(NSString *)token
                          completion:(void(^)(BOOL finished))completion {
    [TLAPI setCrossRunStageWithCrossId:self.crossId stageSn:stageSn lockTime:lockTime userName:username manTrigger:manTrigger token:token completion:^(BOOL finished) {
        completion(finished);
    }];
}

- (void)getLastCrossSchemeWithToken:(NSString *)token
                         completion:(void(^)(NSString *jsonResult, BOOL finished))completion {
    [TLAPI getLastCrossSchemeWithCrossId:self.crossId token:token completion:^(NSString *jsonResult, BOOL finished) {
        completion(jsonResult, finished);
    }];
}


@end
