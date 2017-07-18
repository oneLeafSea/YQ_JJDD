//
//  TLMgr.m
//  TC
//
//  Created by 郭志伟 on 15/11/17.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TLMgr.h"
#import "TLAPI.h"
#import "JSONKit.h"
#import "LogLevel.h"
#import "TLSiemensSignalCtrlerInfo.h"
#import "TLDWSignalCtrlerInfo.h"


@interface TLMgr()

@property(nonatomic, strong) NSMutableArray *mutableSignaleCtrlerInfos;
@property(nonatomic, strong) NSMutableArray *mutableElecPoliceInfos;
@property(nonatomic, strong) NSMutableArray *mutableHighCamInfos;
@property(nonatomic, strong) NSMutableArray *mutableRoadCamInfos;
@property(nonatomic, strong) NSMutableArray *mutableSearchData;

@property(nonatomic, strong) NSMutableDictionary *scDict;
@property(nonatomic, strong) NSMutableDictionary *epDict;
@property(nonatomic, strong) NSMutableDictionary *hcDict;
@property(nonatomic, strong) NSMutableDictionary *rcDict;

@property(nonatomic, strong) NSTimer *refreshTimer;
@end

@implementation TLMgr

- (instancetype)init {
    if (self = [super init]) {
        self.scDict = [[NSMutableDictionary alloc] init];
        self.epDict = [[NSMutableDictionary alloc] init];
        self.hcDict = [[NSMutableDictionary alloc] init];
        self.rcDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (void)startRefresh {
    DDLogInfo(@"开启刷新");
    if (self.refreshTimer) {
        [self.refreshTimer invalidate];
    }
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(timeout) userInfo:nil repeats:YES];
}

- (void)stopRefresh {
    [self.refreshTimer invalidate];
    self.refreshTimer = nil;
}

- (void)timeout {
    DDLogInfo(@"开始更新信号机和探头信息.");
    [TLAPI getAllSignalCtrlWithToken:[TLAPI loginToken] Completion:^(NSString *jsonResult, BOOL finished) {
        if (finished) {
            __block BOOL isDirty = NO;
            NSArray *array = [jsonResult objectFromJSONString];
            NSMutableDictionary *changedScInfos = [[NSMutableDictionary alloc] init];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dict = obj;
                TLSignalCtrlerInfo *scInfo = [[TLSignalCtrlerInfo alloc] initWithDict:dict];
                TLSignalCtrlerInfo *sc = [self.scDict objectForKey:scInfo.ctrlerId];
                sc.status = scInfo.status;
                if (![sc.status isEqualToString:scInfo.status]) {
                    sc.status = scInfo.status;
                    [changedScInfos setObject:sc forKey:sc.ctrlerId];
                    isDirty = YES;
                }
            }];
            [TLAPI getDWSignalCtrlStWithToken:[TLAPI loginToken] completion:^(NSString *jsonResult, BOOL finished) {
                if (finished) {
                    DDLogInfo(@"完成更新信号机信息。");
                    NSArray *array = [jsonResult objectFromJSONString];
                    
                    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSDictionary *dict = obj;
                        NSString *crossCode = [dict objectForKey:@"crossCode"];
                        NSArray *faults = [dict objectForKey:@"faults"];
                        __block BOOL isOnline = YES;
                        TLSignalCtrlerInfo *scInfo = [self getSCInfoByCtrlerRoadNo:crossCode];
                        if (scInfo == nil) {
                            return;
                        }
                        [faults enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            NSString *st = obj;
                            if ([st isEqualToString:@"0"]) {
                                DDLogInfo(@"%@, %@", crossCode, faults);
                                isOnline = NO;
                                *stop = YES;
                                return;
                            }
                        }];
                        NSString *st = isOnline ? kSignalCtrlerStatusNormal : kSignalCtrlerStatusOffline;
                        if (![st isEqualToString:scInfo.status]) {
                            isDirty = YES;
                        }
                        if (isDirty && [self.delegate respondsToSelector:@selector(TLMgr:signnalInfoDidUpdate:)]) {
                            [self.delegate TLMgr:self signnalInfoDidUpdate:changedScInfos];
                        }
                    }];
                }
            }];

        }
    }];
    
    [TLAPI getAllVideoHighCamWithToken:[TLAPI loginToken] completion:^(NSString *jsonResult, BOOL finished) {
        if (finished) {
            DDLogInfo(@"完成更新高空探头信息。");
            __block BOOL isDirty = NO;
            NSArray *array = [jsonResult objectFromJSONString];
            if ([array isKindOfClass:[NSArray class]]) {
                NSMutableDictionary *changedHcInfos = [[NSMutableDictionary alloc] init];
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary *dict = obj;
                    TVHighCamInfo *hci = [[TVHighCamInfo alloc] initWithDict:dict];
                    TVHighCamInfo *hc = [self.hcDict objectForKey:hci.deviceId];
                    if (![hc.status isEqualToString:hci.status]) {
                        hc.status = hci.status;
                        [changedHcInfos setObject:hc forKey:hc.deviceId];
                        isDirty = YES;
                    }
                }];
                if (isDirty && [self.delegate respondsToSelector:@selector(TLMgr:highCamInfoDidUpdate:)]) {
                    [self.delegate TLMgr:self highCamInfoDidUpdate:changedHcInfos];
                }
            }
        }
    }];
    
    [TLAPI getAllVideoRoadCamWithToken:[TLAPI loginToken] completion:^(NSString *jsonResult, BOOL finished) {
        if (finished) {
            DDLogInfo(@"完成更新路面探头信息。");
            __block BOOL isDirty = NO;
            NSArray *array = [jsonResult objectFromJSONString];
            if ([array isKindOfClass:[NSArray class]]) {
                NSMutableDictionary *changedRcInfos = [[NSMutableDictionary alloc] init];
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary *dict = obj;
                    TVRoadCamInfo *rci = [[TVRoadCamInfo alloc] initWithDict:dict];
                    TVRoadCamInfo *rc = [self.rcDict objectForKey:rci.deviceId];
                    if (![rc.status isEqualToString:rci.status]) {
                        rc.status = rci.status;
                        [changedRcInfos setObject:rc forKey:rc.deviceId];
                        isDirty = YES;
                    }
                }];
                if (isDirty && [self.delegate respondsToSelector:@selector(TLMgr:roadCamInfoDidUpdate:)]) {
                    [self.delegate TLMgr:self roadCamInfoDidUpdate:changedRcInfos];
                }
            }
        }
    }];
    
    [TLAPI getAllElecPoliceWithToken:[TLAPI loginToken] completion:^(NSString *jsonResult, BOOL finished) {
        if (finished) {
            DDLogInfo(@"完成更新电警探头信息。");
            __block BOOL isDirty = NO;
            NSArray *array = [jsonResult objectFromJSONString];
            if ([array isKindOfClass:[NSArray class]]) {
                NSMutableDictionary *changedEpInfos = [[NSMutableDictionary alloc] init];
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary *dict = obj;
                    TVElecPoliceInfo *epi = [[TVElecPoliceInfo alloc] initWithDict:dict];
                    TVElecPoliceInfo *ep = [self.epDict objectForKey:epi.deviceId];
                    if (![ep.status isEqualToString:epi.status]) {
                        ep.status = epi.status;
                        [changedEpInfos setObject:ep forKey:ep.deviceId];
                        isDirty = YES;
                    }
                }];
                if (isDirty && [self.delegate respondsToSelector:@selector(TLMgr:epCamInfoDidUpdate:)]) {
                    [self.delegate TLMgr:self epCamInfoDidUpdate:changedEpInfos];
                }
            }
        }
    }];
}

- (void)buildSCInfos:(void(^)(BOOL finished, NSError *error))completion {
    
    __block BOOL signalResult = YES;
    __block NSError *err = nil;
    self.mutableSignaleCtrlerInfos = [[NSMutableArray alloc] initWithCapacity:128];
    self.mutableHighCamInfos = [[NSMutableArray alloc] initWithCapacity:256];
    self.mutableRoadCamInfos = [[NSMutableArray alloc] initWithCapacity:256];
    self.mutableElecPoliceInfos = [[NSMutableArray alloc] initWithCapacity:256];
    dispatch_group_t waitGroup = dispatch_group_create();
    dispatch_group_enter(waitGroup);

    [TLAPI getAllSignalCtrlWithToken:[TLAPI loginToken] Completion:^(NSString *jsonResult, BOOL finished) {
        if (finished) {
            NSArray *array = [jsonResult objectFromJSONString];
            if ([array isKindOfClass:[NSDictionary class]]) {
                completion(NO, nil);
                return;
            }
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dict = obj;
                TLSignalCtrlerInfo *scInfo = nil;
                if ([dict[@"installPhase"] isEqualToString:@"1"]) {
                    scInfo = [[TLDWSignalCtrlerInfo alloc] initWithDict:dict];
                    scInfo.status = kSignalCtrlerStatusNormal;
                    if ([scInfo.roadNo length] == 0) {
                        return;
                    }
                } else {
                    scInfo = [[TLSiemensSignalCtrlerInfo alloc] initWithDict:dict];
                }
                if (scInfo) {
                    [self.mutableSignaleCtrlerInfos addObject:scInfo];
                    [self.scDict setObject:scInfo forKey:scInfo.ctrlerId];
                }
            }];
        } else {
            signalResult = NO;
            err = [NSError errorWithDomain:@"TLMgr.GetALLCtrler" code:1 userInfo:@{@"desc":@"获取信号机信息错误！"}];
        }
        
        [TLAPI getDWSignalCtrlStWithToken:[TLAPI loginToken] completion:^(NSString *jsonResult, BOOL finished) {
            if (finished) {
                NSArray *array = [jsonResult objectFromJSONString];
                
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary *dict = obj;
                    NSString *crossCode = [dict objectForKey:@"crossCode"];
                    NSArray *faults = [dict objectForKey:@"faults"];
                    __block BOOL isOnline = YES;
                    TLSignalCtrlerInfo *scInfo = [self getSCInfoByCtrlerRoadNo:crossCode];
                    if (scInfo == nil) {
                        return;
                    } else {
                        DDLogInfo(@"%@", scInfo.ctrlerNam);
                    }
                    [faults enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSString *st = obj;
                        if ([st isEqualToString:@"0"]) {
                            DDLogInfo(@"%@, %@", crossCode, faults);
                            isOnline = NO;
                            *stop = YES;
                            return;
                        }
                    }];
                    scInfo.status = isOnline ? kSignalCtrlerStatusNormal : kSignalCtrlerStatusOffline;
                }];
            }
            dispatch_group_leave(waitGroup);
        }];
    }];
    
    __block NSArray *juctionArray = nil;
    __block BOOL junctionResult = YES;
    dispatch_group_enter(waitGroup);
    [TLAPI getAllSitracsJunctionsWithToken:[TLAPI loginToken] Completion:^(NSString *jsonResult, BOOL finished) {
        if (finished) {
            juctionArray = [jsonResult objectFromJSONString];
        } else {
            junctionResult = NO;
            err = [NSError errorWithDomain:@"TLMgr.GetAllSitracsJunctions" code:1 userInfo:@{@"desc":@"获取JunctionID错误！"}];
        }
        
        dispatch_group_leave(waitGroup);
    }];
    
    dispatch_group_notify(waitGroup, dispatch_get_main_queue(), ^{
        if (signalResult && junctionResult) {
            if ([juctionArray isKindOfClass:[NSArray class]]) {
                [juctionArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary *dict = obj;
                    NSDictionary *crossRangDict = [dict objectForKey:@"crossRang"];
                    if (crossRangDict == nil || [crossRangDict isKindOfClass:[NSNull class]] || crossRangDict.count == 0) {
                        return;
                    }
                    NSString *roadCrossId = [crossRangDict objectForKey:@"roadCrossId"];
                    NSString *juctionId = [dict objectForKey:@"id"];
                    
                    [self.mutableSignaleCtrlerInfos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        TLSignalCtrlerInfo *scInfo = obj;
                        if ([scInfo.crossId isEqualToString:roadCrossId]) {
                            scInfo.junctionId = juctionId;
                        }
                    }];
                }];
                completion(YES, nil);
            } else {
                completion(NO, nil);
            }
            
        } else {
            completion(NO, err);
        }
        
    });
}

- (TLSignalCtrlerInfo *)getSCInfoByCtrlerRoadNo:(NSString *)roadNo {
        __block TLSignalCtrlerInfo *res = nil;
        [self.mutableSignaleCtrlerInfos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TLSignalCtrlerInfo *scInfo = obj;
            if ([scInfo.roadNo isEqualToString:roadNo]) {
                res = scInfo;
                *stop = YES;
            }
        }];
        return res;
}



- (TLSignalCtrlerInfo *)getSCInfoByCtrlerId:(NSString *)ctrlerId {
    return [self.scDict objectForKey:ctrlerId];
}

- (TLSignalCtrlerInfo *)getSCInfoByCrossId:(NSString *)crossId {
    __block TLSignalCtrlerInfo *res = nil;
    [self.mutableSignaleCtrlerInfos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TLSignalCtrlerInfo *scInfo = obj;
        if ([scInfo.crossId isEqualToString:crossId]) {
            res = scInfo;
            *stop = YES;
        }
    }];
    return res;
}

- (TVHighCamInfo *)getHcInfoByDeviceId:(NSString *)deviceId {
    return [self.hcDict objectForKey:deviceId];
}

- (TVElecPoliceInfo *)getElecPoliceInfoByDeviceId:(NSString *)deviceId {
    return [self.epDict objectForKey:deviceId];
}

- (TVRoadCamInfo *)getRoadCamInfoByDeviceId:(NSString *)deviceId {
    return [self.rcDict objectForKey:deviceId];
}


- (void)buildHighCamInfosWithToken:(NSString *)token completion:(void(^)(BOOL finished, NSError *error))completion_ {
    [TLAPI getAllVideoHighCamWithToken:token completion:^(NSString *jsonResult, BOOL finished) {
        NSArray *array = [jsonResult objectFromJSONString];
        if ([array isKindOfClass:[NSArray class]]) {
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dict = obj;
                TVHighCamInfo *hci = [[TVHighCamInfo alloc] initWithDict:dict];
                if (hci) {
                    [self.mutableHighCamInfos addObject:hci];
                    [self.hcDict setObject:hci forKey:hci.deviceId];
                } else {
                    NSLog(@"WARN: 解析高空数据时错误！");
                }
            }];
            completion_(YES, nil);
        } else {
            NSError *err = [NSError errorWithDomain:@"TLMgr.buildHighCamInfos" code:2 userInfo:@{@"desc":@"获取的高空探头数据不是array类型"}];
            completion_(NO, err);
        }
    }];
}


- (void)buildRoadCamInfosWithToken:(NSString *)token completion:(void(^)(BOOL finished, NSError *error))completion_ {
    [TLAPI getAllVideoRoadCamWithToken:token completion:^(NSString *jsonResult, BOOL finished) {
        NSArray *array = [jsonResult objectFromJSONString];
        if ([array isKindOfClass:[NSArray class]]) {
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dict = obj;
                TVRoadCamInfo *rci = [[TVRoadCamInfo alloc] initWithDict:dict];
                if (rci) {
                    [self.mutableRoadCamInfos addObject:rci];
                    [self.rcDict setObject:rci forKey:rci.deviceId];
                } else {
                    NSLog(@"WARN: 解析路口数据时错误！");
                }
            }];
            completion_(YES, nil);
        } else {
            
            NSError *err = [NSError errorWithDomain:@"TLMgr.buildHighCamInfos" code:2 userInfo:@{@"desc":@"获取的路口探头数据不是array类型"}];
            completion_(NO, err);
        }
    }];
}

- (void)buildElecPoliceInfosWithToken:(NSString *)token completion:(void(^)(BOOL finished, NSError *error))completion_ {
    [TLAPI getAllElecPoliceWithToken:token completion:^(NSString *jsonResult, BOOL finished) {
        NSArray *array = [jsonResult objectFromJSONString];
        if ([array isKindOfClass:[NSArray class]]) {
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dict = obj;
                TVElecPoliceInfo *epi = [[TVElecPoliceInfo alloc] initWithDict:dict];
                if (epi) {
                    [self.mutableElecPoliceInfos addObject:epi];
                    [self.epDict setObject:epi forKey:epi.deviceId];
                } else {
                    NSLog(@"WARN: 解析电子警察数据时错误！");
                }
            }];
            completion_(YES, nil);
        } else {
            NSError *err = [NSError errorWithDomain:@"TLMgr.buildHighCamInfos" code:2 userInfo:@{@"desc":@"获取电子警察数据不是array类型"}];
            completion_(NO, err);
        }
    }];
}


#pragma mark - getter

- (NSArray *)signaleCtrlerInfos {
    return self.mutableSignaleCtrlerInfos;
}

- (NSArray *)elecPoliceInfos {
    return self.mutableElecPoliceInfos;
}

- (NSArray *)highCamInfos {
    return self.mutableHighCamInfos;
}

- (NSArray *)roadCamInfos {
    return self.mutableRoadCamInfos;
}

- (NSArray *)searchData {
    if (self.mutableSearchData == nil) {
        self.mutableSearchData = [[NSMutableArray alloc] initWithCapacity:512];
        [self.mutableHighCamInfos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TVHighCamInfo *hci = obj;
            NSDictionary *dict = @{@"DisplayText":hci.deviceNam, @"DisplaySubText":@"[高空云台]", @"data":hci};
            [self.mutableSearchData addObject:dict];
        }];
        
        [self.mutableElecPoliceInfos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TVElecPoliceInfo *epi = obj;
            NSDictionary *dict = @{@"DisplayText":epi.deviceNam, @"DisplaySubText":@"[电子警察]", @"data":epi};
            [self.mutableSearchData addObject:dict];
        }];
        
        [self.mutableRoadCamInfos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TVRoadCamInfo *rci = obj;
            NSDictionary *dict = @{@"DisplayText":rci.deviceNam, @"DisplaySubText":@"[路口云台]", @"data":rci};
            [self.mutableSearchData addObject:dict];
        }];
        
        [self.mutableSignaleCtrlerInfos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TLSignalCtrlerInfo *sci = obj;
            NSDictionary *dict = @{@"DisplayText":sci.ctrlerNam, @"DisplaySubText":@"[信号机]", @"data":sci};
            [self.mutableSearchData addObject:dict];
        }];
    }
    
    return self.mutableSearchData;
}


@end
