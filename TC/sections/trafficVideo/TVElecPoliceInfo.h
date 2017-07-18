//
//  TVElecPoliceInfo.h
//  TC
//
//  Created by 郭志伟 on 15/11/21.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLPoint.h"

#import "TVCamInfo.h"

@interface TVElecPoliceInfo : TVCamInfo

- (instancetype)initWithDict:(NSDictionary *)dict;
- (instancetype)initWithJsonStr:(NSString *)jsonStr;

@property(nonatomic, copy) NSString *crossId;
@property(nonatomic, copy) NSString *ctrlerId;
@property(nonatomic, copy) NSString *desc;
@property(nonatomic, copy) NSString *installPhase;
@property(nonatomic, copy) NSString *ipAddress;
@property(nonatomic, copy) NSString *linkId;
@property(nonatomic, copy) NSString *tollgateId;
@property(nonatomic, copy) NSString *uid;
@property(nonatomic, copy) NSString *wkt;

@property(nonatomic, readonly) TLPoint pt;
@property(nonatomic, assign) BOOL tollageSelected;
@property(nonatomic, assign) BOOL videoSelected;

@end
