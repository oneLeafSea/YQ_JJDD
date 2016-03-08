//
//  TCReplayContainerView.h
//  TC
//
//  Created by 郭志伟 on 15/12/3.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVCamInfo.h"
#import "AppDelegate.h"

@protocol TCReplayContainerViewDelegage;

@interface TCReplayContainerView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                   cameraInfo:(TVCamInfo *)cameraInfo;

@property(nonatomic, strong)TVCamInfo *cameraInfo;
@property(nonatomic, strong)UVResourceInfo *currentCameralInfo;

@property(nonatomic, strong)UIViewController *parentVC;

@property(nonatomic, weak) id<TCReplayContainerViewDelegage> delegate;

@end

@protocol TCReplayContainerViewDelegage <NSObject>

- (void)TCReplayContainerViewCloseBtnDidTapped:(TCReplayContainerView *)replayView;

@end
