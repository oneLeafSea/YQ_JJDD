//
//  TLStageInfo.h
//  TC
//
//  Created by 郭志伟 on 15/11/25.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface TLStageInfo : NSObject

- (instancetype)initWithDict:(NSDictionary *)dict;

@property(nonatomic, copy) NSString *sn;
@property(nonatomic, copy) NSString *seconds;

@end
