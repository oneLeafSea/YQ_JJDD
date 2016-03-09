//
//  TCSignalCtrlView.h
//  TC
//
//  Created by 郭志伟 on 15/11/16.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLSignalCtrlerInfo.h"

@protocol TCSignalCtrlViewDelegate;

@interface TCSignalCtrlView : UIView

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, weak) id<TCSignalCtrlViewDelegate> delegate;

@property(nonatomic, strong) NSArray* scInfoArray;

- (void)addSignalContrller:(TLSignalCtrlerInfo *)scInfo;
- (void)removeSignalController:(TLSignalCtrlerInfo *)scInfo;


@end

@protocol TCSignalCtrlViewDelegate <NSObject>

- (void)signalCtrlViewBackToMapBtnPressed:(TCSignalCtrlView *)signalCtrlView;

- (void)signalCtrlView:(TCSignalCtrlView *)signalCtrlView didDeleteScInfo:(TLSignalCtrlerInfo *)scInfo;

- (void)signalCtrlView:(TCSignalCtrlView *)signalCtrlView requestBtnTapped:(UIButton *)btn;

@end
