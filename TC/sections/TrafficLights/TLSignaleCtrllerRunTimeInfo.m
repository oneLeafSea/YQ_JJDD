//
//  TLSignaleCtrllerRunTimeInfo.m
//  TC
//
//  Created by 郭志伟 on 15/11/19.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TLSignaleCtrllerRunTimeInfo.h"

@implementation TLSignaleCtrllerRunTimeInfo

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self parseDict:dict];
    }
    return self;
}

- (void)parseDict:(NSDictionary *)dict {
    self.crossId = [dict objectForKey:@"crossId"];
    self.junctionId = [dict objectForKey:@"junctionId"];
    self.lockStage = [dict objectForKey:@"lockStage"];
    self.lockUser = [dict objectForKey:@"lockUser"];
    self.note = [dict objectForKey:@"manCtrlNote"];
    if ([self.note isKindOfClass:[NSNull class]]) {
        self.note = nil;
    }
    self.modelCode = [dict objectForKey:@"modelCode"];
    self.modelDesc = [dict objectForKey:@"modelDesc"];
    self.phaseDataList = [dict objectForKey:@"phaseDataList"];
    self.stage = [dict objectForKey:@"runStage"];
    
}

- (BOOL)canControlled {
    if ([self.modelCode isEqualToString:@"0300"] || [self.modelCode isEqualToString:@"0602"]) {
        return NO;
    }
    return YES;
}

- (NSInteger)sn {
    NSNumber *s = [self.stage objectForKey:@"sn"];
    return [s integerValue];
}

- (NSInteger)duration {
    NSNumber *d = [self.stage objectForKey:@"duration"];
    return [d integerValue];
}

- (NSString *)stageName {
    return [self.stage objectForKey:@"name"];
}

@end
