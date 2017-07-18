//
//  RTWSMsgFactory.m
//  websocketDemo
//
//  Created by 郭志伟 on 16/2/29.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import "RTWSMsgFactory.h"
#import "RTWSMsgConstants.h"
#import "RTWSMsg.h"
#import "RTBKMsg.h"
#import "AppDelegate.h"
@implementation RTWSMsgFactory

//+ (void)handleMsg:(id)msg {
//    NSDictionary *dict = msg;
//    NSString *cont=[dict valueForKey:@"content"];
//    NSLog(@"%@",cont);
//    NSData *data=[cont dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *contentDic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil ];
//    //NSDictionary *contentDic = [dict valueForKey:@"content"];
//    NSLog(@"%@",contentDic);
//    //NSLog(@"%@",[contentDic valueForKey:@"topic"]);
//  NSArray *arr=[contentDic valueForKey:@"data"];
//    
//    if ([arr[0] objectForKey:@"topic"] == nil) {
//        NSLog(@"错误的消息。");
//        return;
//    }
//    
//    if ([[arr[0] objectForKey:@"topic"] isEqualToString:kTopicTollgatePush]) {
//        RTWSMsg *msg = [[RTWSMsg alloc] initWithDict:arr[0]];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationTollgatePush  object:msg];
//    } else {
//       // NSLog(@"未识别的消息:%@", dict);
//    }
//    //.....................................................
//    if ([[arr[0] objectForKey:@"topic"] isEqualToString:kTopicTollgateBKPush]) {
//        
//        RTBKMsg *msg = [[RTBKMsg alloc] initWithDict:arr[0]];
//        [[NSNotificationCenter defaultCenter]postNotificationName:KNotificationTOllCtrollerPush object:msg];
//        
//    }
//    else{
//        NSLog(@"未识别的消息%@",dict);
//    }
//    if ([arr[0] objectForKey:@"topic"] == nil) {
//        NSLog(@"错误的消息。");
//        return;
//    }
//    
//   if ([[arr[1] objectForKey:@"topic"] isEqualToString:kTopicTollgatePush]) {
//        RTWSMsg *msg = [[RTWSMsg alloc] initWithDict:arr[0]];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationTollgatePush  object:msg];
//    } else {
//        // NSLog(@"未识别的消息:%@", dict);
//    }
//    //.....................................................
  //  if ([[arr[1] objectForKey:@"topic"] isEqualToString:kTopicTollgateBKPush  ]) {
//        
   //     RTBKMsg *msg = [[RTBKMsg alloc] initWithDict:arr[1]];
//        [[NSNotificationCenter defaultCenter]postNotificationName:KNotificationTOllCtrollerPush object:msg];
//        
//    }
//    else{
//        NSLog(@"未识别的消息%@",dict);
//    }
//
//}
+ (void)handleMsg:(id)msg {
    NSDictionary *dict = msg;
    NSString *topic = [dict valueForKey:@"topic"];
    if (topic == nil) {
        NSLog(@"错误的消息。");
        return;
    }
    
    if ([topic isEqualToString:kTopicTollgatePush]) {
        RTWSMsg *msg = [[RTWSMsg alloc] initWithDict:dict];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationTollgatePush object:msg];
    }
   else if ([topic isEqualToString:kTopicTollgateBKPush ]) {
        RTBKMsg *msg = [[RTBKMsg alloc] initWithDict:dict];

        [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationTOllCtrollerPush object:msg];
    }
    else {
        NSLog(@"未识别的消息:%@", dict);
    }
    if ([topic isEqualToString:kTopicTollgatePush]||[topic isEqualToString:kTopicTollgateBKPush]) {
        NSInteger num = 0;
        if (APP_DELEGATE.localNoti != nil)
        {
            num = APP_DELEGATE.localNoti.applicationIconBadgeNumber;
            [[UIApplication sharedApplication] cancelLocalNotification:APP_DELEGATE.localNoti];
        }
        APP_DELEGATE.localNoti = [[UILocalNotification alloc]init];
        
        //设置本地触发时间
        APP_DELEGATE.localNoti.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
        //设置通知内容
        APP_DELEGATE.localNoti.alertBody = [NSString stringWithFormat:@"您有新的未读信息"];
        //设置本地时区
        APP_DELEGATE.localNoti.timeZone = [NSTimeZone defaultTimeZone];
        //设置提醒的声音
        APP_DELEGATE.localNoti.soundName = UILocalNotificationDefaultSoundName;
        //设置提醒个数
        APP_DELEGATE.localNoti.applicationIconBadgeNumber = num + 1;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:APP_DELEGATE.localNoti];
    }
}
@end
