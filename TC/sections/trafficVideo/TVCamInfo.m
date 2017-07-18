//
//  TVCamInfo.m
//  TC
//
//  Created by 郭志伟 on 15/11/23.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TVCamInfo.h"

NSString *kCamStatusNormal = @"0";
NSString *kCamStautsOffline = @"1";
NSString *kCamStatusWarn = @"2";
NSString *kCamStatusBroken = @"3";

@implementation TVCamInfo

- (BOOL)isSameCam:(TVCamInfo *)camInfo {
    if ([self isKindOfClass:[camInfo class]] && [self.deviceId isEqualToString:camInfo.deviceId]) {
        return YES;
    }
    return NO;
}

- (NSString *)getCamImagByStatus {
    return nil;
}

- (NSString *)selectedImgName {
    return nil;
}

- (BOOL)canSelect {
    if ([self.status isEqualToString:kCamStatusBroken] ||
        [self.status isEqualToString:kCamStautsOffline]) {
        return NO;
    }
    return YES;
}

@end
