//
//  TVElecPoliceInfo.m
//  TC
//
//  Created by 郭志伟 on 15/11/21.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TVElecPoliceInfo.h"

#import "JSONKit.h"
#import "NSDictionary+null2nil.h"

@implementation TVElecPoliceInfo

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self parseDict:dict];
    }
    return self;
}
- (instancetype)initWithJsonStr:(NSString *)jsonStr {
    NSDictionary *dict = [jsonStr objectFromJSONString];
    if ([dict isKindOfClass:[NSDictionary class]]) {
        return [self initWithDict:dict];
    }
    return nil;
}

- (void)parseDict:(NSDictionary *)dict {
    self.crossId = [dict jsonObjectForKey:@"crossId"];
    self.ctrlerId = [dict jsonObjectForKey:@"ctrlerId"];
    self.desc = [dict jsonObjectForKey:@"description"];
    self.deviceId = [dict jsonObjectForKey:@"deviceId"];
    self.deviceNam = [dict jsonObjectForKey:@"deviceNam"];
    self.installPhase = [dict jsonObjectForKey:@"installPhase"];
    self.ipAddress = [dict jsonObjectForKey:@"ipAddress"];
    self.linkId = [dict jsonObjectForKey:@"linkId"];
    self.status = [dict jsonObjectForKey:@"status"];
    self.tollgateId = [dict jsonObjectForKey:@"tollgateId"];
    self.tunnel = [dict jsonObjectForKey:@"tunnel"];
    self.status = [dict jsonObjectForKey:@"status"];
    self.tunnel = [dict jsonObjectForKey:@"tunnel"];
    self.uid = [dict jsonObjectForKey:@"uid"];
    self.wkt = [dict jsonObjectForKey:@"wkt"];
}

- (TLPoint)pt {
    TLPoint pt = [self parseWkt:self.wkt];
    return pt;
}

- (TLPoint)parseWkt:(NSString *)wkt {
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

- (NSString *)getCamImagByStatus {
    if ([self.status isEqualToString:kCamStatusBroken]) {
        return @"map_elec_offline";
    }
    if ([self.status isEqualToString:kCamStatusWarn]) {
        return @"map_elec_warn";
    }
    
    if ([self.status isEqualToString:kCamStautsOffline]) {
        return @"map_elec_offline";
    }
    
    return @"map_elec";
}

- (NSString *)selectedImgName {
    return @"map_elec_sel";
}

@end
