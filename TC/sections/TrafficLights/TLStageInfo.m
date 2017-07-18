//
//  TLStageInfo.m
//  TC
//
//  Created by 郭志伟 on 15/11/25.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TLStageInfo.h"


@implementation TLStageInfo

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        if (![self parseDict:dict]) {
            self = nil;
        }
    }
    return self;
}



- (BOOL)parseDict:(NSDictionary *)dict {
    if ([dict isKindOfClass:[NSDictionary class]]) {
        self.sn = [dict objectForKey:@"stageSn"];
        self.seconds = [dict objectForKey:@"stageSeconds"];
        return YES;
    }
    return NO;
}

@end
