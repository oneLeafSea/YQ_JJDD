//
//  UIView+TC.m
//  TC
//
//  Created by 郭志伟 on 15/11/12.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "UIView+TC.h"

@implementation UIView (TC)

- (void)makeRounded {
    self.layer.cornerRadius = self.bounds.size.width / 2.0;
    self.clipsToBounds = YES;
}

@end
