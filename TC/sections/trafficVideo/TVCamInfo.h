//
//  TVCamInfo.h
//  TC
//
//  Created by 郭志伟 on 15/11/23.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *kCamStatusNormal;
extern NSString *kCamStautsOffline;
extern NSString *kCamStatusWarn;
extern NSString *kCamStatusBroken;

@interface TVCamInfo : NSObject

@property(nonatomic, copy) NSString *deviceId;
@property(nonatomic, copy) NSString *deviceNam;
@property(nonatomic, copy) NSString *tunnel;
@property(readonly, nonatomic) NSString *selectedImgName;
@property(nonatomic, copy) NSString *status;

- (BOOL)isSameCam:(TVCamInfo *)camInfo;

- (NSString *)getCamImagByStatus;

- (BOOL)canSelect;

@end
