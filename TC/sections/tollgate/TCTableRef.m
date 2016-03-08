//
//  TCTableRef.m
//  websocketDemo
//
//  Created by 郭志伟 on 16/3/1.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import "TCTableRef.h"

NSString const* kTbTollgatePush = @"tb_tollgate_Push";



NSString * kSqlTollgatePushTbCreate = @"CREATE TABLE IF NOT EXISTS `tb_tollgate_Push` ("
                                            "`msgid`	TEXT,"
                                            "`deviceId`	TEXT,"
                                            "`alarmType`	TEXT,"
                                            "`alarmCode`	TEXT,"
                                            "`alarmContent`	TEXT,"
                                            "`plateCode`	TEXT,"
                                            "`location`	TEXT,"
                                            "`capTime`	TEXT,"
                                            "`speed`	TEXT,"
                                            "`laneNo`	TEXT,"
                                            "`direction`	TEXT,"
                                            "`logo`	TEXT,"
                                            "`plateConfidence`	TEXT,"
                                            "`plateColor`	TEXT,"
                                            "`vehicleType`	TEXT,"
                                            "`vehicleColor`	TEXT,"
                                            "`imgUrl`	TEXT,"
                                            "`plateCodeUrl`	TEXT,"
                                            "PRIMARY KEY(msgid)"
                                            ");";


NSString *kSqlTollagtePushInsert = @"INSERT INTO `tb_tollgate_Push`(`msgid`,`deviceId`,`alarmType`,`alarmCode`,`alarmContent`,`plateCode`,`location`,`capTime`,`speed`,`laneNo`,`direction`,`logo`,`plateConfidence`,`plateColor`,`vehicleType`,`vehicleColor`,`imgUrl`,`plateCodeUrl`) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";

NSString *kSqlTollageQueryWithLimit = @"SELECT * FROM `tb_tollgate_Push`  ORDER BY `msgid` ASC LIMIT 0, ?;";

NSString *kSqlTollageTruncate = @"DELETE FROM `tb_tollgate_Push`";

