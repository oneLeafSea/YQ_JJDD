//
//  RTDYMsg.h
//  TC
//
//  Created by guozw on 16/8/25.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTDYMsg : NSObject
- (instancetype)initWithDict:(NSDictionary *)dict;

- (void)addParamWithKey:(NSString *)key value:(id)value;

@property(nonatomic, copy) NSString *topic;
@property(nonatomic, readonly) NSString *msgId;
@property(nonatomic, readonly) NSDictionary *params;
@property(nonatomic, readonly) NSDate *timestamp;


- (NSString *) toJsonString;
@end
