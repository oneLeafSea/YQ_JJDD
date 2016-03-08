//
//  TCSignalCtrllerUpdater.h
//  TC
//
//  Created by 郭志伟 on 15/11/19.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLCrossScheme.h"

@protocol TCSignalCtrllerUpdaterDelegate;

@interface TCSignalCtrllerUpdater : NSObject


- (void)addScInfoWithCrossId:(NSString *)crossId completion:(void(^)(BOOL finished))completion;
- (void)removeScInfoWithCrossId:(NSString *)crossId;

- (void)removeAll;

- (void) start;
- (void) stop;

@property(nonatomic, readonly)BOOL isRunning;

@property(nonatomic, weak) id<TCSignalCtrllerUpdaterDelegate> delegate;

@end

@protocol TCSignalCtrllerUpdaterDelegate <NSObject>

- (void)TCSignalCtrllerUpdater:(TCSignalCtrllerUpdater *)scUpdater result:(NSArray *)result crossScheme:(TLCrossScheme *)cs;

@end
