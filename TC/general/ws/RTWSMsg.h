//
//  RTWSMsg.h
//  websocketDemo
//
//  Created by 郭志伟 on 16/2/26.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import<CommonCrypto/CommonDigest.h>
//#import <CommonCrypto/CommonCryptor.h>

@interface RTWSMsg : NSObject

- (instancetype)initWithDict:(NSDictionary *)dict;

- (void)addParamWithKey:(NSString *)key value:(id)value;

@property(nonatomic, copy) NSString *topic;
@property(nonatomic, readonly) NSString *msgId;
@property(nonatomic, readonly) NSDictionary *params;
@property(nonatomic, readonly) NSDate *timestamp;


- (NSString *) toJsonString;

@end
