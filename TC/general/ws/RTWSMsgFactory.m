//
//  RTWSMsgFactory.m
//  websocketDemo
//
//  Created by 郭志伟 on 16/2/29.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import "RTWSMsgFactory.h"
#import "RTWSMsgConstants.h"
#import "RTWSMsg.h"

@implementation RTWSMsgFactory

+ (void)handleMsg:(id)msg {
    NSDictionary *dict = msg;
    NSString *topic = [dict valueForKey:@"topic"];
    if (topic == nil) {
        NSLog(@"错误的消息。");
        return;
    }
    
    if ([topic isEqualToString:kTopicTollgatePush]) {
        RTWSMsg *msg = [[RTWSMsg alloc] initWithDict:dict];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationTollgatePush object:msg];
    } else {
        NSLog(@"未识别的消息:%@", dict);
    }
}

@end
