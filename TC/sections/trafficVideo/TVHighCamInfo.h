//
//  TVHighCamInfo.h
//  TC
//
//  Created by 郭志伟 on 15/11/21.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TLPoint.h"
#import "TVCamInfo.h"

@interface TVHighCamInfo : TVCamInfo

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
