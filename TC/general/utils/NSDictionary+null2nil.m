//
//  NSDictionary+null2nil.m
//  TC
//
//  Created by 郭志伟 on 15/11/21.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "NSDictionary+null2nil.h"

@implementation NSDictionary (null2nil)

- (id)jsonObjectForKey:(id)aKey {
    id object = [self objectForKey:aKey];
    if ([object isKindOfClass:[NSNull class]]) {
        object = nil;
    }    
    return object;
}

@end
