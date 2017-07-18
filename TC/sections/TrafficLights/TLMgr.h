//
//  TLMgr.h
//  TC
//
//  Created by 郭志伟 on 15/11/17.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLSignalCtrlerInfo.h"
#import "TVElecPoliceInfo.h"
#import "TVHighCamInfo.h"
#import "TVRoadCamInfo.h"

@protocol TLMgrDelegate;

@interface TLMgr : NSObject


- (void)buildSCInfos:(void(^)(BOOL finished, NSError *error))completion;

- (void)buildHighCamInfosWithToken:(NSString *)token completion:(void(^)(BOOL finished, NSError *error))completion;
- (void)buildRoadCamInfosWithToken:(NSString *)token completion:(void(^)(BOOL finished, NSError *error))completion;
- (void)buildElecPoliceInfosWithToken:(NSString *)token completion:(void(^)(BOOL finished, NSError *error))completion;

- (void)startRefresh;
- (void)stopRefresh;

@property(nonatomic, strong, readonly)NSArray *signaleCtrlerInfos;
@property(nonatomic, strong, readonly)NSArray *elecPoliceInfos;
@property(nonatomic, strong, readonly)NSArray *highCamInfos;
@property(nonatomic, strong, readonly)NSArray *roadCamInfos;

@property(nonatomic, strong, readonly)NSArray *searchData;

@property(nonatomic, weak) id<TLMgrDelegate> delegate;

- (TLSignalCtrlerInfo *)getSCInfoByCtrlerId:(NSString *)ctrlerId;
- (TLSignalCtrlerInfo *)getSCInfoByCrossId:(NSString *)crossId;
- (TLSignalCtrlerInfo *)getSCInfoByCtrlerRoadNo:(NSString *)roadNo;
- (TVHighCamInfo *)getHcInfoByDeviceId:(NSString *)deviceId;
- (TVElecPoliceInfo *)getElecPoliceInfoByDeviceId:(NSString *)deviceId;
- (TVRoadCamInfo *)getRoadCamInfoByDeviceId:(NSString *)deviceId;

@end

@protocol TLMgrDelegate <NSObject>

- (void)TLMgr:(TLMgr *)tlMgr signnalInfoDidUpdate:(NSDictionary *)signaleCtrlerInfos;
- (void)TLMgr:(TLMgr *)tlMgr highCamInfoDidUpdate:(NSDictionary *)highCamInfos;
- (void)TLMgr:(TLMgr *)tlMgr roadCamInfoDidUpdate:(NSDictionary *)roadCamInfos;
- (void)TLMgr:(TLMgr *)tlMgr epCamInfoDidUpdate:(NSDictionary *)epCamInfos;

@end

