//
//  TCVideoContainerView.h
//  TC
//
//  Created by 郭志伟 on 15/11/16.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AirIMOSIphoneSDK.h"
#import "TVCamInfo.h"
#import "TCSnapViewViewController.h"
#import "TCMapViewController.h"
#import "TVElecPoliceInfo.h"
#import <AssetsLibrary/AssetsLibrary.h>
@protocol TCVideoContainerViewDelegate;
@interface TCVideoContainerView : UIView

@property(nonatomic, strong) UIImageView    *imgView;

@property(nonatomic, readonly) TVCamInfo *camInfo;
@property(nonatomic, strong) UVResourceInfo *resource;
@property(nonatomic, strong)UIButton *ptzBtn;
@property(nonatomic, strong)UIButton *presetBtn;
@property(nonatomic, strong)UIButton *addPresetBtn;

- (void)resetCamInfoAndResource;

- (void)startPlay:(UVResourceInfo *)cameralInfo;
- (void)startPlayWithCamInfo:(TVCamInfo *)camInfo;
- (void)stopPlay;
- (void)stopPlayWithBlock:(void (^)())block;

- (void)pause;
- (void)resume;

@property(nonatomic, readonly) BOOL playing;
@property(nonatomic, assign) BOOL isFullScreen;

@property(nonatomic, weak) id<TCVideoContainerViewDelegate> delegate;

@property(nonatomic, assign)BOOL selected;

@property(nonatomic, strong)UIViewController *presentViewController;
@property(nonatomic,assign)int padding;
@end

@protocol TCVideoContainerViewDelegate <NSObject>

- (void)TCVideoContainerViewDidTapped:(TCVideoContainerView *)containerView;
- (void)TCVideoContainerView:(TCVideoContainerView *)containerView replayBtnDidTapped:(UIButton *)replayBtn
                     camInfo:(TVCamInfo *)camInfo;
- (void)TCVideoContainerView:(TCVideoContainerView *)containerView closeBtnDidTapped:(UIButton *)replayBtn camInfo:(TVCamInfo *)camInfo;
- (void)TCVideoContainerView:(TCVideoContainerView *)containerView FullScreenBtnDidTapped:(UIButton *)fullScreenBtn;
- (void)TCVideoContainerView:(TCVideoContainerView *)containerView presetDidTapped:(UIButton *)presetBtn;
- (void)TCVideoContainerView:(TCVideoContainerView *)containerView addPresetDidTapped:(UIButton *)presetBtn;
-(void)TCVideoContainerView:(TCVideoContainerView *)containerView snapViewDidTaped:(UIButton*)button;
-(void)TCVideoContainerView:(TCVideoContainerView*)containnerView closeRecordBtnDidTaped:(UIButton *)button;
@end
