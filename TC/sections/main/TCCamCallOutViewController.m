//
//  TCCamCallOutViewController.m
//  TC
//
//  Created by 郭志伟 on 15/11/23.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TCCamCallOutViewController.h"

#import <Masonry/Masonry.h>

#import "BEMCheckBox.h"
#import "AppDelegate.h"
#import "env.h"


@interface TCCamCallOutViewController() <BEMCheckBoxDelegate>

@property(nonatomic, strong)UILabel *cameraLabel;
@property(nonatomic, strong)NSString *cameralName;
@property(nonatomic, strong)NSString *tunnel;
@property(nonatomic, strong)BEMCheckBox *checkbox;

@property(nonatomic, strong)UILabel *selectLabel;

@property(nonatomic, strong)UIActivityIndicatorView *waitView;
@property(nonatomic, strong)UILabel *tipLabel;

@property(nonatomic, strong)UVResourceInfo *curResInfo;

@end

@implementation TCCamCallOutViewController

- (instancetype)initWithGraphic:(AGSGraphic *)graphic selected:(BOOL)selected {
    if (self = [super init]) {
        self.graphic = graphic;
        _selected = selected;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0, 0, 125, 60);
    [self setupConstraints];
    [self getCameralInfo];
}

- (void)getCameralInfo {
    if (self.selected) {
        [self.waitView stopAnimating];
        self.tipLabel.hidden = YES;
        self.selectLabel.hidden = NO;
        self.checkbox.hidden = NO;
        return;
    }
    
    self.selectLabel.hidden = YES;
    self.checkbox.hidden = YES;
    self.tipLabel.hidden = YES;
    [self.waitView startAnimating];
    
}

- (void)setupConstraints {
    [self.cameraLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
    
    
    [self.selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.cameraLabel.mas_bottom).offset(8);
    }];
    
    [self.checkbox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.selectLabel);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(self.cameraLabel.mas_height);
        make.width.equalTo(self.cameraLabel.mas_height);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.cameraLabel.mas_bottom).offset(8);
    }];
    
    [self.waitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(8);
    }];
    
}


- (void)setSelected:(BOOL)selected {
    _selected = selected;
    self.checkbox.on = selected;
}

#pragma mark - getter

- (UILabel *)cameraLabel {
    if (_cameraLabel == nil) {
        _cameraLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _cameraLabel.text = self.cameralName;
        _cameraLabel.adjustsFontSizeToFitWidth = YES;
        _cameraLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_cameraLabel];
    }
    return _cameraLabel;
}

- (BEMCheckBox *)checkbox {
    if (_checkbox == nil) {
        _checkbox = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        _checkbox.boxType = BEMBoxTypeSquare;
        _checkbox.onAnimationType = BEMAnimationTypeFade;
        _checkbox.offAnimationType = BEMAnimationTypeFade;
        _checkbox.onTintColor = [UIColor orangeColor];
        _checkbox.onCheckColor = [UIColor orangeColor];
        _checkbox.on = self.selected;
        _checkbox.delegate = self;
        [self.view addSubview:_checkbox];
    }
    return _checkbox;
}

- (NSString *)cameralName {
    if (_cameralName == nil) {
        if ([self.graphic hasAttributeForKey:kHcDeviceId]) {
            NSString *deviceId = [self.graphic attributeForKey:kHcDeviceId];
            TVHighCamInfo *hci = [APP_DELEGATE.tlMgr getHcInfoByDeviceId:deviceId];
            _cameralName = [hci.deviceNam copy];
        }
        
        if ([self.graphic hasAttributeForKey:kEpDeviceId]) {
            NSString *deviceId = [self.graphic attributeForKey:kEpDeviceId];
            TVElecPoliceInfo *epci = [APP_DELEGATE.tlMgr getElecPoliceInfoByDeviceId:deviceId];
            _cameralName = [epci.deviceNam copy];
        }
        
        if ([self.graphic hasAttributeForKey:kRcDeviceId]) {
            NSString *deviceId = [self.graphic attributeForKey:kRcDeviceId];
            TVRoadCamInfo *rci = [APP_DELEGATE.tlMgr getRoadCamInfoByDeviceId:deviceId];
            _cameralName = [rci.deviceNam copy];
        }
    }
    return _cameralName;
}

- (NSString *)tunnel {
    if (_tunnel == nil) {
        if ([self.graphic hasAttributeForKey:kHcDeviceId]) {
            NSString *deviceId = [self.graphic attributeForKey:kHcDeviceId];
            TVHighCamInfo *hci = [APP_DELEGATE.tlMgr getHcInfoByDeviceId:deviceId];
            _tunnel = [hci.tunnel copy];
        }
        
        if ([self.graphic hasAttributeForKey:kEpDeviceId]) {
            NSString *deviceId = [self.graphic attributeForKey:kEpDeviceId];
            TVElecPoliceInfo *epci = [APP_DELEGATE.tlMgr getElecPoliceInfoByDeviceId:deviceId];
            _tunnel = [epci.tunnel copy];
        }
        
        if ([self.graphic hasAttributeForKey:kRcDeviceId]) {
            NSString *deviceId = [self.graphic attributeForKey:kRcDeviceId];
            TVRoadCamInfo *rci = [APP_DELEGATE.tlMgr getRoadCamInfoByDeviceId:deviceId];
            _tunnel = [rci.tunnel copy];
        }
    }
    return _tunnel;
}



- (UILabel *)selectLabel {
    if (_selectLabel == nil) {
        _selectLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _selectLabel.text = @"实时视频";
        [self.view addSubview:_selectLabel];
        [_selectLabel sizeToFit];
    }
    return _selectLabel;
}

- (UILabel *)tipLabel {
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.textColor = [UIColor redColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.text = @"无法实时视频";
        _tipLabel.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:_tipLabel];
    }
    return _tipLabel;
}

- (UIActivityIndicatorView *)waitView {
    if (_waitView == nil) {
        _waitView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _waitView.hidesWhenStopped = YES;
        [self.view addSubview:_waitView];
    }
    return _waitView;
}

#pragma mark - BEMCheckBox delegate

- (void)didTapCheckBox:(BEMCheckBox*)checkBox {
    _selected = checkBox.on;
    if ([self.delegate respondsToSelector:@selector(camCallOutViewController:DidSelected:)]) {
        [self.delegate camCallOutViewController:self DidSelected:self.checkbox.on];
    }
}

@end
