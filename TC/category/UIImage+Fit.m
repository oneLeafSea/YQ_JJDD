//
//  UIImage+Fit.m
//  TC
//
//  Created by 郭志伟 on 15/10/21.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "UIImage+Fit.h"

@implementation UIImage (Fit)


+ (UIImage *)resizeImage:(NSString *)imgName {
    return [[UIImage imageNamed:imgName] resizeImage];
}

- (UIImage *)resizeImage
{
    CGFloat leftCap = self.size.width * 0.5f;
    CGFloat topCap = self.size.height * 0.5f;
    return [self stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];
}
@end
