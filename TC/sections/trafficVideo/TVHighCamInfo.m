//
//  TVHighCamInfo.m
//  TC
//
//  Created by 郭志伟 on 15/11/21.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TVHighCamInfo.h"
#import "JSONKit.h"
#import "NSDictionary+null2nil.h"

@implementation TVHighCamInfo

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
    self.desc = [dict jsonObjectForKey:@"description"];
    self.deviceId = [dict jsonObjectForKey:@"deviceId"];
    self.deviceNam = [dict jsonObjectForKey:@"deviceNam"];
    self.digitalZoom = [dict jsonObjectForKey:@"frame"];
    self.frame = [dict jsonObjectForKey:@"frame"];
    self.installBy = [dict jsonObjectForKey:@"installBy"];
    self.installDt = [dict jsonObjectForKey:@"installDt"];
    self.installPhase = [dict jsonObjectForKey:@"installPhase"];
    self.ipAddress = [dict jsonObjectForKey:@"ipAddress"];
    self.resolution = [dict jsonObjectForKey:@"resolution"];
    self.software = [dict jsonObjectForKey:@"software"];
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
        return @"map_high_offline";
    }
    if ([self.status isEqualToString:kCamStatusWarn]) {
        return @"map_high_cam_warn";
    }
    
    if ([self.status isEqualToString:kCamStautsOffline]) {
        return @"map_high_offline";
    }
    
    return @"map_high_cam";
}

- (NSString *)selectedImgName {
    return @"map_high_cam_sel";
}


@end
