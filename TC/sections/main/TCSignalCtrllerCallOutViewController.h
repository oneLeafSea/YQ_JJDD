//
//  TCSignalCtrllerCallOutViewController.h
//  TC
//
//  Created by 郭志伟 on 15/11/17.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>

#import "TLSignalCtrlerInfo.h"

@protocol TCSignalCtrllerCallOutViewControllerDelegate;

@interface TCSignalCtrllerCallOutViewController : UIViewController

- (instancetype)initWithGraphic:(AGSGraphic *)graphic selected:(BOOL)selected;

@property(nonatomic, strong) AGSGraphic* graphic;

@property(nonatomic, assign) BOOL selected;


@property(weak, nonatomic) id<TCSignalCtrllerCallOutViewControllerDelegate> delegate;

@end

@protocol TCSignalCtrllerCallOutViewControllerDelegate <NSObject>

- (void)signalCtrllerCallOutViewController:(TCSignalCtrllerCallOutViewController *) signalCtrllerCallOutViewController DidSelected:(BOOL)selected SignalCtrler:(TLSignalCtrlerInfo *)scInfo;

@end