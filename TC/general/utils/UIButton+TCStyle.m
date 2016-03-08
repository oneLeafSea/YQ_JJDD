//
//  UIButton+TCStyle.m
//  TC
//
//  Created by 郭志伟 on 15/11/11.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "UIButton+TCStyle.h"

@implementation UIButton (TCStyle)

- (void)setBorderStyleWithBorderColor:(UIColor *)borderColor
                       backgoundColor:(UIColor *)bgColor {
    self.layer.cornerRadius = 4.0;
    self.layer.borderWidth = 1;
    self.layer.borderColor = borderColor.CGColor;
    self.backgroundColor = bgColor;
}

@end
