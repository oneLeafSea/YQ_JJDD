//
//  TVRoadCamInfo.h
//  TC
//
//  Created by 郭志伟 on 15/11/21.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "TLPoint.h"
#import "TVCamInfo.h"

/**
 *  路口和高空的接口参数是一样的，但是我没有将它们放在一起，怕以后如果有变化会带来麻烦
 *
 */

@interface TVRoadCamInfo : TVCamInfo

- (instancetype)initWithDict:(NSDictionary *)dict;
- (instancetype)initWithJsonStr:(NSString *)jsonStr;

@property(nonatomic, copy) NSString *digitalZoom;
@property(nonatomic, copy) NSString *frame;
@property(nonatomic, copy) NSString *installBy;
@property(nonatomic, copy) NSString *installDt;
@property(nonatomic, copy) NSString *installPhase;
@property(nonatomic, copy) NSString *ipAddress;
@property(nonatomic, copy) NSString *resolution;
@property(nonatomic, copy) NSString *software;
@property(nonatomic, copy) NSString *uid;
@property(nonatomic, copy) NSString *wkt;
@property(nonatomic, copy) NSString *desc;

@property(nonatomic, readonly) TLPoint pt;
@end
