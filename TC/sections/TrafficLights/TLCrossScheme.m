//
//  TLCrossScheme.m
//  TC
//
//  Created by 郭志伟 on 15/11/25.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TLCrossScheme.h"
#import "LogLevel.h"
#import "JSONKit.h"

@interface TLCrossScheme()

@property(nonatomic, strong) NSMutableArray *mutableStageInfoArray;

@end

@implementation TLCrossScheme

- (instancetype)initWitArray:(NSArray *)array {
    if (self = [super init]) {
        self.mutableStageInfoArray = [[NSMutableArray alloc] initWithCapacity:8];
        if (![self parseArray:array]) {
            self = nil;
        }
    }
    return self;
}


//[{"stageSeconds":"6","stageSn":"3"},{"stageSeconds":"6","stageSn":"4"},{"stageSeconds":"10","stageSn":"1"},{"stageSeconds":"6","stageSn":"2"}]

- (BOOL)parseArray: (NSArray *)array {
    __block BOOL ret = YES;
    if ([array isKindOfClass:[NSArray class]]) {
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = obj;
            TLStageInfo *si = [[TLStageInfo alloc] initWithDict:dict];
            if (si == nil) {
                ret = NO;
                [self.mutableStageInfoArray removeAllObjects];
                *stop = YES;
            } else {
                [self.mutableStageInfoArray addObject:si];
            }
        }];
    }
    return ret;
}

- (NSArray *)stageInfoArray {
    return self.mutableStageInfoArray;
}

- (NSString *)getSecondsBySn:(NSString *)sn {
    __block NSString *ret = nil;
    [self.mutableStageInfoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TLStageInfo *si = obj;
        if ([si.sn isEqualToString:sn] || [si.sn intValue] == [sn intValue]) {
            ret = [si.seconds copy];
        }
        
    }];
    return ret;
}

- (NSString *)getSecondsByIntSn:(NSInteger)sn {
    __block NSString *ret = nil;
    [self.mutableStageInfoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TLStageInfo *si = obj;
        if ([si.sn integerValue] == sn) {
            ret = [si.seconds copy];
        }
        
    }];
    return ret;
}

- (NSString *)getNextSnByPreSn:(NSString *)preSn {
    __block NSString *sn = nil;
    __block NSInteger index = 0;
    __block BOOL found = NO;
    [self.mutableStageInfoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TLStageInfo *si = obj;
        if ([si.sn isEqualToString:preSn] || [si.sn intValue] == [preSn intValue]) {
            index = idx;
            *stop = YES;
            found = YES;
        }
    }];
    if (found == YES) {
        TLStageInfo *si = self.mutableStageInfoArray[(index + 1) % self.mutableStageInfoArray.count];
        sn = [NSString stringWithFormat:@"%02d", [si.sn intValue]];//si.sn;
    }
    return sn;
}

+ (NSString *)getSnNameBySn:(NSInteger)sn {
 
    NSArray *snArray = @[
                             @"东西直行",
                             @"东西左转",
                             @"南北直行",
                             @"南北左转",
                             @"东西放行",
                             @"南北放行",
                             @"东放行",
                             @"西放行",
                             @"南放行",
                             @"北放行",
                             @"东西放行+北右",
                             @"南北放行+西右"
                             ];
     NSString *name = nil;
        if (snArray.count >= sn && sn > 0) {
            name = snArray[sn-1];
        }
    
    DDLogInfo(@"name: %@ sn: %ld", name, (long)sn);
    
    
    return name;
    
}

@end
