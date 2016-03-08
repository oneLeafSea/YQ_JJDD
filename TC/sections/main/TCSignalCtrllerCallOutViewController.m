//
//  TCSignalCtrllerCallOutViewController.m
//  TC
//
//  Created by 郭志伟 on 15/11/17.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TCSignalCtrllerCallOutViewController.h"

#import <Masonry/Masonry.h>
#import "BEMCheckBox.h"

#import "UIColor+RandomColor.h"
#import "AppDelegate.h"
#import "TLAPI.h"
#import "JSONKit.h"
#import "TLSignaleCtrllerRunTimeInfo.h"

@interface TCSignalCtrllerCallOutViewController()<BEMCheckBoxDelegate>

@property(nonatomic, strong)UILabel *ctrlerNameLabel;
@property(nonatomic, strong)TLSignalCtrlerInfo *scInfo;
@property(nonatomic, strong)BEMCheckBox *checkbox;

@property(nonatomic, strong)UILabel *selectLabel;

@property(nonatomic, strong)UIActivityIndicatorView *waitView;
@property(nonatomic, strong)UILabel *tipLabel;


@end

@implementation TCSignalCtrllerCallOutViewController

- (void)dealloc {

}


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
    [self getSignalInfo];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.checkbox.delegate = self;

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   // self.checkbox.delegate = nil; // 当设置为nil的时候真机上会crush掉。不设置nil则会有内存泄漏。。
}

#pragma makr - private method 
- (void)getSignalInfo {
    
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
    
    [self.scInfo getCrossRunInfoWithToken:[TLAPI loginToken] Completion:^(NSString *jsonResult, BOOL finished) {
        NSArray *ret = [jsonResult objectFromJSONString];
        if ([ret isKindOfClass:[NSArray class]] && ret.count > 0) {
            TLSignaleCtrllerRunTimeInfo *runTimeInfo = [[TLSignaleCtrllerRunTimeInfo alloc] initWithDict:ret[0]];
            if ([runTimeInfo.modelCode isEqualToString:@"0300"]) {
                self.tipLabel.hidden = NO;
                self.tipLabel.text = @"路口手控";
            } else if ([runTimeInfo.modelCode isEqualToString:@"0602"]) {
                self.tipLabel.hidden = NO;
                self.tipLabel.text = [NSString stringWithFormat:@"由%@控制", runTimeInfo.lockUser];
            } else {
                self.selectLabel.hidden = NO;
                self.checkbox.hidden = NO;
            }
        } else {
            self.tipLabel.hidden = NO;
            self.tipLabel.text = @"未知状态";
        }
        [self.waitView stopAnimating];
    }];
    
//    [TLAPI getCrossRunInfoWithCrossId:self.scInfo.crossId token:[TLAPI loginToken] Completion:^(NSString *jsonResult, BOOL finished) {
//        NSArray *ret = [jsonResult objectFromJSONString];
//        if ([ret isKindOfClass:[NSArray class]] && ret.count > 0) {
//            TLSignaleCtrllerRunTimeInfo *runTimeInfo = [[TLSignaleCtrllerRunTimeInfo alloc] initWithDict:ret[0]];
//            if ([runTimeInfo.modelCode isEqualToString:@"0300"]) {
//                self.tipLabel.hidden = NO;
//                self.tipLabel.text = @"路口手控";
//            } else if ([runTimeInfo.modelCode isEqualToString:@"0602"]) {
//                self.tipLabel.hidden = NO;
//                self.tipLabel.text = [NSString stringWithFormat:@"由%@控制", runTimeInfo.lockUser];
//            } else {
//                self.selectLabel.hidden = NO;
//                self.checkbox.hidden = NO;
//            }
//        } else {
//            self.tipLabel.hidden = NO;
//            self.tipLabel.text = @"未知状态";
//        }
//        [self.waitView stopAnimating];
//    }];
}

#pragma mark - getter
- (UILabel *)ctrlerNameLabel {
    if (_ctrlerNameLabel == nil) {
        _ctrlerNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _ctrlerNameLabel.text = self.scInfo.ctrlerNam;
        _ctrlerNameLabel.adjustsFontSizeToFitWidth = YES;
        _ctrlerNameLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_ctrlerNameLabel];
    }
    return _ctrlerNameLabel;
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

- (TLSignalCtrlerInfo *)scInfo {
    if (_scInfo == nil) {
        NSString *ctrolerId = [self.graphic attributeForKey:@"ctrlerId"];
        _scInfo = [APP_DELEGATE.tlMgr getSCInfoByCtrlerId:ctrolerId];
    }
    return _scInfo;
}




- (UILabel *)selectLabel {
    if (_selectLabel == nil) {
        _selectLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _selectLabel.text = @"选择控制";
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

#pragma mark - setter
- (void)setSelected:(BOOL)selected {
    _selected = selected;
    if (_checkbox) {
        _checkbox.on = selected;
    }
//    self.checkbox.on = selected;
}

- (void)setGraphic:(AGSGraphic *)graphic {
    _graphic = graphic;
    NSString *ctrolerId = [self.graphic attributeForKey:@"ctrlerId"];
    _scInfo = [APP_DELEGATE.tlMgr getSCInfoByCtrlerId:ctrolerId];
    if (_ctrlerNameLabel) {
        _ctrlerNameLabel.text = _scInfo.ctrlerNam;
    }
}

#pragma mark - setup

- (void)setupConstraints {
    [self.ctrlerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
    
    
    [self.selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.ctrlerNameLabel.mas_bottom).offset(8);
    }];
    
    [self.checkbox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.selectLabel);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(self.ctrlerNameLabel.mas_height);
        make.width.equalTo(self.ctrlerNameLabel.mas_height);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.ctrlerNameLabel.mas_bottom).offset(8);
    }];
    
    [self.waitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(8);
    }];
    
}

#pragma mark - BEMCheckBox delegate

- (void)didTapCheckBox:(BEMCheckBox*)checkBox {
    _selected = checkBox.on;
    if ([self.delegate respondsToSelector:@selector(signalCtrllerCallOutViewController:DidSelected:SignalCtrler:)]) {
        [self.delegate signalCtrllerCallOutViewController:self DidSelected:checkBox.on SignalCtrler:self.scInfo];
    }
}

@end
