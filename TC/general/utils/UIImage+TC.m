//
//  UIImage+TC.m
//  TC
//
//  Created by 郭志伟 on 15/11/16.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "UIImage+TC.h"

@implementation UIImage (TC)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)sz {
    CGRect rt = CGRectMake(0, 0, sz.width, sz.height);
    UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
    [color setFill];
    UIRectFill(rt);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
