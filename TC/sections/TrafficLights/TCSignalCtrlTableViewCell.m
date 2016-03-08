//
//  TCSignalCtrlTableViewCell.m
//  TC
//
//  Created by 郭志伟 on 15/11/18.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TCSignalCtrlTableViewCell.h"

#import <Masonry/Masonry.h>
#import "UIColor+Hexadecimal.h"

@interface TCSignalCtrlTableViewCell()

@property(nonatomic, strong) UIButton *stopBtn;
@property(nonatomic, strong) UIButton *stepBtn;
@property(nonatomic, strong) UIButton *deleteBtn;

@end

@implementation TCSignalCtrlTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [self commonInit];
}

- (void)prepareForReuse {
    self.lockStageLabel.text = @"锁定状态: ";
    self.lockUserLabel.text = @"操控民警: ";
    self.modelDescLabel.text = @"控制类型: ";
    self.stageLabel.text = @"状态: ";
    self.noteLabel.text = @"备注: ";
    self.preSn = nil;
//    self.snTime = 0;
    self.deleteBtn.enabled = YES;
    self.startBtn.enabled = NO;
}

- (void)commonInit {
    self.contentView.backgroundColor = [UIColor colorWithHex:@"#2b3346"];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _controlling = NO;
    
    [self.stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(25);
        make.height.equalTo(@34);
        make.left.equalTo(self.contentView).offset(20);
        
    }];
    
    [self.stepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stopBtn.mas_right).offset(10);
        make.top.equalTo(self.stopBtn);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.equalTo(self.stopBtn);
    }];
    
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(25);
        make.height.equalTo(@34);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
    }];

    [self.modelDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.stopBtn.mas_bottom).offset(8);
        
        make.right.equalTo(self.contentView).offset(-20);
        make.height.equalTo(@30);
    }];

    [self.stageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.modelDescLabel.mas_bottom).offset(8);
//        make.width.equalTo(self.contentView).offset(-40);
        make.height.equalTo(@30);
        make.right.equalTo(self.contentView).offset(-20);
    }];

    [self.lockStageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.stageLabel.mas_bottom).offset(8);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.equalTo(@30);
    }];

    [self.lockUserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.lockStageLabel.mas_bottom).offset(8);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.equalTo(@30);
    }];
    [self.noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.lockUserLabel.mas_bottom).offset(8);
        make.height.equalTo(@30);
//        make.right.equalTo(self.contentView).offset(-20);
//        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.noteLabel.mas_bottom).offset(8);
        make.height.equalTo(@34);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
}

- (void)enableDeleteBtn:(BOOL)enable {
    self.deleteBtn.enabled = enable;
}

#pragma mark - getter
- (UIButton *)stopBtn {
    if (_stopBtn == nil) {
        _stopBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_stopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _stopBtn.layer.cornerRadius = 8.0f;
        _stopBtn.clipsToBounds = YES;
        [_stopBtn setTitle:@"停止" forState:UIControlStateNormal];
        [_stopBtn setBackgroundImage:[UIImage imageNamed:@"sc_blue_btn_bg"] forState:UIControlStateNormal];
        [_stopBtn setBackgroundImage:[UIImage imageNamed:@"sc_gray_btn_bg"] forState:UIControlStateDisabled];
        [_stopBtn addTarget:self action:@selector(stopBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_stopBtn];
    }
    return _stopBtn;
}

- (UIButton *)stepBtn {
    if (_stepBtn == nil) {
        _stepBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_stepBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _stepBtn.layer.cornerRadius = 8.0f;
        _stepBtn.clipsToBounds = YES;
        [_stepBtn setTitle:@"步进" forState:UIControlStateNormal];
        [_stepBtn setBackgroundImage:[UIImage imageNamed:@"sc_white_btn_bg"] forState:UIControlStateNormal];
        [_stepBtn setBackgroundImage:[UIImage imageNamed:@"sc_gray_btn_bg"] forState:UIControlStateDisabled];
        [_stepBtn addTarget:self action:@selector(stepBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_stepBtn];
    }
    return _stepBtn;
}

- (UIButton *)startBtn {
    if (_startBtn == nil) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _startBtn.layer.cornerRadius = 8.0f;
        _startBtn.clipsToBounds = YES;
        [_startBtn setTitle:@"启动" forState:UIControlStateNormal];
        [_startBtn setBackgroundImage:[UIImage imageNamed:@"sc_blue_btn_bg"] forState:UIControlStateNormal];
        [_startBtn setBackgroundImage:[UIImage imageNamed:@"sc_gray_btn_bg"] forState:UIControlStateDisabled];
        [_startBtn addTarget:self action:@selector(startBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        _startBtn.enabled = NO;
        [self.contentView addSubview:_startBtn];
    }
    return _startBtn;
}

- (UIButton *)deleteBtn {
    if (_deleteBtn == nil) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _deleteBtn.layer.cornerRadius = 8.0f;
        _deleteBtn.clipsToBounds = YES;
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"sc_red_btn_bg"] forState:UIControlStateNormal];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"sc_gray_btn_bg"] forState:UIControlStateDisabled];
        [_deleteBtn addTarget:self action:@selector(deleteBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_deleteBtn];
    }
    return _deleteBtn;
}

- (UILabel *)lockStageLabel {
    if (_lockStageLabel == nil) {
        _lockStageLabel = [self newLabelWithText:@"锁定状态: "];
    }
    return _lockStageLabel;
}

- (UILabel *)lockUserLabel {
    if (_lockUserLabel == nil) {
        _lockUserLabel = [self newLabelWithText:@"操控民警: "];
    }
    return _lockUserLabel;
}

- (UILabel *)modelDescLabel {
    if (_modelDescLabel == nil) {
        _modelDescLabel = [self newLabelWithText:@"控制类型: "];
        _modelDescLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _modelDescLabel;
}

- (UILabel *)stageLabel {
    if (_stageLabel == nil) {
        _stageLabel = [self newLabelWithText:@"信号机状态: "];
    }
    return _stageLabel;
}

- (UILabel *)noteLabel {
    if (_noteLabel == nil) {
        _noteLabel = [self newLabelWithText:@"备注: "];
    }
    return _noteLabel;
}

//- (UILabel *)curStageLabel {
//    if (_curStageLabel == nil) {
//        _curStageLabel = [self newLabelWithText:@"当前状态: "];
//    }
//    return _curStageLabel;
//}

- (UILabel *)newLabelWithText:(NSString *)txt {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:label];
    label.text = txt;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorWithHex:@"#848992"];
    [label sizeToFit];
    return label;
}



#pragma mark - setter

- (void)setControlling:(BOOL)controlling {
    _controlling = controlling;
    self.startBtn.hidden = _controlling;
    self.stopBtn.hidden = !_controlling;
    self.stepBtn.hidden = !_controlling;
    self.deleteBtn.enabled = !_controlling;
    if (!_controlling) {
        self.lockStageLabel.text = @"锁定状态: ";
    }
    
}

#pragma mark - action

- (void)stopBtnTapped:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(TCSignalCtrlTableViewCellTapped:stopBtn:)]) {
        [self.delegate TCSignalCtrlTableViewCellTapped:self stopBtn:self.stopBtn];
    }
}

- (void)startBtnTapped:(UIButton *)btn {
//    self.controlling = YES;
    if ([self.delegate respondsToSelector:@selector(TCSignalCtrlTableViewCellTapped:startBtn:)]) {
        [self.delegate TCSignalCtrlTableViewCellTapped:self startBtn:self.startBtn];
    }
}

- (void)stepBtnTapped:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(TCSignalCtrlTableViewCellTapped:stepBtn:)]) {
        [self.delegate TCSignalCtrlTableViewCellTapped:self stepBtn:self.stepBtn];
    }
}

- (void)deleteBtnTapped:(UIButton *)btn {
    btn.enabled = NO;
    if ([self.delegate respondsToSelector:@selector(TCSignalCtrlTableViewCell:deleteBtnTapped:)]) {
        [self.delegate TCSignalCtrlTableViewCell:self deleteBtnTapped:self.deleteBtn];
    }
}

@end
