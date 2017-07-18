//
//  TCSignalCtrllerOperator.m
//  TC
//
//  Created by 郭志伟 on 15/11/19.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TCSignalCtrllerOperator.h"
#import "TLAPI.h"
#import "TLCrossScheme.h"
#import "JSONKit.h"
#import "TLSignalCtrlerInfo.h"
#import "AppDelegate.h"

#define kMaxLeftTime 10

@interface TCSignalCtrllerStateInfo: NSObject

@property(nonatomic, copy) NSString *ctrllerId;
@property(nonatomic, copy) NSString *crossId;
@property(nonatomic, copy) NSString *sn;
@property(nonatomic, assign) NSInteger lifeTime;

@end

@implementation TCSignalCtrllerStateInfo


@end


#pragma mark - TCSignalCtrllerOperator
@interface TCSignalCtrllerOperator()

@property(nonatomic, assign) NSUInteger lockTime;
@property(nonatomic, strong) NSMutableArray *scStateInfoArray;
@property(nonatomic, strong) NSString *strLockTime;


@property(nonatomic, strong) NSTimer *timer;

//@property(nonatomic, strong) NSArray *snArray;
@property(nonatomic, strong) TLCrossScheme *crossScheme;

@end



@implementation TCSignalCtrllerOperator

- (instancetype)initWithUserName:(NSString *)userName
                        lockTime:(NSUInteger)lockTime {
    if (self = [super init]) {
        _userName = [userName copy];
        self.lockTime = lockTime;
//        self.snArray = @[@"01", @"02", @"03", @"04"];
        self.scStateInfoArray = [[NSMutableArray alloc] initWithCapacity:32];
    }
    return self;
}

- (void)addSignalCtrllerWithCtrllerId:(NSString *)ctrllerId
                              crossId:(NSString *)crossId
                                   sn:(NSString *)sn
                           completion:(void(^)(BOOL finished))completion {
    NSAssert(ctrllerId != nil, @"信号机ID为空。");
    NSAssert(crossId != nil, @"路口ID为空。");
    NSAssert(sn != nil, @"sn为空。");
    
    __block TLSignalCtrlerInfo *scInfo = [APP_DELEGATE.tlMgr getSCInfoByCrossId:crossId];
    [scInfo getLastCrossSchemeWithToken:[TLAPI loginToken] completion:^(NSString *jsonResult, BOOL finished) {
        NSArray *arr = [jsonResult objectFromJSONString];
        self.crossScheme = [[TLCrossScheme alloc] initWitArray:arr];
        if (self.crossScheme) {
            __block NSDate *start = [NSDate date];
            [scInfo setCrossRunStageWithLockTime:self.strLockTime userName:self.userName manTrigger:YES stageSn:sn token:[TLAPI loginToken] completion:^(BOOL finished) {
                if (finished) {
                    TCSignalCtrllerStateInfo *stateInfo = [[TCSignalCtrllerStateInfo alloc] init];
                    stateInfo.ctrllerId = ctrllerId;
                    stateInfo.crossId = crossId;
                    NSTimeInterval timeInterval = [start timeIntervalSinceNow];
                    stateInfo.lifeTime = self.lockTime - timeInterval;
                    stateInfo.sn = sn;
                    [self.scStateInfoArray addObject:stateInfo];
                    if (!self.isRunning) {
                        [self start];
                    }
                }
                completion(finished);
            }];
        } else {
            completion(NO);
        }
    }];
    
    
}

- (void)removeSignalCtrllerWithCtrllerId:(NSString *)ctrllerId
                              completion:(void(^)(BOOL finished))completion_ {
    __block NSInteger index = NSNotFound;
    
    [self.scStateInfoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TCSignalCtrllerStateInfo *stateInfo = obj;
        if ([stateInfo.ctrllerId isEqualToString:ctrllerId]) {
            index = idx;
            *stop = YES;
        }
    }];
    
    if (index != NSNotFound) {
        TCSignalCtrllerStateInfo *stateInfo = [self.scStateInfoArray objectAtIndex:index];
        TLSignalCtrlerInfo *scInfo = [APP_DELEGATE.tlMgr getSCInfoByCrossId:stateInfo.crossId];
        [scInfo setCrossRunStageWithLockTime:@"0" userName:self.userName manTrigger:YES stageSn:stateInfo.sn token:[TLAPI loginToken] completion:^(BOOL finished) {
            if (finished) {
                [self.scStateInfoArray removeObjectAtIndex:index];
                if (self.scStateInfoArray.count == 0) {
                    [self stop];
                }
            }
            completion_(finished);
        }];
        
    }
}

- (void)stepSignalCtrllerWithCtrllerId:(NSString *)ctrllerId
                            completion:(void(^)(BOOL finished))completion_ {
    __block NSInteger index = NSNotFound;
    [self.scStateInfoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TCSignalCtrllerStateInfo *stateInfo = obj;
        if ([stateInfo.ctrllerId isEqualToString:ctrllerId]) {
            index = idx;
            *stop = YES;
        }
    }];
    
    if (index != NSNotFound) {
        TCSignalCtrllerStateInfo *stateInfo = [self.scStateInfoArray objectAtIndex:index];
        __block NSDate *start = [NSDate date];
        TLSignalCtrlerInfo *scInfo = [APP_DELEGATE.tlMgr getSCInfoByCrossId:stateInfo.crossId];
        [scInfo setCrossRunStageWithLockTime:@"0" userName:self.userName manTrigger:YES stageSn:[self getNextSn:stateInfo.sn] token:[TLAPI loginToken] completion:^(BOOL finished) {
            if (finished) {
                stateInfo.sn = [self getNextSn:stateInfo.sn];
                NSTimeInterval timeInterval = [start timeIntervalSinceNow];
                stateInfo.lifeTime = self.lockTime - timeInterval;
            }
            completion_(finished);
        }];
    }
}

- (NSString *)getNextSn:(NSString *)curSn {
    NSString *nextSn = [self.crossScheme getNextSnByPreSn:curSn];
    NSLog(@"切换:curSn: %@, nextSn: %@", curSn, nextSn);
    return nextSn;
}

- (BOOL)isSignalCtrllerControlling:(NSString *)ctrllerId {
    __block BOOL found = NO;
    [self.scStateInfoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TCSignalCtrllerStateInfo *stateInfo = obj;
        if ([stateInfo.ctrllerId isEqualToString:ctrllerId]) {
            found = YES;
            *stop = YES;
        }
    }];
    return found;
}

#pragma mark - private method

- (void)start {
    _isRunning = YES;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeout) userInfo:nil repeats:YES];
}

- (void)stop {
    [self.timer invalidate];
    _isRunning = NO;
}


#pragma mark - getter
- (NSString *)strLockTime {
    if (_strLockTime == nil) {
        _strLockTime = [NSString stringWithFormat:@"%lx", (unsigned long)self.lockTime];
    }
    return _strLockTime;
}


#pragma mark - action
- (void)timeout {
    [self.scStateInfoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TCSignalCtrllerStateInfo *stateInfo = obj;
        TLSignalCtrlerInfo *scInfo = [APP_DELEGATE.tlMgr getSCInfoByCrossId:stateInfo.crossId];
        [scInfo setCrossRunStageWithLockTime:self.strLockTime userName:self.userName manTrigger:NO stageSn:stateInfo.sn token:[TLAPI loginToken] completion:^(BOOL finished) {
        }];
    }];
}



@end
