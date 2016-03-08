//
//  TCSignalCtrlHeadView.h
//  TC
//
//  Created by 郭志伟 on 15/11/18.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCSignalCtrlHeadViewDelegate;

@interface TCSignalCtrlHeadView : UIView


- (instancetype)initWithSignalCtrlerName:(NSString *)name;

- (instancetype)initWithFrame:(CGRect)frame ctrlerName:(NSString *)name;

- (instancetype)initWithFrame:(CGRect)frame ctrlerName:(NSString *)name selected:(BOOL)selected;

@property(nonatomic, assign)BOOL selected;
@property(nonatomic, copy) NSString *ctrlerName;
@property(nonatomic, weak) id<TCSignalCtrlHeadViewDelegate> delegate;
@property(nonatomic, copy) NSString *ctrlerId;

@end

@protocol TCSignalCtrlHeadViewDelegate <NSObject>

- (void)TCSignalCtrlHeadView:(TCSignalCtrlHeadView *)headView didSelected:(BOOL)selected;

@end