//
//  TLSignalCtrlerInfo.m
//  TC
//
//  Created by 郭志伟 on 15/11/17.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TLSignalCtrlerInfo.h"
#import "LogLevel.h"

NSString *kSignalCtrlerStatusNormal = @"0";
NSString *kSignalCtrlerStatusOffline = @"1";
NSString *kSignalCtrlerStatusWarn = @"2";
NSString *kSignalCtrlerStatusBroken = @"3";

@implementation TLSignalCtrlerInfo

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self parseDict:dict];
    }
    return self;
}

- (void)parseDict:(NSDictionary *)dict {
    self.crossId = [dict objectForKey:@"crossId"];
    self.ctrlerId = [dict objectForKey:@"ctrlerId"];
    self.ctrlerNam = [dict objectForKey:@"ctrlerNam"];
    self.desc = [dict objectForKey:@"description"];
    self.deviceTp = [dict objectForKey:@"deviceTp"];
    self.software = [dict objectForKey:@"software"];
    self.status = [dict objectForKey:@"status"];
    self.uid = [dict objectForKey:@"uid"];
    self.wkt = [dict objectForKey:@"wkt"];
    self.installPhase = [dict objectForKey:@"installPhase"];
    self.roadNo = [dict objectForKey:@"roadNo"];
    self.regionId = [dict objectForKey:@"regionNo"];
}

- (TLPoint)tlPoint {
    TLPoint pt = [self parseWkt:self.wkt];
    return pt;
}

- (TLPoint)parseWkt:(NSString *)wkt {
    //    "wkt":"POINT (63578.8145040525 41829.1852186713)"
    NSRange lr = [wkt rangeOfString:@"("];
    NSRange rr = [wkt rangeOfString:@")"];
    NSString *subStr = [wkt substringWithRange:NSMakeRange(lr.location+1, rr.location - lr.location-1)];
    NSArray *splitArray = [subStr componentsSeparatedByString:@" "];
    TLPoint pt = {0,0};
    if (splitArray.count != 2) {
        return pt;
    }
    pt.x = [splitArray[0] doubleValue];
    pt.y = [splitArray[1] doubleValue];
    return pt;
}

- (id)copyWithZone:(NSZone *)zone
{
    TLSignalCtrlerInfo *copy = [[TLSignalCtrlerInfo alloc] init];
    if (copy) {
        copy.crossId = [self.crossId copy];
        copy.ctrlerId = [self.ctrlerId copy];
        copy.ctrlerNam = [self.ctrlerNam copy];
        copy.desc = [self.desc copy];
        copy.deviceTp = [self.deviceTp copy];
        copy.software = [self.software copy];
        copy.status = [self.status copy];
        copy.uid = [self.uid copy];
        copy.wkt = [self.wkt copy];
    }
    return copy;
}

- (NSString *)getSCImageByStatus {
    if ([self.status isEqualToString:kSignalCtrlerStatusOffline]) {
        return @"map_ctrller_offline";
    }
    if ([self.status isEqualToString:kSignalCtrlerStatusWarn]) {
        return @"map_ctrller_warn";
    }
    
    if ([self.status isEqualToString:kSignalCtrlerStatusBroken]) {
        return @"map_ctrller_offline";
    }
    
    return @"map_ctrller";
}

- (BOOL)canSelected {
    if ([self.status isEqualToString:kSignalCtrlerStatusOffline] ||
        [self.status isEqualToString:kSignalCtrlerStatusBroken]) {
        return NO;
    }
    return YES;
}

- (void)getCrossRunInfoWithToken:(NSString *)token
                      Completion:(void(^)(NSString *jsonResult, BOOL finished))completion {
    completion(nil, NO);
}

- (void)setCrossRunStageWithLockTime:(NSString *)lockTime
                            userName:(NSString *)username
                          manTrigger:(BOOL)manTrigger
                             stageSn:(NSString *)stageSn
                               token:(NSString *)token
                          completion:(void(^)(BOOL finished))completion {
    completion(NO);
}

- (void)getLastCrossSchemeWithToken:(NSString *)token
                         completion:(void(^)(NSString *jsonResult, BOOL finished))completion {
    completion(nil, NO);
}

- (NSString *)description {
    NSString* desc = [NSString stringWithFormat:@"TLSignalCtrlerInfo: Id: %@, name: %@", self.ctrlerId, self.ctrlerNam];
    return desc;
}

@end
