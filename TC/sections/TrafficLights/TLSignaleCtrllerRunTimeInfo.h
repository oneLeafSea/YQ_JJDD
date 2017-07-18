//
//  TLSignaleCtrllerRunTimeInfo.h
//  TC
//
//  Created by 郭志伟 on 15/11/19.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kSNStateConverting 255
#define kSNStateUnkown  -1

@interface TLSignaleCtrllerRunTimeInfo : NSObject


- (instancetype)initWithDict:(NSDictionary *)dict;

@property(nonatomic, copy) NSString *crossId;
@property(nonatomic, copy) NSString *junctionId;
@property(nonatomic, copy) NSString *lockStage;
@property(nonatomic, copy) NSString *lockUser;
@property(nonatomic, copy) NSString *modelCode;
@property(nonatomic, copy) NSString *modelDesc;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSDictionary *note;
@property(nonatomic, copy) NSDictionary *stage;
@property(nonatomic, copy) NSArray *phaseDataList;
@property(nonatomic, readonly) BOOL canControlled;
@property(nonatomic, readonly) NSInteger sn;
@property(nonatomic, readonly) NSInteger duration;
@property(nonatomic, readonly) NSString *stageName;
@property(nonatomic,copy)NSString*stageId;

@end
