//
//  TCSignalCtrllerUpdater.m
//  TC
//
//  Created by 郭志伟 on 15/11/19.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TCSignalCtrllerUpdater.h"
#import "TLAPI.h"
#import "JSONKit.h"
#import "LogLevel.h"
#import "TLSignalCtrlerInfo.h"
#import "AppDelegate.h"


@interface TCSignalCtrllerUpdater()

@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, strong) NSMutableSet *crossSet;
@property(nonatomic, strong) NSMutableDictionary *schemeDict;

@end

//[{"stageSeconds":"6","stageSn":"3"},{"stageSeconds":"6","stageSn":"4"},{"stageSeconds":"10","stageSn":"1"},{"stageSeconds":"6","stageSn":"2"}]

@implementation TCSignalCtrllerUpdater

- (instancetype)init {
    if (self = [super init]) {
        self.crossSet = [[NSMutableSet alloc] initWithCapacity:32];
        self.schemeDict = [[NSMutableDictionary alloc] initWithCapacity:32];
        _isRunning = NO;
    }
    return self;
}

- (void) start {
    NSLog(@"SCUpdate started");
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeout) userInfo:nil repeats:YES];
    _isRunning = YES;
}

- (void) stop {
    NSLog(@"SCUpdate stopped");
    [self.timer invalidate];
    _isRunning = NO;
}


- (void)timeout {
    [self.crossSet enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *crossId = obj;
        TLSignalCtrlerInfo *scInfo = [APP_DELEGATE.tlMgr getSCInfoByCrossId:crossId];
        [scInfo getCrossRunInfoWithToken:[TLAPI loginToken] Completion:^(NSString *jsonResult, BOOL finished) {
            if (finished) {
                if ([self.delegate respondsToSelector:@selector(TCSignalCtrllerUpdater:result:crossScheme:)]) {
                    NSArray *result = [jsonResult objectFromJSONString];
                    if ([result isKindOfClass:[NSArray class]]) {
                        [self.delegate TCSignalCtrllerUpdater:self result:result crossScheme:[self.schemeDict objectForKey:crossId]];
                    }
                    
                }
            }
        }];
    }];
}

- (void)removeAll {
    [self.crossSet removeAllObjects];
}

- (void)addScInfoWithCrossId:(NSString *)crossId
                  completion:(void(^)(BOOL finished))completion{
    TLSignalCtrlerInfo *scInfo = [APP_DELEGATE.tlMgr getSCInfoByCrossId:crossId];
    [scInfo getLastCrossSchemeWithToken:[TLAPI loginToken] completion:^(NSString *jsonResult, BOOL finished) {
        if (finished) {
            [self.crossSet addObject:crossId];
            NSArray *jsonArray = [jsonResult objectFromJSONString];
            TLCrossScheme *cs = [[TLCrossScheme alloc] initWitArray:jsonArray];
            if (cs) {
                [self.schemeDict setObject:cs forKey:crossId];
                completion(YES);
            } else {
                completion(NO);
            }
            
        } else {
            completion(NO);
        }
    }];
}

- (void)removeScInfoWithCrossId:(NSString *)crossId {
    [self.schemeDict removeObjectForKey:crossId];
    [self.crossSet removeObject:crossId];
}


@end
