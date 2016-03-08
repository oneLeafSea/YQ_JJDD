//
//  NSDate+TC.m
//  PopOverDemo
//
//  Created by 郭志伟 on 15/11/30.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "NSDate+TC.h"

@implementation NSDate (TC)

- (NSString *)ToDateMediumString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterMediumStyle;
    return [formatter stringFromDate:self];
}

@end
