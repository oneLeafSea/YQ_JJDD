// Copyright (c) 2011-2014, Zhejiang Uniview Technologies Co., Ltd. All rights reserved.
// --------------------------------------------------------------------------------
// UVQueryResourceParam.h
//
// Project Code: AirIMOSIphoneSDK
// Module Name:
// Date Created: 2013-11-19
// Author: chenjiaxin/00891
// Description:查询资源参数类
//
// --------------------------------------------------------------------------------
// Modification History
// DATE        NAME             DESCRIPTION
// --------------------------------------------------------------------------------
//

@class UVQueryCondition;

/** 查询资源参数类
 
 主要在调用查询资源接口时使用，参考UVServiceManager方法：
 
        - (void)queryResource:(UVQueryResourceParam*)para_ listener:(void (^)(NSArray *resList,UVError *error))block_;
 
 */
@interface UVQueryResourceParam : NSObject
//查询关键字 可为空
@property(nonatomic,strong) NSString *matchString;
//查询组织编码 可为空
@property(nonatomic,strong) NSString *orgCode;
//查询条件 必要参数
@property(nonatomic,strong) UVQueryCondition *queryCondition;

@end
