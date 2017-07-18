//
//  TLCrossScheme.h
//  TC
//
//  Created by 郭志伟 on 15/11/25.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLStageInfo.h"
#import "TLSignaleCtrllerRunTimeInfo.h"
@interface TLCrossScheme : NSObject

+ (NSString *)getSnNameBySn:(NSInteger)sn;

- (instancetype)initWitArray:(NSArray *)array;

@property(nonatomic, strong)NSArray *stageInfoArray;
@property(nonatomic,strong)TLSignaleCtrllerRunTimeInfo*tls;
- (NSString *)getSecondsBySn:(NSString *)sn;
- (NSString *)getSecondsByIntSn:(NSInteger)sn;

- (NSString *)getNextSnByPreSn:(NSString *)preSn;

@end
