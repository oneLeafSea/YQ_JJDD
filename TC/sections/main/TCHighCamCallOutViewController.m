//
//  TCHighCamCallOutViewController.m
//  TC
//
//  Created by 郭志伟 on 15/11/23.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TCHighCamCallOutViewController.h"

#import <Masonry/Masonry.h>

#import "BEMCheckBox.h"
#import "AppDelegate.h"

@interface TCHighCamCallOutViewController() <BEMCheckBoxDelegate>

@property(nonatomic, strong)UILabel *cameraLabel;
@property(nonatomic, strong)TVHighCamInfo *hcInfo;
@property(nonatomic, strong)BEMCheckBox *checkbox;

@property(nonatomic, strong)UILabel *selectLabel;

@property(nonatomic, strong)UIActivityIndicatorView *waitView;
@property(nonatomic, strong)UILabel *tipLabel;

@property(nonatomic, strong)UVResourceInfo *curResInfo;

@end

@implementation TCHighCamCallOutViewController

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
    [self getHcInfo];
}

- (void)getHcInfo {
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
    
    [APP_DELEGATE.tvMgr queryResourceWithKeyword:self.hcInfo.deviceNam completion:^(NSArray *resList, NSError *error) {
        if (resList.count >= 4) {
            self.curResInfo = resList[3];
            self.selectLabel.hidden = NO;
            self.checkbox.hidden = NO;
        } else {
            self.tipLabel.hidden = NO;
            self.tipLabel.text = @"无法获取视频";
        }
        [self.waitView stopAnimating];
    }];
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

#pragma mark - getter

- (UILabel *)cameraLabel {
    if (_cameraLabel == nil) {
        _cameraLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _cameraLabel.text = self.hcInfo.deviceNam;
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

- (TVHighCamInfo *)hcInfo {
    if (_hcInfo == nil) {
        NSString *deviceId = [self.graphic attributeForKey:@"hcDeviceId"];
        _hcInfo = [APP_DELEGATE.tlMgr getHcInfoByDeviceId:deviceId];
    }
    return _hcInfo;
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
        _tipLabel.text = @"该信号机已被控制";
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
    if ([self.delegate respondsToSelector:@selector(highCamCallOutViewController:DidSelected:hcInfo:)]) {
        [self.delegate highCamCallOutViewController:self DidSelected:checkBox.on hcInfo:self.hcInfo];
    }
}

@end
