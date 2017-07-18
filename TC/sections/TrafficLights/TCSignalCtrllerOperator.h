//
//  TCSignalCtrllerOperator.h
//  TC
//
//  Created by 郭志伟 on 15/11/19.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TCSignalCtrllerOperator : NSObject

- (instancetype)initWithUserName:(NSString *)userName
                        lockTime:(NSUInteger)lockTime;

-(instancetype) init __attribute__((unavailable("init not available")));

- (void)addSignalCtrllerWithCtrllerId:(NSString *)ctrllerId
                              crossId:(NSString *)crossId
                                   sn:(NSString *)sn
                           completion:(void(^)(BOOL finished))completion;

- (void)removeSignalCtrllerWithCtrllerId:(NSString *)ctrllerId
                              completion:(void(^)(BOOL finished))completion;

- (void)stepSignalCtrllerWithCtrllerId:(NSString *)ctrllerId
                            completion:(void(^)(BOOL finished))completion;

- (BOOL)isSignalCtrllerControlling:(NSString *)ctrllerId;

@property(nonatomic, readonly) NSString *userName;

@property(nonatomic, readonly) BOOL isRunning;

@end
