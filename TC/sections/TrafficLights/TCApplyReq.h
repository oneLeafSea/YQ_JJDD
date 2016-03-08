//
//  TCApplyReq.h
//  websocketDemo
//
//  Created by 郭志伟 on 16/2/29.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTWSMgr.h"

@interface TCApplyReq : NSObject

+ (void)ApplyCtrlWithWsmgr:(RTWSMgr *)wsmgr
                completion:(void(^)(RTWSMsg *msg, NSError *err))completion;

@end
