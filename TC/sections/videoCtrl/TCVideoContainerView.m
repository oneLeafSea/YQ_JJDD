//
//  TCVideoContainerView.m
//  TC
//
//  Created by 郭志伟 on 15/11/16.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TCVideoContainerView.h"
#import "UIColor+RandomColor.h"
#import <Masonry/Masonry.h>
#import "AppDelegate.h"
#import "env.h"
#import "TCPadView.h"
#import "LogLevel.h"
#import "UVPtzCommandParam.h"
#import "UVQueryPresetListParam.h"
#import "UVPresetInfo.h"
#import "UVPresetParam.h"
#import "UIView+Toast.h"
#import "KLCPopup.h"
#import "TCPresetView.h"
#import "TCPresetViewController.h"
#import "TCNotification.h"

typedef enum tagPlayType
{
    PLAY_TYPE_LIVE=1,
    PLAY_TYPE_REPLAY,
}PLAY_TYPE_E;

/**
 * @enum  tagMwPtzCmdEnum
 * @brief 云台控制命令枚举
 * @attention
 */
typedef enum tagMwPtzCmdEnum
{
    MW_PTZ_ZOOMTELESTOP      = 0x0301,/**< 放大停止 */
    MW_PTZ_ZOOMTELE          = 0x0302,/**< 放大 */
    MW_PTZ_ZOOMWIDESTOP      = 0x0303,/**< 缩小停止 */
    MW_PTZ_ZOOMWIDE          = 0x0304,/**< 缩小 */
    
    MW_PTZ_TILTUPSTOP        = 0x0401,/**< 向上停止 */
    MW_PTZ_TILTUP            = 0x0402,/**< 向上 */
    MW_PTZ_TILTDOWNSTOP      = 0x0403,/**< 向下停止 */
    MW_PTZ_TILTDOWN          = 0x0404,/**< 向下 */
    
    MW_PTZ_PANRIGHTSTOP      = 0x0501,/**< 向右停止 */
    MW_PTZ_PANRIGHT          = 0x0502,/**< 向右 */
    MW_PTZ_PANLEFTSTOP       = 0x0503,/**< 向左停止 */
    MW_PTZ_PANLEFT           = 0x0504,/**< 向左 */
    
    MW_PTZ_LEFTUPSTOP        = 0x0701,/**< 左上停止 */
    MW_PTZ_LEFTUP            = 0x0702,/**< 左上 */
    MW_PTZ_LEFTDOWNSTOP      = 0x0703,/**< 左下停止 */
    MW_PTZ_LEFTDOWN          = 0x0704,/**< 左下 */
    
    MW_PTZ_RIGHTUPSTOP       = 0x0801,/**< 右上停止 */
    MW_PTZ_RIGHTUP           = 0x0802,/**< 右上 */
    MW_PTZ_RIGHTDOWNSTOP     = 0x0803,/**< 右下停止 */
    MW_PTZ_RIGHTDOWN         = 0x0804,/**< 右下 */
    
    MW_PTZ_ALLSTOP           = 0x0901,/**< 全停命令字 */
    
    MW_PTZ_UPTELESTOP        = 0x0411,/**< 向上放大停止 */
    MW_PTZ_UPTELE            = 0x0412,/**< 向上放大 */
    MW_PTZ_DOWNTELESTOP      = 0x0413,/**< 向下放大停止 */
    MW_PTZ_DOWNTELE          = 0x0414,/**< 向下放大 */
    
    MW_PTZ_UPWIDESTOP        = 0x0421,/**< 向上缩小停止 */
    MW_PTZ_UPWIDE            = 0x0422,/**< 向上缩小 */
    MW_PTZ_DOWNWIDESTOP      = 0x0423,/**< 向下缩小停止 */
    MW_PTZ_DOWNWIDE          = 0x0424,/**< 向下缩小 */
    
    MW_PTZ_RIGHTTELESTOP     = 0x0511,/**< 向右放大停止 */
    MW_PTZ_RIGHTTELE         = 0x0512,/**< 向右放大 */
    MW_PTZ_LEFTTELESTOP      = 0x0513,/**< 向左放大停止 */
    MW_PTZ_LEFTTELE          = 0x0514,/**< 向左放大 */
    
    MW_PTZ_RIGHTWIDESTOP     = 0x0521,/**< 向右缩小停止 */
    MW_PTZ_RIGHTWIDE         = 0x0522,/**< 向右缩小 */
    MW_PTZ_LEFTWIDESTOP      = 0x0523,/**< 向左缩小停止 */
    MW_PTZ_LEFTWIDE          = 0x0524,/**< 向左缩小 */
    
    MW_PTZ_LEFTUPTELESTOP    = 0x0711,/**< 左上放大停止 */
    MW_PTZ_LEFTUPTELE        = 0x0712,/**< 左上放大 */
    MW_PTZ_LEFTDOWNTELESTOP  = 0x0713,/**< 左下放大停止 */
    MW_PTZ_LEFTDOWNTELE      = 0x0714,/**< 左下放大 */
    
    MW_PTZ_LEFTUPWIDESTOP    = 0x0721,/**< 左上缩小停止 */
    MW_PTZ_LEFTUPWIDE        = 0x0722,/**< 左上缩小 */
    MW_PTZ_LEFTDOWNWIDESTOP  = 0x0723,/**< 左下缩小停止 */
    MW_PTZ_LEFTDOWNWIDE      = 0x0724,/**< 左下缩小 */
    
    MW_PTZ_RIGHTUPTELESTOP   = 0x0811,/**< 右上放大停止 */
    MW_PTZ_RIGHTUPTELE       = 0x0812,/**< 右上放大 */
    MW_PTZ_RIGHTDOWNTELESTOP = 0x0813,/**< 右下放大停止 */
    MW_PTZ_RIGHTDOWNTELE     = 0x0814,/**< 右下放大 */
    
    MW_PTZ_RIGHTUPWIDESTOP   = 0x0821,/**< 右上缩小停止 */
    MW_PTZ_RIGHTUPWIDE       = 0x0822,/**< 右上缩小 */
    MW_PTZ_RIGHTDOWNWIDESTOP = 0x0823,/**< 右下缩小停止 */
    MW_PTZ_RIGHTDOWNWIDE     = 0x0824,/**< 右下缩小 */
    
    MW_PTZ_CMD_BUTT
}MW_PTZ_CMD_E;


@interface TCVideoContainerView() <UVPlayerDelegate, TCPadViewDelegate> {
    PLAY_TYPE_E _playType;
    BOOL isStartPtz;
}

@property(nonatomic, strong)UVResourceInfo *currentCameralInfo;
@property(nonatomic, strong)UIActivityIndicatorView *waitView;
@property(nonatomic, strong)UVStreamPlayer *player;
@property(nonatomic, strong)UIButton *refreshBtn;
@property(nonatomic, strong)UILabel  *errLabel;
@property(nonatomic, strong)UIButton *replayBtn;
@property(nonatomic, strong)UIButton *closeBtn;
@property(nonatomic, strong)UIButton *fullScreenBtn;
@property(nonatomic, strong)UIButton *ptzBtn;
@property(nonatomic, strong)UIButton *recordBtn;
@property(nonatomic, strong)UIButton *snapBtn;
@property(nonatomic, strong)UIButton *presetBtn;
@property(nonatomic, strong)UIButton *addPresetBtn;

@property(nonatomic, assign)BOOL   hideIconBtn;

@property(nonatomic, strong)UITapGestureRecognizer *doubleTapGesture;

@property(nonatomic, strong)UITapGestureRecognizer *singleTapGesture;

@property(nonatomic, strong)TCPadView   *padView;
@property(nonatomic, assign)BOOL    error;

@end

@implementation TCVideoContainerView

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        [self setup];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationExit object:nil];
}

- (void)setup {
    [self setupConstraints];
    self.doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGuesture:)];
    self.doubleTapGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:self.doubleTapGesture];
    
    self.singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGuesture:)];
    self.singleTapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:self.singleTapGesture];
    [self.singleTapGesture requireGestureRecognizerToFail:self.doubleTapGesture];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleExit) name:kNotificationExit object:nil];
    self.hideIconBtn = YES;
    isStartPtz = NO;
}


- (void)setupConstraints {
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.waitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self.refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY).offset(2);
        make.centerX.equalTo(self);
        make.width.equalTo(@83);
        make.height.equalTo(@34);
    }];
    [self.errLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_centerY).offset(-2);
        _errLabel.numberOfLines = 0;
        make.centerX.equalTo(self);
    }];
    
    [self.padView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.replayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.right.equalTo(self).offset(-8);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.replayBtn.mas_bottom);
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-8);
    }];

    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-8);
        make.right.equalTo(self).offset(-8);
    }];
    
    [self.ptzBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-8);
        make.left.equalTo(self).offset(8);
    }];
    
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(8);
    }];
    
    [self.snapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.left.equalTo(self).offset(8);
    }];
    
    [self.presetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.centerX.equalTo(self).offset(-20);
    }];
    
    [self.addPresetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.presetBtn);
        make.left.equalTo(self.presetBtn.mas_right).offset(8);
    }];
    
}

#pragma mark getter

- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        [_imgView setContentMode:UIViewContentModeScaleToFill];
        [self addSubview:_imgView];
    }
    return _imgView;
}

- (UVStreamPlayer *)player {
    if (_player == nil) {
        _player = [[UVStreamPlayer alloc] initWithDelegate:self];
    }
    return _player;
}

- (BOOL)playing {
    return _player.isPlaying;
}

- (UIActivityIndicatorView *)waitView {
    if (_waitView == nil) {
        _waitView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _waitView.hidesWhenStopped = YES;
        [self addSubview:_waitView];
    }
    return _waitView;
}


- (UIButton *)refreshBtn {
    if (_refreshBtn == nil) {
        _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshBtn setTitle:@"点击刷新" forState:UIControlStateNormal];
        [_refreshBtn setBackgroundImage:[UIImage imageNamed:@"sc_white_btn_bg"] forState:UIControlStateNormal];
        [_refreshBtn setBackgroundImage:[UIImage imageNamed:@"sc_gray_btn_bg"] forState:UIControlStateDisabled];
        [_refreshBtn addTarget:self action:@selector(refreshBtnTapped) forControlEvents:UIControlEventTouchUpInside];
        [_refreshBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _refreshBtn.layer.cornerRadius = 8.0f;
        _refreshBtn.clipsToBounds = YES;
        _refreshBtn.hidden = YES;
        [self addSubview:_refreshBtn];
        
    }
    return _refreshBtn;
}

- (UILabel *)errLabel {
    if (_errLabel == nil) {
        _errLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _errLabel.text = @"加载视频失败！";
        _errLabel.backgroundColor = [UIColor whiteColor];
        _errLabel.hidden = YES;
        [self addSubview:_errLabel];
    }
    return _errLabel;
}

- (void)showErrorInfo:(BOOL)show {
    self.error = show;
    self.errLabel.hidden = !show;
    self.refreshBtn.hidden = !show;
    if (show) {
        self.closeBtn.hidden = !show;
    }
}

- (UIButton *)replayBtn {
    if (_replayBtn == nil) {
        _replayBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        [_replayBtn setTitle:@"回放" forState:UIControlStateNormal];
        [_replayBtn setBackgroundImage:[UIImage imageNamed:@"video_replay_btn"] forState:UIControlStateNormal];
        [_replayBtn addTarget:self action:@selector(handleReplayBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_replayBtn];
    }
    return _replayBtn;
}

- (UIButton *)closeBtn {
    if (_closeBtn == nil) {
        // video_close_btn
        _closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"video_close_btn"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(handleCloseBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeBtn];
    }
    return _closeBtn;
}

- (UIButton *)fullScreenBtn {
    if (_fullScreenBtn == nil) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        [_fullScreenBtn setTitle:@"全屏" forState:UIControlStateNormal];
        [_fullScreenBtn setBackgroundImage:[UIImage imageNamed:@"video_fullscreen_btn"] forState:UIControlStateNormal];
        [_fullScreenBtn addTarget:self action:@selector(handleFullScreenBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_fullScreenBtn];
    }
    return _fullScreenBtn;
}

- (UIButton *)ptzBtn {
    if (_ptzBtn == nil) {
        _ptzBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        [_ptzBtn setBackgroundImage:[UIImage imageNamed:@"video_fullscreen_btn"] forState:UIControlStateNormal];
        [_ptzBtn setTitle:@"云台控制" forState:UIControlStateNormal];
        [_ptzBtn addTarget:self action:@selector(handlePtzBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_ptzBtn];

    }
    return _ptzBtn;
}

- (UIButton *)recordBtn {
    if (_recordBtn == nil) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        //        [_recordBtn setBackgroundImage:[UIImage imageNamed:@"video_fullscreen_btn"] forState:UIControlStateNormal];
        [_recordBtn setTitle:@"打开录像" forState:UIControlStateNormal];
        [_recordBtn addTarget:self action:@selector(handleRecordBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_recordBtn];
    }
    return _recordBtn;
}

- (UIButton *)snapBtn {
    if (_snapBtn == nil) {
        _snapBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        //        [_snapBtn setBackgroundImage:[UIImage imageNamed:@"video_fullscreen_btn"] forState:UIControlStateNormal];
        [_snapBtn setTitle:@"抓拍" forState:UIControlStateNormal];
        [_snapBtn addTarget:self action:@selector(snapBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_snapBtn];
    }
    return _snapBtn;
}

- (UIButton *)presetBtn {
    if (_presetBtn == nil) {
        _presetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        //        [_presetBtn setBackgroundImage:[UIImage imageNamed:@"video_fullscreen_btn"] forState:UIControlStateNormal];
        [_presetBtn setTitle:@"预置位" forState:UIControlStateNormal];
        [_presetBtn addTarget:self action:@selector(presetTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_presetBtn];
    }
    return _presetBtn;
}

- (UIButton *)addPresetBtn {
    if (_addPresetBtn == nil) {
        _addPresetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        //        [_presetBtn setBackgroundImage:[UIImage imageNamed:@"video_fullscreen_btn"] forState:UIControlStateNormal];
        [_addPresetBtn setTitle:@"添加预置位" forState:UIControlStateNormal];
        [_addPresetBtn addTarget:self action:@selector(addPresetBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addPresetBtn];
    }
    return _addPresetBtn;
}

- (void)showOrHideIcons {
    if (self.player.isPlaying) {
        self.hideIconBtn = !self.hideIconBtn;
    } else {
        self.hideIconBtn = YES;
    }
}

- (TCPadView *)padView {
    if (_padView == nil) {
        _padView = [[TCPadView alloc] initWithFrame:CGRectZero];
        [self addSubview:_padView];
        _padView.backgroundColor = [UIColor clearColor];
        _padView.hidden = YES;
        _padView.delegate = self;
    }
    return _padView;
}


#pragma mark - setter
- (void)setSelected:(BOOL)selected {
    _selected = selected;
}

- (void)setHideIconBtn:(BOOL)hideIconBtn {
    _hideIconBtn = hideIconBtn;
    self.replayBtn.hidden = hideIconBtn;
    self.closeBtn.hidden = hideIconBtn;
    self.fullScreenBtn.hidden = hideIconBtn;
    self.ptzBtn.hidden = hideIconBtn;
    self.recordBtn.hidden = hideIconBtn;
    self.snapBtn.hidden = hideIconBtn;
    self.presetBtn.hidden = hideIconBtn;
    self.addPresetBtn.hidden = hideIconBtn;
}

#pragma mark -public

- (void)pause {
//    if (self.player.isPlaying) {
//        [self.player setIsPaused:YES];
//    }
    [self privateStop];
}
- (void)resume {
//    if (self.error) {
//        return;
//    }
//    if (self.player.isPaused) {
//        [self.player setIsPaused:NO];
//    }
    if (self.currentCameralInfo) {
        [self startPlay:self.currentCameralInfo];
    }
    
}

- (void)privateStop {
    if (_currentCameralInfo == nil) {
        return;
    }
    __block NSString *session = _player.playSession;
    [_player AVStopPlay];
    UVRequest *request = [UVRequest instance];
    [request execRequest:^{
        [APP_DELEGATE.tvMgr.service stopLive:session];
    } finish:^(UVError *error) {
        if (error) {
            NSLog(@"%@", error.message);
        } else {
            NSLog(@"成功");
        }
    }];
}

- (void)startPlay:(UVResourceInfo *)cameralInfo {
    _player = nil;
    UVStartLiveParam *param = [[UVStartLiveParam alloc] init];
    UVStreamInfo *streamInfo = [UVStreamInfo defaultStreamInfo];
    self.currentCameralInfo = cameralInfo;
    [param setCameraCode:cameralInfo.resCode];
    [param setUseSecondStream:YES];
    [param setStreamInfo:streamInfo];
    __block NSString *playSession = nil;
    [APP_DELEGATE.tvMgr.request execRequest:^{
        playSession = [APP_DELEGATE.tvMgr.service startLive:param withTimeOut:10.0f];
    } finish:^(UVError *error) {
        if (error != nil) {
            NSLog(@"启动实时播放失败。");
            self.errLabel.text = error.message;
            [self showErrorInfo:YES];
            [self.waitView stopAnimating];
            return;
        }
        _playType = PLAY_TYPE_LIVE;
        [self startPlayWithSession:playSession];
    } showProgressInView:self message:@""];
}

- (void)startPlayWithCamInfo:(TVCamInfo *)camInfo {
    [self.waitView startAnimating];
    _camInfo = camInfo;
#ifdef YUAN_QU_DA_DUI
    [APP_DELEGATE.tvMgr queryResourceWithKeyword:camInfo.tunnel completion:^(NSArray *resList, NSError *error) {
        if (resList.count > 0) {
            self.resource = resList[0];
            [self startPlay:self.resource];
        } else {
            self.errLabel.text = @"没有查询到摄像头资源";
            [self showErrorInfo:YES];
        }
        [self.waitView stopAnimating];
    }];
#else 
    [APP_DELEGATE.tvMgr queryResourceWithKeyword:@"" completion:^(NSArray *resList, NSError *error) {
        if (resList.count > 0) {
            self.resource = resList[5];
            [self startPlay:self.resource];
        } else {
            self.errLabel.text = @"没有查询到摄像头资源";
            [self showErrorInfo:YES];
        }
        [self.waitView stopAnimating];
    }];
#endif
}

- (void)startPlayWithSession:(NSString *)session_ {
    
    [self stopPlayWithBlock:^{
        [_player AVInitialize:self.imgView];
        NSString *str = [NSString stringWithFormat:@"tcp://%@:%d",APP_DELEGATE.tvMgr.service.info.server,APP_DELEGATE.tvMgr.service.info.mediaPort];
        NSURL  *url = [NSURL URLWithString:str];
        [_player AVStartPlay:url session:session_];
    }];
    
}

- (void)stopPlay; {
    self.currentCameralInfo = nil;
    NSString *session = _player.playSession;
    [_player AVStopPlay];
    UVRequest *request = [UVRequest instance];
    [request execRequest:^{
        [APP_DELEGATE.tvMgr.service stopLive:session];
    } finish:nil];
}

-(void)stopPlayWithBlock:(void (^)())block_ {
    [self showErrorInfo:NO];
    [self.waitView stopAnimating];
    if (self.player.isPlaying) {
        NSString *session = _player.playSession;
        void (^stopListener)(UVError*) = ^(UVError *error) {
            [_player AVStopPlay];
            //等待播放器停止
            while (_player.playStatus != PLAY_STATUS_CLOSED) {
                NSLog(@"wait player stop");
                [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
            }
            if(block_ != nil) {
                block_();
            }
        };
        if (_playType == PLAY_TYPE_LIVE) {
            NSLog(@"live playing,stop with session:%@",session);
            [APP_DELEGATE.tvMgr.request execRequest:^{
                [APP_DELEGATE.tvMgr.service stopLive:session];
            } finish:stopListener];
        } else {
            NSLog(@"replay playing,stop with session:%@",session);
            [APP_DELEGATE.tvMgr.request execRequest:^{
                [APP_DELEGATE.tvMgr.service stopReplay:session];
            } finish:stopListener];
        }
    } else {
        if(block_ != nil) {
            block_();
        }
    }
}

- (void)resetCamInfoAndResource {
    _camInfo = nil;
    _resource = nil;
}

- (void)setIsFullScreen:(BOOL)isFullScreen {
    _isFullScreen = isFullScreen;
    [self.fullScreenBtn setBackgroundImage:[UIImage imageNamed:isFullScreen ? @"video_resumescreen_btn" : @"video_fullscreen_btn"] forState:UIControlStateNormal];
}

#pragma mark -actions

- (void)refreshBtnTapped {
    [self showErrorInfo:NO];
    [self.waitView startAnimating];
    self.player = nil;
    [self startPlay:self.resource];
}

#pragma mark - UVPlayerDelegate

- (void)onPlayError:(UVPlayer*)sender_ error:(UVError*)error_ {
    DDLogError(@"%@", error_);
    [self showErrorInfo:YES];
}

- (void)onPlayStatus:(UVPlayer*)sender_ status:(PLAY_STATUS)status_ {
    if (status_ == PLAY_STATUS_OPENED) {
        [self.waitView stopAnimating];
    }
}


- (void)onRecordStatus:(UVPlayer*)sender_ status:(BOOL)status_ {
    if(status_) {
        DDLogInfo(@"已经打开录像");
        dispatch_async(dispatch_get_main_queue(), ^{
            self.recordBtn.enabled = YES;
            [self.recordBtn setTitle:@"关闭录像" forState:UIControlStateNormal];
            [self makeToast:@"已经打开录像"];
        });
    }
    else {
        DDLogInfo(@"已关闭录像");
        dispatch_async(dispatch_get_main_queue(), ^{
            self.recordBtn.enabled = YES;
            [self.recordBtn setTitle:@"打开录像" forState:UIControlStateNormal];
            [self makeToast:@"已经关闭录像"];
        });
    }
}


- (void)onMuteStatus:(UVPlayer*)sender_ status:(BOOL)status_ {
    
}

- (void)onSnatchStatus:(UVPlayer*)sender_ path:(NSURL*)path_ error:(UVError*)error_ {
    if(error_ == nil)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.snapBtn.enabled = YES;
            [self makeToast:@"抓拍成功"];
        });
        DDLogInfo(@"抓拍成功。");
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.snapBtn.enabled = YES;
            [self makeToast:[NSString stringWithFormat:@"抓拍失败：error:%@", error_.message]];
        });
        DDLogInfo(@"抓拍失败：error:%@", error_.message);
    }
}

#pragma mark - acitons
- (void)handleDoubleTapGuesture:(UITapGestureRecognizer *)guestrue {
    if ([self.delegate respondsToSelector:@selector(TCVideoContainerViewDidTapped:)]) {
        [self.delegate TCVideoContainerViewDidTapped:self];
    }
}

- (void)handleSingleTapGuesture:(UITapGestureRecognizer *)guestre {
    NSLog(@"single tapped");
    [self showOrHideIcons];
}


- (void)handleReplayBtnTapped:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(TCVideoContainerView:replayBtnDidTapped:camInfo:)]) {
        [self.delegate TCVideoContainerView:self replayBtnDidTapped:self.replayBtn camInfo:self.camInfo];
    }
}

- (void)handleCloseBtnTapped:(UIButton *)btn {
    self.hideIconBtn = YES;
    self.padView.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(TCVideoContainerView:closeBtnDidTapped:camInfo:)]) {
        [self.delegate TCVideoContainerView:self closeBtnDidTapped:btn camInfo:self.camInfo];
    }
    _camInfo = nil;
    _currentCameralInfo = nil;
}

- (void)handleFullScreenBtnTapped:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(TCVideoContainerView:FullScreenBtnDidTapped:)]) {
        [self.delegate TCVideoContainerView:self FullScreenBtnDidTapped:self.fullScreenBtn];
    }
}

- (void)handlePtzBtn:(UIButton *)btn {
    DDLogInfo(@"INFO: ptz btn tapped");
//    if (!(self.currentCameralInfo.resSubType == 2)) {
//        return;
//    }
    
    if (!isStartPtz) {
        [APP_DELEGATE.tvMgr.request execRequest:^{
            [APP_DELEGATE.tvMgr.service startCameraPtz:self.currentCameralInfo.resCode];
        }finish:^(UVError *error) {
            if (error) {
                [self makeToast:error.message];
                DDLogError(@"error:%@", error.message);
            } else {
                [self makeToast:@"启动云台控制"];
                isStartPtz = YES;
            }
            [btn setTitle:isStartPtz ? @"释放控制" : @"云台控制" forState:UIControlStateNormal];
            self.padView.hidden = !isStartPtz;
        }];
    } else {
        [APP_DELEGATE.tvMgr.request execRequest:^{
            [APP_DELEGATE.tvMgr.service stopCameraPtz:self.currentCameralInfo.resCode];
        }finish:^(UVError *error) {
            if (error) {
                [self makeToast:error.message];
                DDLogError
                (@"error:%@", error.message);
            } else {
                [self makeToast:@"停止云台控制"];
                isStartPtz = NO;
            }
            [btn setTitle:isStartPtz ? @"释放控制" : @"云台控制" forState:UIControlStateNormal];
            self.padView.hidden = !isStartPtz;
        }];
    }
    


}

- (void)handleRecordBtnTapped:(UIButton *)btn {
    if (!self.player.isPlaying) {
        return;
    }
    btn.enabled = NO;
    if (self.player.isRecording) {
        [self.player stopRecord];
        return;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *tmpDir = NSTemporaryDirectory();
    
    NSDate *now = [NSDate date];
   
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMddHHmmss"];
     NSString *dateStr = [format stringFromDate:now];
    NSString *fileName = [NSString stringWithFormat:@"%@.mpg", dateStr];
    
    NSString *filePath = [tmpDir stringByAppendingPathComponent:fileName];
    NSLog(@"%@", filePath);
    
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    NSURL *URL = [NSURL fileURLWithPath:filePath];
    
    [_player startRecord:URL];
}

- (void)snapBtnTapped:(UIButton *)btn {
    if (!self.player.isPlaying) {
        return;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *tmpDir = NSTemporaryDirectory();
    
    NSDate *now = [NSDate date];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateStr = [format stringFromDate:now];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", dateStr];
    
    NSString *filePath = [tmpDir stringByAppendingPathComponent:fileName];
    NSLog(@"%@", filePath);
    
    if (![fileManager fileExistsAtPath:filePath]) {
        
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        
    }
    NSURL *URL = [NSURL fileURLWithPath:filePath];
    [_player snatch:URL];
}

- (void)presetTapped:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(TCVideoContainerView:presetDidTapped:)]) {
        [self.delegate TCVideoContainerView:self presetDidTapped:btn];
    }
}

- (void)addPresetBtnTapped:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(TCVideoContainerView:addPresetDidTapped:)]) {
        [self.delegate TCVideoContainerView:self addPresetDidTapped:btn];
    }
}


- (void)queryPreset {
    [APP_DELEGATE.tvMgr.request execRequest:^{
        UVQueryCondition *condition = [[UVQueryCondition alloc] init];
        [condition setIsQuerySub:YES];
        [condition setOffset:0];
        [condition setLimit:20];
        UVQueryPresetListParam *param = [[UVQueryPresetListParam alloc] init];
        [param setCameraCode:self.currentCameralInfo.resCode];
        [param setPageInfo:condition];
        NSArray *presetList = [APP_DELEGATE.tvMgr.service cameraQueryPresetList:param];
        DDLogInfo(@"%@", presetList);
    }finish:^(UVError *error) {
    }];
}

- (void)addPreset:(NSString *)desc {
    [APP_DELEGATE.tvMgr.request execRequest:^{
        UVPresetInfo *info = [[UVPresetInfo alloc] init];
        [info setPresetValue:1];
        [info setPresetDesc:desc];
        [APP_DELEGATE.tvMgr.service cameraSetPreset:self.currentCameralInfo.resCode presetInfo:info];
    }finish:^(UVError *error) {
        if (error) {
            [self makeToast:error.message];
        }
        else {
            NSLog(@"set preset success");
            [self makeToast:@"设置预置位成功"];
        }
    }];
}

- (void)delPreset:(UVPresetInfo *)presetInfo {
    UVPresetParam *param = [[UVPresetParam alloc] init];
    param.presetValue = presetInfo.presetValue;
    param.cameraCode = self.currentCameralInfo.resCode;
    [APP_DELEGATE.tvMgr.request execRequest:^{
        [APP_DELEGATE.tvMgr.service cameraDelPreset:param];
    }finish:^(UVError *error) {
//        [self.presetList removeObjectAtIndex:row_];
//        [self.tableList reloadData];
    }];
}

#pragma mark - padView delegate

- (void)TCPad:(TCPadView *)pad didPressDirection:(TCPadDirection)direction {
    DDLogInfo(@"direction: %lu", (unsigned long)direction);
    UVPtzCommandParam *param = [[UVPtzCommandParam alloc] init];
    param.cameraCode = self.currentCameralInfo.resCode;
    NSString *str = @"停止成功";
   
    switch (direction) {
        case TCPadDirectionUpLeft:
            param.direction = MW_PTZ_LEFTUP;
            param.speed1 = 3.0f;
            param.speed2 = 3.0f;
            str = @"左上";
            break;
        case TCPadDirectionUp:
            param.direction = MW_PTZ_TILTUP;
            param.speed1 = 0.0f;
            param.speed2 = 3.0f;
            str = @"上";
            break;
        case TCPadDirectionUpRight:
            param.direction = MW_PTZ_RIGHTUP;
            param.speed1 = 3.0f;
            param.speed2 = 3.0f;
            str = @"右上";
            break;
        case TCPadDirectionRight:
            param.direction = MW_PTZ_PANRIGHT;
            param.speed1 = 3.0f;
            param.speed2 = 0.0f;
            str = @"右";
            break;
        case TCPadDirectionDownRight:
            param.direction = MW_PTZ_RIGHTDOWN;
            param.speed1 = 3.0f;
            param.speed2 = 3.0f;
            str = @"右下";
            break;
        case TCPadDirectionDown:
            param.direction = MW_PTZ_TILTDOWN;
            param.speed1 = 0.0f;
            param.speed2 = 3.0f;
            str = @"下";
            break;
        case TCPadDirectionDownLeft:
            param.direction = MW_PTZ_LEFTDOWN;
            param.speed1 = 3.0f;
            param.speed2 = 3.0f;
            str = @"左下";
            break;
        case TCPadDirectionLeft:
            param.direction = MW_PTZ_PANLEFT;
            param.speed1 = 3.0f;
            param.speed2 = 0.0f;
            str = @"左";
            break;
        case TCPadDirectionNone:
            param.direction = MW_PTZ_ALLSTOP;
            param.speed1 = 0.0f;
            param.speed2 = 0.0f;
            break;
            
        default:
            break;
    }
    
    [APP_DELEGATE.tvMgr.request execRequest:^{
        [APP_DELEGATE.tvMgr.service cameraPtzCommand:param];
    }finish:^(UVError *error) {
        if (error) {
            [self makeToast:error.message];
            DDLogError(@"error:%@", error.message);
            return;
        }
//        [self makeToast:str];
        DDLogInfo(@"%@", str);
    }];
}

- (void)TCPadDidReleaseDirection:(TCPadView *)pad {
    DDLogInfo(@"pad release");
    UVPtzCommandParam *param = [[UVPtzCommandParam alloc] init];
    param.cameraCode = self.currentCameralInfo.resCode;
    param.direction = MW_PTZ_ALLSTOP;
    param.speed1 = 0.0f;
    param.speed2 = 0.0f;
    [APP_DELEGATE.tvMgr.request execRequest:^{
        [APP_DELEGATE.tvMgr.service cameraPtzCommand:param];
    }finish:^(UVError *error) {
        if (error) {
            [self makeToast:error.message];
            DDLogError(@"error:%@", error.message);
            return;
        }
//        [self makeToast:@"停止成功"];
    }];
}

- (void)TCPad:(TCPadView *)pad didZoom:(TCPadZoom)zoom {
    if (zoom == TCPadZoomIn) {
        UVPtzCommandParam *param = [[UVPtzCommandParam alloc] init];
        param.cameraCode = self.currentCameralInfo.resCode;
        param.direction = MW_PTZ_ZOOMTELE;
        param.speed1 = 3.0f;
        param.speed2 = 0.0f;
        
        [APP_DELEGATE.tvMgr.request execRequest:^{
            [APP_DELEGATE.tvMgr.service cameraPtzCommand:param];
        }finish:^(UVError *error) {
            if (error) {
                [self makeToast:error.message];
                DDLogError(@"error:%@", error.message);
                return;
            }
//            [self makeToast:@"放大"];
        }];
    } else if (zoom == TCPadZoomOut) {
        UVPtzCommandParam *param = [[UVPtzCommandParam alloc] init];
        param.cameraCode = self.currentCameralInfo.resCode;
        param.direction = MW_PTZ_ZOOMWIDE;
        param.speed1 = 3.0f;
        param.speed2 = 0.0f;
        
        [APP_DELEGATE.tvMgr.request execRequest:^{
            [APP_DELEGATE.tvMgr.service cameraPtzCommand:param];
        }finish:^(UVError *error) {
            if (error) {
                [self makeToast:error.message];
                DDLogError(@"error:%@", error.message);
                return;
            }
//            [self makeToast:@"缩小"];
        }];
    }
}

- (void)TCPadReleaseZoom:(TCPadView *)pad {
    UVPtzCommandParam *param = [[UVPtzCommandParam alloc] init];
    param.cameraCode = self.currentCameralInfo.resCode;
    param.direction = MW_PTZ_ALLSTOP;
    param.speed1 = 0.0f;
    param.speed2 = 0.0f;
    [APP_DELEGATE.tvMgr.request execRequest:^{
        [APP_DELEGATE.tvMgr.service cameraPtzCommand:param];
    }finish:^(UVError *error) {
        if (error) {
            [self makeToast:error.message];
            DDLogError(@"error:%@", error.message);
            return;
        }
//        [self makeToast:@"停止成功"];
    }];
}

- (void)handleExit {
    [self stopPlay];
}


@end
