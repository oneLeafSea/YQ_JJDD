//  Copyright (c) 2014年 Zhejiang Uniview Technologies Co., Ltd. All rights reserved.
// --------------------------------------------------------------------------------
// UVRequest.h
//
// Project Code: AirIMosIphoneSDK_Demo
// Module Name:
// Date Created: 14-2-14
// Author: chenjiaxin/00891
// Description:
//
// --------------------------------------------------------------------------------
// Modification History
// DATE        NAME             DESCRIPTION
// --------------------------------------------------------------------------------
// 14-2-14  c00891 create
//

#import <UIKit/UIKit.h>
#import "UVError.h"

@interface UVRequest : NSObject
@property(nonatomic,readonly) dispatch_queue_t requestQueue;

- (id)init;

/** 实例化对象
 
 建议在使用前，均调用此静态方法
 
 @return UVRequest
 */
+(UVRequest*)instance;
- (void)execRequest:(void (^)())block_ finish:(void (^)(UVError *error))finish_;
- (void)execRequest:(void (^)())block_ finish:(void (^)(UVError *error))finish_ showProgressInView:(UIView*)view;
- (void)execRequest:(void (^)())block_ finish:(void (^)(UVError *error))finish_ showProgressInView:(UIView*)view message:(NSString*)message;
- (void)releaseQueue;
@end
