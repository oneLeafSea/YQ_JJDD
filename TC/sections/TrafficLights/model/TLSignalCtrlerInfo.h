//
//  TLSignalCtrlerInfo.h
//  TC
//
//  Created by 郭志伟 on 15/11/17.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLPoint.h"

extern NSString *kSignalCtrlerStatusNormal;
extern NSString *kSignalCtrlerStatusOffline;
extern NSString *kSignalCtrlerStatusWarn;
extern NSString *kSignalCtrlerStatusBroken;

@interface TLSignalCtrlerInfo : NSObject <NSCopying>

- (instancetype)initWithDict:(NSDictionary *)dict;

@property(nonatomic, copy) NSString *crossId;
@property(nonatomic, copy) NSString *ctrlerId;
@property(nonatomic, copy) NSString *ctrlerNam;
@property(nonatomic, copy) NSString *desc;
@property(nonatomic, copy) NSString *deviceTp;
@property(nonatomic, copy) NSString *software;
@property(nonatomic, copy) NSString *status;
@property(nonatomic, copy) NSString *uid;
@property(nonatomic, readonly) TLPoint tlPoint;
@property(nonatomic, copy) NSString *wkt;
@property(nonatomic, copy) NSString *junctionId;
@property(nonatomic, copy) NSString *installPhase;
@property(nonatomic, copy) NSString *roadNo;
@property(nonatomic, copy) NSString *regionId;


- (NSString *)getSCImageByStatus;


- (void)getCrossRunInfoWithToken:(NSString *)token
                        Completion:(void(^)(NSString *jsonResult, BOOL finished))completion;

- (void)setCrossRunStageWithLockTime:(NSString *)lockTime
                           userName:(NSString *)username
                         manTrigger:(BOOL)manTrigger
                             stageSn:(NSString *)stageSn
                              token:(NSString *)token
                         completion:(void(^)(BOOL finished))completion;

- (void)getLastCrossSchemeWithToken:(NSString *)token
                           completion:(void(^)(NSString *jsonResult, BOOL finished))completion;

- (BOOL)canSelected;

@end
