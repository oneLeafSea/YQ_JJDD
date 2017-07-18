//
//  TCTableRef.m
//  websocketDemo
//
//  Created by 郭志伟 on 16/3/1.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import "TCTableRef.h"

NSString const* kTbTollgatePush = @"tb_Tollegate_Push";

NSString * kSqlTollgatePushTbCreate = @"CREATE TABLE IF NOT EXISTS `tb_Tollegate_Push` ("
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

NSString * kSqlTollgateBKPushTbCreate_BK = @"CREATE TABLE IF NOT EXISTS `tb_ToBK_Push` ("
"`msgid`	TEXT,"
"`alarmType` TEXT,"
"`alarmControlType`	TEXT,"
"`alarmControlContent` TEXT,"
"`deviceId`	TEXT,"
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
"`alarmcontroldesc` TEXT,"
"PRIMARY KEY(msgid)"
");";
NSString * kSqlTollgateDYPushTbCreate = @"CREATE TABLE IF NOT EXISTS `tb_tollgateDY_Push` ("
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
NSString *kSqlTollagtePushInsert = @"INSERT INTO `tb_Tollegate_Push`(`msgid`,`deviceId`,`alarmType`,`alarmCode`,`alarmContent`,`plateCode`,`location`,`capTime`,`speed`,`laneNo`,`direction`,`logo`,`plateConfidence`,`plateColor`,`vehicleType`,`vehicleColor`,`imgUrl`,`plateCodeUrl`) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
NSString *kSqTollagteBKPushInsert= @"INSERT INTO `tb_ToBK_Push`(`msgid`,`alarmType`,`alarmControlType`,`alarmControlContent`,`plateCode`,`location`,`capTime`,`speed`,`laneNo`,`direction`,`logo`,`plateConfidence`,`plateColor`,`vehicleType`,`vehicleColor`,`imgUrl`,`plateCodeUrl`,`alarmcontroldesc`) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
NSString *kSqlTollagteDYPushInsert = @"INSERT INTO `tb_tollgateDY_Push`(`msgid`,`deviceId`,`plateCode`,`location`,`capTime`,`speed`,`laneNo`,`direction`,`logo`,`plateConfidence`,`plateColor`,`vehicleType`,`vehicleColor`,`imgUrl`,`plateCodeUrl`) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
NSString *kSqlTollageQueryWithLimit = @"SELECT * FROM `tb_Tollegate_Push`  ORDER BY `capTime` DESC LIMIT 0, ?;";
NSString *kSqlTollageBKQueryWithLimit = @"SELECT * FROM `tb_ToBK_Push`  ORDER BY `capTime` DESC LIMIT 0, ?;";
NSString *kSqlTollageDYQueryWithLimit = @"SELECT * FROM `tb_tollgateDY_Push`  ORDER BY `capTime` DESC LIMIT 0, ?;";


NSString *kSqlTollageTruncate = @"DELETE FROM `tb_Tollegate_Push`";
NSString *kSqlTollageBKTruncate = @"DELETE FROM `tb_ToBK_Push`";
NSString *kSqlTollageDYTruncate = @"DELETE FROM `tb_tollgateDY_Push`";