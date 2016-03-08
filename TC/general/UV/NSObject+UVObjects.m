//
//  NSObject+UVObjects.m
//  AirmosPhoneIM
//
//  Created by chenjiaxin on 13-8-29.
//  Copyright (c) 2013年 Unview. All rights reserved.
//

#import "NSObject+UVObjects.h"
#import "MBProgressHUD.h"

@implementation NSObject (UVObjects)

-(MBProgressHUD*)progress:(UIView *)view_ message:(NSString *)mess_
{
    if(!view_)
    {
        return nil;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view_ animated:YES];
    
	hud.mode = MBProgressHUDModeText;
	hud.labelText = mess_;
    
	hud.removeFromSuperViewOnHide = YES;
    return hud;
}
@end
