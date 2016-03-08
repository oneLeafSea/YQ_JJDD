//
//  TLDWSignalCtrlerInfo.m
//  TC
//
//  Created by 郭志伟 on 16/2/18.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import "TLDWSignalCtrlerInfo.h"
#import "TLAPI.h"
#import "JSONKit.h"
#import "AppDelegate.h"

@implementation TLDWSignalCtrlerInfo

- (void)getCrossRunInfoWithToken:(NSString *)token
                      Completion:(void(^)(NSString *jsonResult, BOOL finished))completion {
    [TLAPI getDWCrossRunInfoWithRoadNo:self.roadNo token:token Completion:^(NSString *jsonResult, BOOL finished) {
        if (finished) {
            NSDictionary *dict = [jsonResult objectFromJSONString];
            NSArray *arr = [self convertToSiemensRunInfo:dict];
            if (arr == nil) {
                completion(nil, NO);
                return;
            }
            
            NSError *err = nil;
            NSData *d = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&err];
            if (err != nil) {
                completion(nil, NO);
            }
            
            NSString *jsonStr = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
            
            completion(jsonStr, YES);
        } else {
            completion(nil, NO);
        }
    }];
}

/**
 *  转换成西门子的格式。
 */

- (NSArray *)convertToSiemensRunInfo:(NSDictionary *)dict {
    NSString *roadNo = [dict objectForKey:@"crossCode"];
    NSString *ctrlType = [dict objectForKey:@"ctrlType"];
    NSString *lockStage = [dict objectForKey:@"lockStage"];
    NSString *lockUser = [dict objectForKey:@"lockUser"];
    NSString *stageId = [dict objectForKey:@"stageId"];
    NSNumber *duration = [dict objectForKey:@"duration"];
    
    TLSignalCtrlerInfo * scInfo = [APP_DELEGATE.tlMgr getSCInfoByCtrlerRoadNo:roadNo];
    if (scInfo == nil) {
        NSLog(@"没有找到相应的信号机。");
        return nil;
    }
    
    NSString *crossId = scInfo.crossId;
    NSString *modelCode = @"0601";
    NSString *modelDesc = ctrlType;
    NSString *name = scInfo.ctrlerNam;
    NSDictionary *runStage = @{
                               @"crossId":crossId,
                               @"duration":duration,
                               @"sn":stageId,
                               };
    NSDictionary *inf = @{
                          @"crossId":scInfo.crossId,
                          @"lockStage":lockStage,
                          @"lockUser":lockUser,
                          @"modelCode":modelCode,
                          @"modelDesc":modelDesc,
                          @"name":name,
                          @"runStage": runStage,
                          };
    NSArray *arr = @[inf];
    return arr;
}


- (void)setCrossRunStageWithLockTime:(NSString *)lockTime
                            userName:(NSString *)username
                          manTrigger:(BOOL)manTrigger
                             stageSn:(NSString *)stageSn
                               token:(NSString *)token
                          completion:(void (^)(BOOL))completion_ {
    [TLAPI setDWCrossRunStageWithRoadNo:self.roadNo stageSn:stageSn lockTime:lockTime userName:username manTrigger:manTrigger token:token regionId:self.regionId ctrlerId:self.ctrlerId ctrlerName:self.ctrlerNam relCrossId:self.crossId completion:^(BOOL finished) {
        completion_(finished);
    }];
}

- (void)getLastCrossSchemeWithToken:(NSString *)token
                         completion:(void(^)(NSString *jsonResult, BOOL finished))completion {
    [TLAPI getDWLastCrossSchemeWithRoadNo:self.roadNo token:token completion:^(NSArray *array, BOOL finished) {
        if (finished) {
            __block NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dict = obj;
                NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
                [item setObject:dict[@"stageId"] forKey:@"stageSn"];
                [item setObject:dict[@"time"] forKey:@"stageSeconds"];
                [mutableArray addObject:item];
            }];
            NSError *err = nil;
            NSData *d = [NSJSONSerialization dataWithJSONObject:mutableArray options:NSJSONWritingPrettyPrinted error:&err];
            NSString *jsonStr = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
            completion(jsonStr, YES);
        } else {
            completion(nil, NO);
        }
    }];
}

@end
