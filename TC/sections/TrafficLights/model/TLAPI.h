//
//  TLAPI.h
//  TC
//
//  Created by 郭志伟 on 15/10/22.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLAPI : NSObject

/**
 *  登录接口
 *  @param usrName
 *  @param pwd
 *
 */

+ (void)loginWithUserName:(NSString *)usrName
                      pwd:(NSString *)pwd
               completion:(void(^)(BOOL finished, NSError *error))completion;



/*
 * 获取Arcgis token.
 */

+ (void)getArcgisTokenWithUsrName:(NSString *)usrName
pwd:(NSString *)pwd
                       completion:(void(^)(NSString *token, BOOL finished))completion;
//+ (void)getArcgisToken:
          //  (void(^)(NSString *string, BOOL finished))completion;
//+ (void)getArcgisTokenWithToken:(NSString *)token
//                     Completion:(void(^)(NSString *jsonResult, BOOL finished))completion;

/*
 * 获取所有信号机信息，以及地图上的坐标。
 */

+ (void)getAllSignalCtrlWithToken:(NSString *)token
                       Completion:(void(^)(NSString *jsonResult, BOOL finished))completion;

/*
 * 获取所有信号机的静态信息.
 */

+ (void)getAllSitracsJunctionsWithToken:(NSString *)token
                             Completion:(void(^)(NSString *jsonResult, BOOL finished))completion;

/*
 * 获取单台信号机的运行信息.
 */

+ (void)getCrossRunInfoWithCrossId:(NSString *)crossId
                             token:(NSString *)token
                        Completion:(void(^)(NSString *jsonResult, BOOL finished))completion;

/*
 * 设置信号机的运行阶段.
 */
+ (void)setCrossRunStageWithCrossId:(NSString *)crossId
                            stageSn:(NSString *)stageSn
                           lockTime:(NSString *)lockTime
                           userName:(NSString *)username
                         manTrigger:(BOOL)manTrigger
                              token:(NSString *)token
                         completion:(void(^)(BOOL finished))completion;


/**
 *  电子警察
 *
 *
 */

+ (void)getAllElecPoliceWithToken:(NSString *)token
                       completion:(void(^)(NSString*jsonResult, BOOL finished))completion;

/**
 *  路口云台
 *
 *
 */

+ (void)getAllVideoRoadCamWithToken:(NSString *)token
                         completion:(void(^)(NSString*jsonResult, BOOL finished))completion;


/**
 *  高空云台
 *
 *
 */

+ (void)getAllVideoHighCamWithToken:(NSString *)token
                         completion:(void(^)(NSString*jsonResult, BOOL finished))completion;

/**
 *  获取信号机一个周期的运行状态
 */

+ (void)getLastCrossSchemeWithCrossId:(NSString *)crossId
                                token:(NSString *)token
                           completion:(void(^)(NSString *jsonResult, BOOL finished))completion;

/**
 *  登录令牌
 *
 *  @return 返回登录令牌
 */

+ (NSString *)loginToken;

/**
 *  获取大为交通灯故障信息
 *
 *  @param token      令牌
 *  @param completion 闭包
 */
+ (void)getDWSignalCtrlStWithToken:(NSString *)token completion:(void(^)(NSString *jsonResult, BOOL finished))completion;

/**
 *  获取大为交通灯静态信息
 *
 *  @param token      令牌
 *  @param roadNo     路口号
 *  @param completion block
 */
+ (void)getDWStaticInfoWithToken:(NSString *)token roadNO:(NSString *)roadNo completion:(void(^)(NSString *jsonResult, BOOL finished))completion;

/**
 *  获取大为运行时的信息
 *
 *  @param roadNo     路口号
 *  @param token      令牌
 *  @param completion block
 */
+ (void)getDWCrossRunInfoWithRoadNo:(NSString *)roadNo
                             token:(NSString *)token
                        Completion:(void(^)(NSString *jsonResult, BOOL finished))completion;

/**
 *  锁定和释放大为信号机
 *
 *  @param roadNo     路口号
 *  @param stageSn    阶段
 *  @param lockTime   锁多长时间
 *  @param username   用户姓名
 *  @param manTrigger 是否是手工触发
 *  @param token      令牌
 *  @param regionId   未知
 *  @param ctrlerId   信号机ID
 *  @param ctrlerName 信号机名字
 *  @param relCrossId 不清楚
 *  @param completion block
 */
+ (void)setDWCrossRunStageWithRoadNo:(NSString *)roadNo
                             stageSn:(NSString *)stageSn
                            lockTime:(NSString *)lockTime
                            userName:(NSString *)username
                          manTrigger:(BOOL)manTrigger
                               token:(NSString *)token
                            regionId:(NSString *)regionId
                            ctrlerId:(NSString *)ctrlerId
                          ctrlerName:(NSString *)ctrlerName
                          relCrossId:(NSString *)relCrossId
                          completion:(void(^)(BOOL finished))completion;

/**
 *  获取大为最近运行的阶段
 *
 *  @param crossId    路口号
 *  @param token      登录令牌
 *  @param completion block
 */
+ (void)getDWLastCrossSchemeWithRoadNo:(NSString *)crossId token:(NSString *)token completion:(void (^)(NSArray *array, BOOL finished))completion;
+ (void)getSingnalCtrlwithTOKEN:(NSString *)token
                       crossIds:(NSString*)crossIds
                        USER_ID:(NSString*)userId REQ_ID:(NSString*)Id RESULT_PUSH_URL:(NSString*)result_push_url
                    
                     Completion:(void(^)(BOOL finished))completion;
+(void)getUrlfromOurWebSocketWithreqid:(NSString*)reqId completion:(void(^)(NSString *jsonResult,BOOL finished))completion;
+(void)getSingalCtrlReleaseToken:(NSString *)token reqId:(NSString*)reqId userId:(NSString*)userId completion:(void(^)(BOOL finished))completion;
//卡口订阅登录使用
+(void)loginTollegateDYWithUserName:(NSString*)username arr:(NSString*)arr loginFlag:(NSString*)loginFlag completion:(void(^)(BOOL finished))completion;
+(void)getDYInfomationWithUsername:(NSString *)username completion:(void(^)(BOOL finished))completion;
@end
