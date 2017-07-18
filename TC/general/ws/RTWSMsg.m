//
//  RTWSMsg.m
//  websocketDemo
//
//  Created by 郭志伟 on 16/2/26.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import "RTWSMsg.h"
#import "RTWSMsgConstants.h"
#import "NSDate+Common.h"
#import "JSONKit.h"
#import "NSString+AESCrypt.h"
@interface RTWSMsg()

@property(nonatomic, strong) NSMutableDictionary *content;

@end

@implementation RTWSMsg


- (instancetype)init {
    if (self = [super init]) {
        self.content = [[NSMutableDictionary alloc] init];
        _msgId = [NSUUID UUID].UUIDString;
        _timestamp = [[NSDate alloc] init];
    }
    return self;
}


- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        if (![self parseDict:dict]) {
            self = nil;
        }
    }
    return self;
}

- (NSDictionary *)params {
    return self.content;
}

- (BOOL)parseDict:(NSDictionary *)dict {
    
    _msgId = [dict valueForKey:@"msgid"];
    if (_msgId == nil) {
        return NO;
    }
    NSString *content = [dict valueForKey:@"content"];
    NSLog(@"self.content:%@",content);
    if (content == nil) {
        
        return NO;
    }
    
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    self.content = [NSJSONSerialization JSONObjectWithData:contentData options:NSJSONReadingMutableContainers error:nil];
    
    
    NSString *timestamp = [dict valueForKey:@"timestamp"];
    if (timestamp == nil) {
        return NO;
    }
    
    _timestamp = [NSDate dateWithFormater:@"yyyy-MM-dd HH:mm:ss.SSSSSS" stringTime:timestamp];
    if (_timestamp == nil) {
        NSLog(@"转换时间戳失败.");
        return NO;
    }
    
    return YES;
}

- (void)addParamWithKey:(NSString *)key value:(id)value {
//    [self.content valueForKey:value forKey:key];
    [self.content setValue:value forKey:key];
}

- (NSString *) toJsonString {
    
    NSError *err = nil;
    NSString *strContent = nil;
        if (self.content) {
        //NSLog(@"%@",self.content);
        //strContent = self.content.JSONString;
            
        NSData *jsonData=[NSJSONSerialization dataWithJSONObject:self.content options:NSJSONWritingPrettyPrinted error:nil];
    strContent=[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
       // NSLog(@"%@",self.content);
    }
    NSMutableDictionary *mDict = [[NSMutableDictionary alloc] initWithCapacity:4];
    [mDict setValue:self.msgId forKey:@"msgid"];
    [mDict setValue:self.topic forKey:@"topic"];
    if (strContent) {
        [mDict setValue:strContent forKey:@"content"];
    }
    [mDict setValue:[self.timestamp formatWith:nil] forKey:@"timestamp"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:mDict options:NSJSONWritingPrettyPrinted error:&err];
    NSString *strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"---strData%@------",strData);
    return strData;
}

@end
