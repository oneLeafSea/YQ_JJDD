//
//  TCUser.m
//  websocketDemo
//
//  Created by 郭志伟 on 16/3/1.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import "TCUser.h"
#import "TCTableRef.h"

@interface TCUser()

@property(nonatomic, strong)FMDatabaseQueue *dbQueue;

@end

@implementation TCUser

- (instancetype)initWithUsrId:(NSString *)usrId {
    if (self = [super init]) {
        _usrId = [usrId copy];
        if (![self setupDb]) {
            self = nil;
        }
    }
    return self;
}

- (NSString *)getUsrPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = paths.firstObject;
    NSLog(@"%@", docPath);
    NSString *usrPath = [docPath stringByAppendingPathComponent:self.usrId];
    return usrPath;
}

- (NSString *)genDbPath {
    NSString *usrPath = [self getUsrPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:usrPath]) {
        NSError *err = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:usrPath withIntermediateDirectories:YES attributes:nil error:&err];
        if (err) {
            NSLog(@"创建用户文件夹失败。");
            return nil;
        }
    }
    NSString *dbName = [NSString stringWithFormat:@"%@.db", self.usrId];
    NSString *dbPath = [usrPath stringByAppendingPathComponent:dbName];
    NSLog(@"dbPath: %@", dbPath);
    return dbPath;
}

- (BOOL)setupDb {
    NSString *path = [self genDbPath];
    self.dbQueue = [[FMDatabaseQueue alloc] initWithPath:path];
    if (self.dbQueue == nil) {
        NSLog(@"创建数据库失败！");
        return NO;
    }
    
    if (![self createTb_To]) {
        return NO;
    }
    if (![self createTb3]) {
        return  NO;
    }
    if (![self createTb_BK]) {
        return NO;
    }
   
    return YES;
}

- (BOOL)createTb_To {
    __block BOOL ret = YES;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        ret = [db executeUpdate:kSqlTollgatePushTbCreate];
    }];
    return ret;
}
-(BOOL)createTb_BK{
    __block BOOL ret = YES;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        ret = [db executeUpdate:kSqlTollgateBKPushTbCreate_BK];
    }];
    return ret;
}
-(BOOL)createTb3{
    __block BOOL ret = YES;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        ret = [db executeUpdate:kSqlTollgateDYPushTbCreate];
    }];
    return ret;
}

#pragma mark - getter
- (FMDatabaseQueue *)dbq {
    return self.dbQueue;
}


@end
