//
//  TCEPCCalloutViewController.m
//  TC
//
//  Created by 郭志伟 on 16/3/4.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import "TCEPCCalloutViewController.h"


#import <Masonry/Masonry.h>
#import "BEMCheckBox.h"
#import "AppDelegate.h"
#import "UIColor+Hexadecimal.h"
#import "TCVideoContainerView.h"

@interface TCEPCCalloutViewController ()<BEMCheckBoxDelegate>

@property(nonatomic, strong) BEMCheckBox *videoCheckbox;
@property(nonatomic, strong) BEMCheckBox *tollgateCheckbox;

@property(nonatomic, strong) NSString *cameralName;
@property(nonatomic, strong) UILabel *cameraLabel;
@property(nonatomic, strong) UILabel *videoSelectLabel;
@property(nonatomic, strong) UILabel *tollgateSelLabel;
@property(nonatomic,strong)TCVideoContainerView*tcv;
@end

@implementation TCEPCCalloutViewController

- (instancetype)initWithGraphic:(AGSGraphic *)graphic
                  videoSelected:(BOOL)videoSelected
               tollgateSelected:(BOOL)tgSelected {
    if (self = [super init]) {
        self.graphic = graphic;
        _videoSelected = videoSelected;
        _tollageSelected = tgSelected;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, 125, 80);
    [self setupConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)setupConstraints {
    [self.cameraLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
    [self.videoSelectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.cameraLabel.mas_bottom).offset(8);
    }];
    
    [self.videoCheckbox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.videoSelectLabel);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(self.videoSelectLabel.mas_height);
        make.width.equalTo(self.videoSelectLabel.mas_height);
    }];
    
    [self.tollgateSelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.videoSelectLabel.mas_bottom).offset(8);
    }];
    
    [self.tollgateCheckbox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tollgateSelLabel);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(self.tollgateSelLabel.mas_height);
        make.width.equalTo(self.tollgateSelLabel.mas_height);
    }];
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

- (BEMCheckBox *)videoCheckbox {
    if (_videoCheckbox == nil) {
        _videoCheckbox = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        _videoCheckbox.boxType = BEMBoxTypeSquare;
        _videoCheckbox.onAnimationType = BEMAnimationTypeFade;
        _videoCheckbox.offAnimationType = BEMAnimationTypeFade;
        _videoCheckbox.onTintColor = [UIColor colorWithHex:@"ff5252"];
        _videoCheckbox.onCheckColor = [UIColor colorWithHex:@"ff5252"];
        _videoCheckbox.on = self.videoSelected;
        _videoCheckbox.delegate = self;
        [self.view addSubview:_videoCheckbox];
    }
    return _videoCheckbox;
}

- (BEMCheckBox *)tollgateCheckbox {
    if (_tollgateCheckbox == nil) {
        _tollgateCheckbox = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        _tollgateCheckbox.boxType = BEMBoxTypeSquare;
        _tollgateCheckbox.onAnimationType = BEMAnimationTypeFade;
        _tollgateCheckbox.offAnimationType = BEMAnimationTypeFade;
        _tollgateCheckbox.onTintColor = [UIColor colorWithHex:@"#ff5252"];
        _tollgateCheckbox.onCheckColor = [UIColor colorWithHex:@"#ff5252"];
        _tollgateCheckbox.on = self.tollageSelected;
        _tollgateCheckbox.delegate = self;
        [self.view addSubview:_tollgateCheckbox];
    }
    return _tollgateCheckbox;
}

- (UILabel *)videoSelectLabel {
    if (_videoSelectLabel == nil) {
        _videoSelectLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _videoSelectLabel.text = @"实时视频";
        [self.view addSubview:_videoSelectLabel];
        [_videoSelectLabel sizeToFit];
    }
    return _videoSelectLabel;
}

- (UILabel *)tollgateSelLabel {
    if (_tollgateSelLabel == nil) {
        _tollgateSelLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tollgateSelLabel.text = @"订阅卡口";
        [self.view addSubview:_tollgateSelLabel];
        [_tollgateSelLabel sizeToFit];
    }
    return _tollgateSelLabel;
}

- (NSString *)cameralName {
    if (_cameralName == nil) {
        if ([self.graphic hasAttributeForKey:kCam]) {
            NSString *deviceId = [self.graphic attributeForKey:kCam];
            TVElecPoliceInfo *epi = [APP_DELEGATE.tlMgr getElecPoliceInfoByDeviceId:deviceId];
            _cameralName = [epi.deviceNam copy];
        }
    }
    return _cameralName;
}
//-(NSString *)cameralName{
//    if (_cameralName==nil) {
//        
//    }
//}

#pragma mark - BEMCheckBox delegate

- (void)didTapCheckBox:(BEMCheckBox*)checkBox {
    if ([checkBox isEqual:self.tollgateCheckbox]) {
        if ([self.delegate respondsToSelector:@selector(TCEPCCalloutViewController:tollgateDidSelected:)]) {
            [self.delegate TCEPCCalloutViewController:self tollgateDidSelected:checkBox.on];
//            TCEPCTollegateViewController *viewTOL=[[TCEPCTollegateViewController alloc]init];
//            [self presentModalViewController:viewTOL animated:YES];
        }
    }
    
    if ([checkBox isEqual:self.videoCheckbox]) {
        
        if ([self.delegate respondsToSelector:@selector(TCEPCCalloutViewController:videoDidSelected:)]) {
            
            [self.delegate TCEPCCalloutViewController:self videoDidSelected:checkBox.on];
        }
    }
}

@end
