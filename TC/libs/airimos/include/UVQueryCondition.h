// Copyright (c) 2011-2014, Zhejiang Uniview Technologies Co., Ltd. All rights reserved.
// --------------------------------------------------------------------------------
// UVQueryCondition.h
//
// Project Code: AirIMOSIphoneSDK
// Module Name:
// Date Created: 2013-11-19
// Author: chenjiaxin/00891
// Description:查询条件类
//
// --------------------------------------------------------------------------------
// Modification History
// DATE        NAME             DESCRIPTION
// --------------------------------------------------------------------------------
//

/** 查询条件类
 
 主要在调用获取列表信息接口时使用，示例代码：
 
        UVQueryCondition *condition = [[UVQueryCondition all] int]
        [condition setIsQuerySub:NO];
        [condition setLimit:20];
        [condition setOffset:0];
 
 */
@interface UVQueryCondition : NSObject
//是否查询子组织 必要参数
@property(nonatomic,assign) BOOL isQuerySub;
//分页数量 必要参数
@property(nonatomic,assign) int32_t limit;
//分页起始位置 必要参数
@property(nonatomic,assign) int32_t offset;

@end
