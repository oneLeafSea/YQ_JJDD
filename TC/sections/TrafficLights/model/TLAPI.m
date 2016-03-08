//
//  TLAPI.m
//  TC
//
//  Created by 郭志伟 on 15/10/22.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TLAPI.h"
#import "TLConstants.h"
#import "env.h"
#import "JSONKit.h"

@implementation TLAPI

+ (NSURLSession *)tlSession {
    NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
    cfg.timeoutIntervalForRequest = 10;
    cfg.timeoutIntervalForResource = 12;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:cfg];
    return session;
}

+ (void)loginWithUserName:(NSString *)usrName
                      pwd:(NSString *)pwd
               completion:(void(^)(BOOL finished, NSError *error))completion {
#ifdef YUAN_QU_DA_DUI
    NSURLSession *session = [TLAPI tlSession];
    NSString *strUrl = [NSString stringWithFormat:kLoginUrlFmt, usrName, pwd];
    [[session dataTaskWithURL:[NSURL URLWithString:strUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        {"clientIP":"10.100.13.181","createDt":"2015-12-04 09:08:00.536","expiryDt":"2015-12-04 09:18:00.536","id":"","sessionId":"981790CE7B5A2DA3B246A3285E7107B7","token":"gjMDZDO1UjRGhzQ0QDR1EDOyYUOxUkNEZ0MxcDRDJjN","userId":"xiangsy"}
        
        if (error == nil) {
            NSDictionary *dict = [str objectFromJSONString];
            NSString *token = [dict objectForKey:@"token"];
            if (token.length > 0) {
                [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"tl.login.token"];
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(YES, nil);
                    });
                }
            } else {
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(NO, [NSError errorWithDomain:@"tl.login" code:1 userInfo:@{@"desc":@"toeken为空、用户名密码错误"}]);
                    });
                }
            }
            
        } else {
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(NO, error);
                });
            }
        }
    }] resume];
#else
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSUserDefaults standardUserDefaults] setObject:@"AzQwMzMzkDMENURFRjR4IkQDZTRzUUQFNkNxETOyY0N" forKey:@"tl.login.token"];
        completion(YES, nil);
    });
#endif
}

+ (NSString *)loginToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"tl.login.token"];
}

+ (void)getArcgisTokenWithUsrName:(NSString *)usrName
                              pwd:(NSString *)pwd
                       completion:(void(^)(NSString *token, BOOL finished))completion {
#ifdef YUAN_QU_DA_DUI
    NSURLSession *session = [TLAPI tlSession];
    NSString *strUrl = [NSString stringWithFormat:kArcgisTokenUrlFmt, usrName, pwd];
    [[session dataTaskWithURL:[NSURL URLWithString:strUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            __block NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if ([str isEqualToString:@"You are not authorized to access this information"]) {
                str = nil;
            }
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(str, ((str == nil) ? NO : YES));
                });
            }
        } else {
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, NO);
                });
            }
        }
    }] resume];
#else
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completion(@"123123123123", YES);
    });
#endif
}

+ (void)getAllSignalCtrlWithToken:(NSString *)token
                       Completion:(void(^)(NSString *jsonResult, BOOL finished))completion {
#ifdef YUAN_QU_DA_DUI
    NSURLSession *session = [TLAPI tlSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kAllSignalCtrlURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:token forHTTPHeaderField:@"token"];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil)
        {
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(str, YES);
                });
            }
        } else {
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, NO);
                });
            }
        }
    }];
    
    [getDataTask resume];
#else
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"signalCtrller" ofType:@"json"];
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        completion(str, YES);
    });
#endif
}

+ (void)getAllSitracsJunctionsWithToken:(NSString *)token
                             Completion:(void(^)(NSString *jsonResult, BOOL finished))completion {
#ifdef YUAN_QU_DA_DUI
    NSURLSession *session = [TLAPI tlSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kAllSitracsJunctionsURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:token forHTTPHeaderField:@"token"];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error == nil)
            {
                NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(str, YES);
                    });
                }
            } else {
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil, NO);
                    });
                }
            }
    }];
    
    [getDataTask resume];
#else
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"junction" ofType:@"json"];
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        completion(str, YES);
    });
#endif
}

+ (void)getCrossRunInfoWithCrossId:(NSString *)crossId
                             token:(NSString *)token
                        Completion:(void(^)(NSString *jsonResult, BOOL finished))completion {
#ifdef YUAN_QU_DA_DUI
    NSURLSession *session = [TLAPI tlSession];
    NSString *strUrl = [NSString stringWithFormat:kCrossRunInfoURLFmt, crossId];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    
    [request addValue:token forHTTPHeaderField:@"token"];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(str, YES);
                });
            }
        } else {
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, NO);
                });
            }
        }
    }];
    
    [getDataTask resume];
#else
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"signalCtrlRunTimeInfo" ofType:@"json"];
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        completion(str, YES);
    });
#endif
}

+ (void)setCrossRunStageWithCrossId:(NSString *)crossId
                            stageSn:(NSString *)stageSn
                           lockTime:(NSString *)lockTime
                           userName:(NSString *)username
                         manTrigger:(BOOL)manTrigger
                              token:(NSString *)token
                         completion:(void(^)(BOOL finished))completion {
    NSError *error = nil;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPAdditionalHeaders = @{@"token":token};
    configuration.timeoutIntervalForRequest = 10;
    configuration.timeoutIntervalForResource = 12;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:kSetCrossRunStageURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:token forHTTPHeaderField:@"token"];
    
    [request setHTTPMethod:@"POST"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:128];
    if (manTrigger) {
        [params setValue:@"True" forKey:@"manTrigger"];
    }
    [params setValue:crossId forKey:@"crossId"];
    [params setValue:stageSn forKey:@"stageSn"];
    [params setValue:lockTime forKey:@"lockTime"];
    [params setValue:username forKey:@"userName"];
    [params setValue:token forKey:@"token"];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil)
        {
#warning 接口返回还没有判断。
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@", str);
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(YES);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(NO);
                });
            }
        } else {
            NSLog(@"%@", error);
            completion(NO);
            
        }
    }];
    
    [postDataTask resume];
}


+ (void)getAllElecPoliceWithToken:(NSString *)token
                       completion:(void(^)(NSString*jsonResult, BOOL finished))completion {
    
#ifdef YUAN_QU_DA_DUI
    NSURLSession *session = [TLAPI tlSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kElecPoliceUrl]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    
    [request addValue:token forHTTPHeaderField:@"token"];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(str, YES);
                });
            }
        } else {
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, NO);
                });
            }
        }
    }];
    
    [getDataTask resume];
#else
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"elecPolice" ofType:@"json"];
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        completion(str, YES);
    });
#endif
}


+ (void)getAllVideoRoadCamWithToken:(NSString *)token
                         completion:(void(^)(NSString*jsonResult, BOOL finished))completion {
    
#ifdef YUAN_QU_DA_DUI
    NSURLSession *session = [TLAPI tlSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kAllVideoRoadCamUrl]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    
    [request addValue:token forHTTPHeaderField:@"token"];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(str, YES);
                });
            }
        } else {
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, NO);
                });
            }
        }
    }];
    
    [getDataTask resume];
#else
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"roadCam" ofType:@"json"];
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        completion(str, YES);
    });
#endif
}

+ (void)getAllVideoHighCamWithToken:(NSString *)token
                         completion:(void(^)(NSString*jsonResult, BOOL finished))completion {
#ifdef YUAN_QU_DA_DUI
    NSURLSession *session = [TLAPI tlSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kAllVideoHighCamUrl]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    
    [request addValue:token forHTTPHeaderField:@"token"];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(str, YES);
                });
            }
        } else {
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, NO);
                });
            }
        }
    }];
    
    [getDataTask resume];
#else 
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"highCam" ofType:@"json"];
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        completion(str, YES);
    });
#endif
}

+ (void)getLastCrossSchemeWithCrossId:(NSString *)crossId
                                token:(NSString *)token
                           completion:(void(^)(NSString *jsonResult, BOOL finished))completion {
    
#ifdef YUAN_QU_DA_DUI
    NSURLSession *session = [TLAPI tlSession];
    NSString *strUrl = [NSString stringWithFormat:kLastCrossSchemeUrlFmt, crossId];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    
    [request addValue:token forHTTPHeaderField:@"token"];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(str, YES);
                });
            }
        } else {
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, NO);
                });
            }
        }
    }];
    
    [getDataTask resume];
#else 
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"scheme.json" ofType:@"json"];
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        completion(str, YES);
    });
#endif
}

+ (NSString *)description {
    return @"交通信号灯管理模块.";
}

+ (void)getDWSignalCtrlStWithToken:(NSString *)token completion:(void(^)(NSString *jsonResult, BOOL finished))completion {
    NSURLSession *session = [TLAPI tlSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kDWSignalCtrlStUrl]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    
    [request addValue:token forHTTPHeaderField:@"token"];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(str, YES);
                });
            }
        } else {
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, NO);
                });
            }
        }
    }];
    
    [getDataTask resume];
}

+ (void)getDWStaticInfoWithToken:(NSString *)token roadNO:(NSString *)roadNo completion:(void(^)(NSString *jsonResult, BOOL finished))completion {
    NSString *strUrl = [NSString stringWithFormat:kDWSignalCtrlStaticInfoFmt, roadNo];
    NSURLSession *session = [TLAPI tlSession];
    [[session dataTaskWithURL:[NSURL URLWithString:strUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (error == nil) {
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(str, YES);
                });
            }
        } else {
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, NO);
                });
            }
        }
    }] resume];
    
}

+ (void)getDWCrossRunInfoWithRoadNo:(NSString *)roadNo
                               token:(NSString *)token
                          Completion:(void(^)(NSString *jsonResult, BOOL finished))completion {
    NSURLSession *session = [TLAPI tlSession];
    NSString *strUrl = [NSString stringWithFormat:kDWCrossRunInfoURLFmt, roadNo];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    
    [request addValue:token forHTTPHeaderField:@"token"];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(str, YES);
                });
            }
        } else {
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, NO);
                });
            }
        }
    }];
    
    [getDataTask resume];
}

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
                           completion:(void(^)(BOOL finished))completion {
    NSError *error = nil;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPAdditionalHeaders = @{@"token":token};
    configuration.timeoutIntervalForRequest = 10;
    configuration.timeoutIntervalForResource = 12;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:kDWSetCrossRunStageURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:token forHTTPHeaderField:@"token"];
    
    [request setHTTPMethod:@"POST"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:128];
    if (manTrigger) {
        [params setValue:@"True" forKey:@"manTrigger"];
    }
    [params setValue:roadNo forKey:@"crossId"];
    [params setValue:regionId forKey:@"regionId"];
    [params setValue:stageSn forKey:@"stageSn"];
    [params setValue:lockTime forKey:@"lockTime"];
    [params setValue:username forKey:@"userName"];
    [params setValue:ctrlerId forKey:@"ctrlerId"];
    [params setValue:ctrlerName forKey:@"ctrlerName"];
    [params setValue:relCrossId forKey:@"relCrossId"];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil)
        {
#warning 接口返回还没有判断。
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@", str);
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(YES);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(NO);
                });
            }
        } else {
            NSLog(@"%@", error);
            completion(NO);
            
        }
    }];
    
    [postDataTask resume];
}

+ (void)getDWLastCrossSchemeWithRoadNo:(NSString *)roadNo token:(NSString *)token completion:(void (^)(NSArray *, BOOL))completion_ {
    [TLAPI getDWStaticInfoWithToken:token roadNO:roadNo completion:^(NSString *jsonResult, BOOL finished) {
        if (finished) {
            __block NSDictionary *SIDict = [jsonResult objectFromJSONString];
            [TLAPI getDWCrossRunInfoWithRoadNo:roadNo token:token Completion:^(NSString *result, BOOL finished) {
                if (finished) {
                    NSDictionary *dict = [result objectFromJSONString];
                    NSArray *stageDict = [TLAPI getPlanNo:dict[@"planNo"] from:SIDict[@"planList"]];
                    completion_(stageDict, YES);
                } else {
                    completion_(nil, NO);
                }
            }];
        } else {
            completion_(nil, NO);
        }
    }];
}


+ (NSArray *)getPlanNo:(NSString *)planNo from:(NSArray *)planList {
    __block NSArray *dict = nil;
    [planList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *d = obj;
        NSString *pn = d[@"planNO"];
        if ([pn isEqualToString:planNo]) {
            dict = d[@"stageList"];
        }
        
    }];
    return dict;
}

@end
