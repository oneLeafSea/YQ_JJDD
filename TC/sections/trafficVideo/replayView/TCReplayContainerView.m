//
//  TCReplayContainerView.m
//  TC
//
//  Created by 郭志伟 on 15/12/3.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TCReplayContainerView.h"
#import "UIColor+Hexadecimal.h"
#import "RMDateSelectionViewController.h"
#import "NSDate+TC.h"
#import <Masonry/Masonry.h>
#import "UVUtils.h"
#import "UIView+Toast.h"

typedef enum tagPlayType
{
    PLAY_TYPE_LIVE=1,
    PLAY_TYPE_REPLAY,
}PLAY_TYPE_E;

@interface TCReplayContainerView() <UVPlayerDelegate, UIAlertViewDelegate> {
    PLAY_TYPE_E _playType;
    NSString *_playSession;
}

@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, strong)UISlider    *slider;
@property(nonatomic, strong)UIButton    *playOrPauseBtn;
@property(nonatomic, strong)UIButton    *stopBtn;


@property(nonatomic, strong)UILabel     *nameLabel;
@property(nonatomic, strong)UILabel     *nameValueLabel;
@property(nonatomic, strong)UILabel     *startTmLabel;
@property(nonatomic, strong)UIButton    *startTmBtn;

@property(nonatomic, strong)UILabel     *endTmLabel;
@property(nonatomic, strong)UIButton    *endTmBtn;
@property(nonatomic, strong)UIButton    *selectTmBtn;
@property(nonatomic, strong)UIButton    *closeBtn;

@property(nonatomic, strong)UIActivityIndicatorView *waitView;

@property(nonatomic, strong)UVStreamPlayer *player;

@property(nonatomic, strong)NSArray *recordList;


@property(nonatomic, copy)NSString *startTm;
@property(nonatomic, copy)NSString *endTm;

@property(nonatomic, strong)NSDate *startDate;
@property(nonatomic, strong)NSDate *endDate;

@property(nonatomic, assign)NSTimeInterval interval;
@property(nonatomic, strong)UILabel  *sliderTipLabel;

@end

@implementation TCReplayContainerView

- (instancetype)initWithFrame:(CGRect)frame
                   cameraInfo:(TVCamInfo *)cameraInfo {
    if ([self initWithFrame:frame]) {
        _cameraInfo = cameraInfo;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor colorWithHex:@"#343551"];
    [self setupConstraints];
}

- (void)setupConstraints {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(24);
        make.left.equalTo(self).offset(24);
        make.right.equalTo(self).offset(-24);
        make.bottom.equalTo(self).offset(-54);
    }];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(65);
        make.right.equalTo(self).offset(-165);
        make.bottom.equalTo(self.imageView).offset(-20);
    }];
    
    [self.playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.slider);
        make.left.equalTo(self.slider.mas_right).offset(18);
    }];
    
    [self.stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.slider);
        make.left.equalTo(self.playOrPauseBtn.mas_right).offset(18);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(36);
        make.bottom.equalTo(self).offset(-20);
    }];
    
    [self.nameValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(18);
        make.bottom.equalTo(self.nameLabel);
    }];
    
    [self.startTmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameValueLabel.mas_right).offset(18);
        make.bottom.equalTo(self.nameValueLabel);
    }];
    [self.startTmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startTmLabel.mas_right).offset(14);
        make.centerY.equalTo(self.startTmLabel);
        make.width.equalTo(@210);
    }];
    
    [self.endTmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startTmBtn.mas_right).offset(14);
        make.centerY.equalTo(self.startTmBtn);
    }];
    [self.endTmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.endTmLabel.mas_right).offset(14);
        make.centerY.equalTo(self.endTmLabel);
        make.width.equalTo(@210);
    }];
    
    [self.selectTmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.endTmBtn.mas_right).offset(26);
        make.centerY.equalTo(self.endTmBtn);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectTmBtn.mas_right).offset(26);
        make.centerY.equalTo(self.selectTmBtn);
    }];
    
    [self.waitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.imageView);
    }];
    
    [self.sliderTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.imageView);
    }];
}


#pragma mark - getter

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        _imageView.backgroundColor = [UIColor blackColor];
        [_imageView setContentMode:UIViewContentModeScaleToFill];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UISlider *)slider {
    if (_slider == nil) {
        _slider = [[UISlider alloc] initWithFrame:CGRectZero];
        _slider.minimumTrackTintColor = [UIColor whiteColor];
        _slider.maximumTrackTintColor = [UIColor colorWithHex:@"#343551"];
        [_slider addTarget:self action:@selector(handleSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(handleSliderSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_slider];
    }
    return _slider;
}

- (UIButton *)playOrPauseBtn {
    if (_playOrPauseBtn == nil) {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_playOrPauseBtn setBackgroundImage:[UIImage imageNamed:@"replay_play_btn"] forState:UIControlStateNormal];
        [_playOrPauseBtn addTarget:self action:@selector(handlePlayBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_playOrPauseBtn];
    }
    return _playOrPauseBtn;
}

- (UIButton *)stopBtn {
    if (_stopBtn == nil) {
        _stopBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_stopBtn setBackgroundImage:[UIImage imageNamed:@"replay_stop_btn"] forState:UIControlStateNormal];
        [_stopBtn addTarget:self action:@selector(handleStopBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_stopBtn];
    }
    return _stopBtn;
}



- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_nameLabel];
        _nameLabel.text = @"摄像头名称";
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}

- (UILabel *)nameValueLabel {
    if (_nameValueLabel == nil) {
        _nameValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_nameValueLabel];
        _nameValueLabel.text = self.cameraInfo.deviceNam;
        _nameValueLabel.textColor = [UIColor whiteColor];
    }
    return _nameValueLabel;
}

- (UILabel *)startTmLabel {
    if (_startTmLabel == nil) {
        _startTmLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _startTmLabel.textColor = [UIColor whiteColor];
        _startTmLabel.text = @"开始时间";
        [self addSubview:_startTmLabel];
    }
    return _startTmLabel;
}

- (UIButton *)startTmBtn {
    if (_startTmBtn == nil) {
        _startTmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        [_startTmBtn setTitle:@"开始时间" forState:UIControlStateNormal];
        NSDate *in15Min = [NSDate dateWithTimeIntervalSinceNow:-15*60];
        [_startTmBtn setTitle:[in15Min ToDateMediumString] forState:UIControlStateNormal];
        _startTm = [UVUtils stringFromTime:in15Min];
        _startDate = in15Min;
        _startTmBtn.layer.borderWidth = 1.0;
        _startTmBtn.clipsToBounds = YES;
        _startTmBtn.layer.cornerRadius = 5.0f;
        _startTmBtn.layer.borderColor = [UIColor colorWithHex:@"#afafaf"].CGColor;
        _startTmBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _startTmBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 7.0, 0, 0);
        [_startTmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_startTmBtn addTarget:self action:@selector(handleStartTmBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_startTmBtn];
    }
    return _startTmBtn;
}

- (UILabel *)endTmLabel {
    if (_endTmLabel == nil) {
        _endTmLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _endTmLabel.textColor = [UIColor whiteColor];
        _endTmLabel.text = @"结束时间";
        [self addSubview:_endTmLabel];
    }
    return _endTmLabel;
}

- (UIButton *)endTmBtn {
    if (_endTmBtn == nil) {
        _endTmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_endTmBtn setTitle:@"结束时间" forState:UIControlStateNormal];
        NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
        [_endTmBtn setTitle:[now ToDateMediumString] forState:UIControlStateNormal];
        _endTm = [UVUtils stringFromTime:now];
        _endDate = now;
        _endTmBtn.layer.borderWidth = 1.0;
        _endTmBtn.clipsToBounds = YES;
        _endTmBtn.layer.cornerRadius = 5.0f;
        _endTmBtn.layer.borderColor = [UIColor colorWithHex:@"#afafaf"].CGColor;
        _endTmBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _endTmBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 7.0, 0, 0);
        [_endTmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_endTmBtn addTarget:self action:@selector(handleEndTmBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_endTmBtn];
    }
    return _endTmBtn;
}

- (UIButton *)closeBtn {
    if (_closeBtn == nil) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:_closeBtn];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"relplay_close_btn"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(handleCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)selectTmBtn {
    if (_selectTmBtn == nil) {
        _selectTmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:_selectTmBtn];
        [_selectTmBtn setBackgroundImage:[UIImage imageNamed:@"replay_select_btn"] forState:UIControlStateNormal];
        [_selectTmBtn addTarget:self action:@selector(handleSelectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectTmBtn;
}

- (UVStreamPlayer *)player {
    if (_player == nil) {
        _player = [[UVStreamPlayer alloc] initWithDelegate:self];
    }
    return _player;
}

- (UIActivityIndicatorView *)waitView {
    if (_waitView == nil) {
        _waitView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _waitView.hidesWhenStopped = YES;
        [self addSubview:_waitView];
    }
    return _waitView;
}

- (UILabel *)sliderTipLabel {
    if (_sliderTipLabel == nil) {
        _sliderTipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_sliderTipLabel];
        _sliderTipLabel.hidden = YES;
    }
    return _sliderTipLabel;
}


#pragma mark - actions
- (void)handlePlayBtnTapped:(UIButton *)btn {
    
    [self.player setIsPaused:!self.player.isPaused];
    [self.playOrPauseBtn setBackgroundImage:[UIImage imageNamed:self.player.isPaused ? @"replay_play_btn" :@"replay_pause_btn"] forState:UIControlStateNormal];
    
}

- (void)handleStopBtnTapped:(UIButton *)btn {
    [self stopPlayWithBlock:nil];
}

- (void)handleStartTmBtnTapped:(UIButton *)btn {
    RMActionControllerStyle style = RMActionControllerStyleWhite;
    RMAction<RMActionController<UIDatePicker *> *> *selectAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"选择" style:RMActionStyleDone andHandler:^(RMActionController<UIDatePicker *> *controller) {
        NSLog(@"Successfully selected date: %@", controller.contentView.date);
        
        [self.startTmBtn setTitle:[controller.contentView.date ToDateMediumString] forState:UIControlStateNormal];
        self.startTm = [UVUtils stringFromTime:controller.contentView.date];
        self.startDate = controller.contentView.date;
    }];
    
    RMAction<RMActionController<UIDatePicker *> *> *cancelAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"取消" style:RMActionStyleCancel andHandler:^(RMActionController<UIDatePicker *> *controller) {
        NSLog(@"Date selection was canceled");
    }];
    
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:style];
    dateSelectionController.title = @"请选择开始时间";
    [dateSelectionController addAction:selectAction];
    [dateSelectionController addAction:cancelAction];
    
    RMAction<RMActionController<UIDatePicker *> *> *in15MinAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"15分前" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> *controller) {
        controller.contentView.date = [NSDate dateWithTimeIntervalSinceNow:-15*60];
        NSLog(@"15 Min button tapped");
    }];
    in15MinAction.dismissesActionController = NO;
    
    RMAction<RMActionController<UIDatePicker *> *> *in30MinAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"30分前" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> *controller) {
        controller.contentView.date = [NSDate dateWithTimeIntervalSinceNow:-30*60];
        NSLog(@"30 Min button tapped");
    }];
    in30MinAction.dismissesActionController = NO;
    
    RMAction<RMActionController<UIDatePicker *> *> *in45MinAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"45分前" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> *controller) {
        controller.contentView.date = [NSDate dateWithTimeIntervalSinceNow:-45*60];
        NSLog(@"45 Min button tapped");
    }];
    in45MinAction.dismissesActionController = NO;
    
    RMAction<RMActionController<UIDatePicker *> *> *in60MinAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"60分前" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> *controller) {
        controller.contentView.date = [NSDate dateWithTimeIntervalSinceNow:-60*60];
        NSLog(@"60 Min button tapped");
    }];
    in60MinAction.dismissesActionController = NO;
    
    RMGroupedAction<RMActionController<UIDatePicker *> *> *groupedAction = [RMGroupedAction<RMActionController<UIDatePicker *> *> actionWithStyle:RMActionStyleAdditional andActions:@[in15MinAction, in30MinAction, in45MinAction, in60MinAction]];
    
    [dateSelectionController addAction:groupedAction];
    
    RMAction<RMActionController<UIDatePicker *> *> *nowAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"现在" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> * _Nonnull controller) {
        controller.contentView.date = [NSDate date];
        NSLog(@"Now button tapped");
    }];
    nowAction.dismissesActionController = NO;
    [dateSelectionController addAction:nowAction];
    
    dateSelectionController.disableBouncingEffects = YES;
    dateSelectionController.disableMotionEffects = YES;
    dateSelectionController.disableBlurEffects = YES;
    
    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    dateSelectionController.datePicker.minuteInterval = 1;
    dateSelectionController.datePicker.date = [NSDate date];
    
    if([dateSelectionController respondsToSelector:@selector(popoverPresentationController)] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        //First we set the modal presentation style to the popover style
        dateSelectionController.modalPresentationStyle = UIModalPresentationPopover;
        
        //Then we tell the popover presentation controller, where the popover should appear
        dateSelectionController.popoverPresentationController.sourceView = self;
        UIButton *button = btn;
        dateSelectionController.popoverPresentationController.sourceRect = button.frame;
    }
    [self.parentVC presentViewController:dateSelectionController animated:YES completion:nil];

}

- (void)handleEndTmBtnTapped:(UIButton *)btn {
    RMActionControllerStyle style = RMActionControllerStyleWhite;
    RMAction<RMActionController<UIDatePicker *> *> *selectAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"选择" style:RMActionStyleDone andHandler:^(RMActionController<UIDatePicker *> *controller) {
        NSLog(@"Successfully selected date: %@", controller.contentView.date);
        
        [self.endTmBtn setTitle:[controller.contentView.date ToDateMediumString] forState:UIControlStateNormal];
        self.endDate = controller.contentView.date;
        self.endTm = [UVUtils stringFromTime:controller.contentView.date];
    }];
    
    RMAction<RMActionController<UIDatePicker *> *> *cancelAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"取消" style:RMActionStyleCancel andHandler:^(RMActionController<UIDatePicker *> *controller) {
        NSLog(@"Date selection was canceled");
    }];
    
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:style];
    dateSelectionController.title = @"请选择结束时间";
    //    dateSelectionController.message = @"请选择开始时间";
    [dateSelectionController addAction:selectAction];
    [dateSelectionController addAction:cancelAction];
    
    RMAction<RMActionController<UIDatePicker *> *> *in15MinAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"15分前" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> *controller) {
        controller.contentView.date = [NSDate dateWithTimeIntervalSinceNow:-15*60];
        NSLog(@"15 Min button tapped");
    }];
    in15MinAction.dismissesActionController = NO;
    
    RMAction<RMActionController<UIDatePicker *> *> *in30MinAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"30分前" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> *controller) {
        controller.contentView.date = [NSDate dateWithTimeIntervalSinceNow:-30*60];
        NSLog(@"30 Min button tapped");
    }];
    in30MinAction.dismissesActionController = NO;
    
    RMAction<RMActionController<UIDatePicker *> *> *in45MinAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"45分前" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> *controller) {
        controller.contentView.date = [NSDate dateWithTimeIntervalSinceNow:-45*60];
        NSLog(@"45 Min button tapped");
    }];
    in45MinAction.dismissesActionController = NO;
    
    RMAction<RMActionController<UIDatePicker *> *> *in60MinAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"60分前" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> *controller) {
        controller.contentView.date = [NSDate dateWithTimeIntervalSinceNow:-60*60];
        NSLog(@"60 Min button tapped");
    }];
    in60MinAction.dismissesActionController = NO;
    
    RMGroupedAction<RMActionController<UIDatePicker *> *> *groupedAction = [RMGroupedAction<RMActionController<UIDatePicker *> *> actionWithStyle:RMActionStyleAdditional andActions:@[in15MinAction, in30MinAction, in45MinAction, in60MinAction]];
    
    [dateSelectionController addAction:groupedAction];
    
    RMAction<RMActionController<UIDatePicker *> *> *nowAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"现在" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> * _Nonnull controller) {
        controller.contentView.date = [NSDate date];
        NSLog(@"Now button tapped");
    }];
    nowAction.dismissesActionController = NO;
    [dateSelectionController addAction:nowAction];
    
    dateSelectionController.disableBouncingEffects = YES;
    dateSelectionController.disableMotionEffects = YES;
    dateSelectionController.disableBlurEffects = YES;
    
    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    dateSelectionController.datePicker.minuteInterval = 1;
    dateSelectionController.datePicker.date = [NSDate date];
    
    if([dateSelectionController respondsToSelector:@selector(popoverPresentationController)] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        //First we set the modal presentation style to the popover style
        dateSelectionController.modalPresentationStyle = UIModalPresentationPopover;
        
        //Then we tell the popover presentation controller, where the popover should appear
        dateSelectionController.popoverPresentationController.sourceView = self;
        UIButton *button = btn;
        dateSelectionController.popoverPresentationController.sourceRect = button.frame;
        dateSelectionController.view.tintColor = [UIColor blackColor];
    }
    [self.parentVC presentViewController:dateSelectionController animated:YES completion:nil];
}

- (void)handleSelectedBtn:(UIButton *)btn {
    [self startReplay];
}

- (void)handleCloseBtn:(UIButton *)btn {
    if (self.player.isPlaying) {
        [self stopPlayWithBlock:^{
            self.selectTmBtn.enabled = YES;
            if ([self.delegate respondsToSelector:@selector(TCReplayContainerViewCloseBtnDidTapped:)]) {
                [self.delegate TCReplayContainerViewCloseBtnDidTapped:self];
            }
        }];
    } else {
        self.selectTmBtn.enabled = YES;
        if ([self.delegate respondsToSelector:@selector(TCReplayContainerViewCloseBtnDidTapped:)]) {
            [self.delegate TCReplayContainerViewCloseBtnDidTapped:self];
        }
    }
}

- (void)handleSliderValueChanged:(UISlider *)slider {
//    NSLog(@"%f", slider.value);
    float v = slider.value;
    NSTimeInterval i = v * self.interval;
    NSDate *d = [NSDate dateWithTimeInterval:i sinceDate:self.startDate];
    NSString *strD = [UVUtils stringFromTime:d];
    self.sliderTipLabel.hidden = NO;
    self.sliderTipLabel.text = strD;
    [self.sliderTipLabel sizeToFit];
    
//    [self makeToast:strD duration:0.5 position:CSToastPositionCenter];
}

- (void)handleSliderSelected:(UISlider *)slider {
    self.sliderTipLabel.hidden = YES;
    float v = slider.value;
    NSTimeInterval i = v * self.interval;
    NSDate *d = [NSDate dateWithTimeInterval:i sinceDate:self.startDate];
    NSString *strD = [UVUtils stringFromTime:d];
    
    [APP_DELEGATE.tvMgr.request execRequest:^{
        [APP_DELEGATE.tvMgr.service dragReplay:_playSession playDatetime:strD];
    } finish:nil];
}

#pragma mark - play

- (void)startReplay {
    [self.waitView startAnimating];
    self.selectTmBtn.enabled = NO;
    NSString *starttime = self.startTm;
    NSString *endtime = self.endTm;
    self.interval = [self.endDate timeIntervalSinceDate:self.startDate];
    if(_currentCameralInfo == nil)
    {
        return;
    }
    UVQueryCondition *condition = [[UVQueryCondition alloc] init];
    [condition setOffset:0];
    [condition setLimit:10];
    [condition setIsQuerySub:NO];
    
    UVQueryReplayParam *queryparam = [[UVQueryReplayParam alloc] init];
    [queryparam setBeginTime:starttime];
    [queryparam setEndTime:endtime];
    
    [queryparam setCameraCode:_currentCameralInfo.resCode];
    [queryparam setQueryCondition:condition];
    
    __block NSArray *recordList = nil;
    [APP_DELEGATE.tvMgr.request execRequest:^{
        recordList = [APP_DELEGATE.tvMgr.service queryReplay:queryparam];
    } finish:^(UVError *error) {
        if(error != nil) {
            NSLog(@"查询错误.");
            self.selectTmBtn.enabled = YES;
            return;
        }
        if(recordList.count == 0)
        {
            self.selectTmBtn.enabled = YES;
            return;
        }
        self.recordList = recordList;
        if (recordList.count == 1) {
            UVRecordInfo *info = (UVRecordInfo*)recordList.firstObject;
            UVStreamInfo *streaminfo = [UVStreamInfo defaultStreamInfo];
            UVStartReplayParam *param = [[UVStartReplayParam alloc] init];
            [param setCameraCode:_currentCameralInfo.resCode];
            [param setStreamInfo:streaminfo];
            [param setRecordInfo:info];
            
//            __block NSString *playSession = nil;
            _playSession = nil;
            [APP_DELEGATE.tvMgr.request execRequest:^{
                _playSession = [APP_DELEGATE.tvMgr.service startReplay:param];
            } finish:^(UVError *error) {
                if(error != nil)return;
                [self startPlayWithSession:_playSession];
                _playType = PLAY_TYPE_REPLAY;
            }];
        } else {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"选择时间段" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [recordList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UVRecordInfo *info = obj;
                [av addButtonWithTitle:[NSString stringWithFormat:@"%@至%@", info.beginTime, info.endTime]];
            }];
            [av show];
        }
    }];
}

- (void)startPlayWithSession:(NSString *)session_ {
    
    [self stopPlayWithBlock:^{
        _player = nil;
        [self.player AVInitialize:self.imageView];
        NSString *str = [NSString stringWithFormat:@"tcp://%@:%d",APP_DELEGATE.tvMgr.service.info.server,APP_DELEGATE.tvMgr.service.info.mediaPort];
        NSURL  *url = [NSURL URLWithString:str];
        [self.player AVStartPlay:url session:session_];
    }];
    
}


-(void)stopPlayWithBlock:(void (^)())block_ {
    if (self.player.isPlaying) {
        NSString *session = self.player.playSession;
        void (^stopListener)(UVError*) = ^(UVError *error) {
            [self.player AVStopPlay];
            //等待播放器停止
            while (self.player.playStatus != PLAY_STATUS_CLOSED) {
                NSLog(@"wait player stop");
                //                [self showMsg:@"正在停止当前播放"];
                [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
            }
            //            [self showMsg:@""];
            if(block_ != nil) {
                [self.playOrPauseBtn setBackgroundImage:[UIImage imageNamed:@"replay_play_btn"] forState:UIControlStateNormal];
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
            [self.playOrPauseBtn setBackgroundImage:[UIImage imageNamed:@"replay_play_btn"] forState:UIControlStateNormal];
            block_();
        }
    }
}

#pragma mark - UVPlayerDelegate

- (void)onPlayError:(UVPlayer*)sender_ error:(UVError*)error_ {
    NSLog(@"%@", error_);
//    [self showErrorInfo:YES];
}

- (void)onPlayStatus:(UVPlayer*)sender_ status:(PLAY_STATUS)status_ {
    if (status_ == PLAY_STATUS_OPENED) {
        [self.waitView stopAnimating];
        self.selectTmBtn.enabled = YES;
        [self.playOrPauseBtn setBackgroundImage:[UIImage imageNamed:@"replay_pause_btn"] forState:UIControlStateNormal];
    }
}


- (void)onRecordStatus:(UVPlayer*)sender_ status:(BOOL)status_ {
    
}


- (void)onMuteStatus:(UVPlayer*)sender_ status:(BOOL)status_ {
    
}

- (void)onSnatchStatus:(UVPlayer*)sender_ path:(NSURL*)path_ error:(UVError*)error_ {
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    UVRecordInfo *info = [self.recordList objectAtIndex:buttonIndex];
    UVStreamInfo *streaminfo = [UVStreamInfo defaultStreamInfo];
    UVStartReplayParam *param = [[UVStartReplayParam alloc] init];
    [param setCameraCode:_currentCameralInfo.resCode];
    [param setStreamInfo:streaminfo];
    [param setRecordInfo:info];
    
    self.startTm = info.beginTime;
    self.endTm = info.endTime;
    
    self.startDate = [self dateWithFormater:@"yyyy-MM-dd HH:mm:ss" stringTime:self.startTm];
    self.endDate = [self dateWithFormater:@"yyyy-MM-dd HH:mm:ss" stringTime:self.endTm];
    
    _playSession = nil;
    [APP_DELEGATE.tvMgr.request execRequest:^{
        _playSession = [APP_DELEGATE.tvMgr.service startReplay:param];
    } finish:^(UVError *error) {
        if(error != nil)return;
        [self startPlayWithSession:_playSession];
        _playType = PLAY_TYPE_REPLAY;
    }];
}

- (NSDate *)dateWithFormater:(NSString *) formater stringTime:(NSString *)stringTime {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:formater];
    NSDate *date = [dateFormat dateFromString:stringTime];
    return date;
}





@end
