//
//  TCUser.h
//  websocketDemo
//
//  Created by 郭志伟 on 16/3/1.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

@interface TCUser : NSObject

- (instancetype)initWithUsrId:(NSString *)usrId;


@property(nonatomic, readonly) NSString *usrId;

@property(nonatomic, readonly) FMDatabaseQueue *dbq;

@end
