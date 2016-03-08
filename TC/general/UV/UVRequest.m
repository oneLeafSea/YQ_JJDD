//  Copyright (c) 2014年 Zhejiang Uniview Technologies Co., Ltd. All rights reserved.
// --------------------------------------------------------------------------------
// UVRequest.m
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

#import "UVRequest.h"
#import "NSObject+UVObjects.h"
#import "MBProgressHUD.h"

static UVRequest *_requestinstance = nil;
@implementation UVRequest
{
}
- (void)initData
{
    _requestQueue = dispatch_queue_create("_requestQueue", DISPATCH_QUEUE_CONCURRENT);
}

- (id)init
{
    if(self = [super init])
    {
        [self initData];
    }
    return self;
}
+(UVRequest*)instance
{
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        _requestinstance = [[UVRequest alloc] init];
    });
    return _requestinstance;
}
- (void)execRequest:(void (^)())block_ finish:(void (^)(UVError *error))finish_
{
    [self execRequest:block_ finish:finish_ showProgressInView:nil message:nil];
}
- (void)execRequest:(void (^)())block_ finish:(void (^)(UVError *error))finish_ showProgressInView:(UIView*)view
{
    [self execRequest:block_ finish:finish_ showProgressInView:view message:@"加载中 ..."];
}
- (void)execRequest:(void (^)())block_ finish:(void (^)(UVError *error))finish_ showProgressInView:(UIView*)view message:(NSString*)message
{
    dispatch_async(_requestQueue, ^{
        UVError *err = nil;
        __block MBProgressHUD *hub = nil;
        if(view != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                hub = [self progress:view message:message];
            });
        }
        @try {
            block_();
        }
        @catch (UVError *exception) {
            err = exception;
        }
        @catch (NSException *exception) {
            err = [UVError errorWithCode:UV_ERROR_COMMON_FAILURE];
        }
        @finally {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(hub != nil)
                {
                    [hub hide:NO];
                    hub = nil;
                }
                if(finish_ != nil)
                {
                    finish_(err);
                }
                
            });
        }
    });
}
- (void)releaseQueue
{
    if(_requestQueue!=nil)
    {
        _requestQueue = nil;
    }
}
@end
