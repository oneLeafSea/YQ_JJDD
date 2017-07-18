//
//  NSObject+UVObjects.h
//  AirmosPhoneIM
//
//  Created by chenjiaxin on 13-8-29.
//  Copyright (c) 2013年 Unview. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;
@interface NSObject (UVObjects)
-(MBProgressHUD*)progress:(UIView*)view_ message:(NSString*)mess;
@end
