//
//  TCMapLayerSelectionView.m
//  TC
//
//  Created by 郭志伟 on 15/11/24.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TCMapLayerSelectionView.h"

#import <Masonry/Masonry.h>
#import "BEMCheckBox.h"


@interface TCMapLayerSelectionView()<BEMCheckBoxDelegate>


// 信号机
@property(nonatomic, strong) BEMCheckBox *scBox;
@property(nonatomic, strong) UILabel     *scLabel;

// 高空
@property(nonatomic, strong) BEMCheckBox *highCamBox;
@property(nonatomic, strong) UILabel     *highCamLabel;

// 路口
@property(nonatomic, strong) BEMCheckBox *roadCamBox;
@property(nonatomic, strong) UILabel     *roadCamLabel;

// 电子警察
@property(nonatomic, strong) BEMCheckBox *epCamBox;
@property(nonatomic, strong) UILabel     *epCamLabel;


@end

@implementation TCMapLayerSelectionView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self setupConstaints];
    self.backgroundColor = [UIColor whiteColor];
    self.alpha = 0.5;
}

- (void)setupConstaints {
    
    [self.scLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.top.equalTo(self).offset(5);
    }];
    
    [self.scBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scLabel.mas_right).offset(5);
        make.top.equalTo(self.scLabel);
        make.width.equalTo(self.scLabel.mas_height);
        make.height.equalTo(self.scLabel.mas_height);
    }];
    
    [self.highCamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scLabel);
        make.top.equalTo(self.scLabel.mas_bottom).offset(5);
    }];
    
    [self.highCamBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.highCamLabel.mas_right).offset(5);
        make.top.equalTo(self.highCamLabel);
        make.width.equalTo(self.highCamLabel.mas_height);
        make.height.equalTo(self.highCamLabel.mas_height);
    }];
    
    [self.roadCamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.highCamLabel);
        make.top.equalTo(self.highCamLabel.mas_bottom).offset(5);
    }];
    
    [self.roadCamBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.roadCamLabel.mas_right).offset(5);
        make.top.equalTo(self.roadCamLabel);
        make.width.equalTo(self.roadCamLabel.mas_height);
        make.height.equalTo(self.roadCamLabel.mas_height);
    }];
    
    [self.epCamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.roadCamLabel);
        make.top.equalTo(self.roadCamLabel.mas_bottom).offset(5);
    }];
    
    [self.epCamBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.epCamLabel.mas_right).offset(5);
        make.top.equalTo(self.epCamLabel);
        make.width.equalTo(self.epCamLabel.mas_height);
        make.height.equalTo(self.epCamLabel.mas_height);
    }];
}

#pragma mark - getter

- (UILabel *)scLabel {
    if (_scLabel == nil) {
        _scLabel = [self createLabelWithTxt:@"信号控制"];
        [self addSubview:_scLabel];
    }
    return _scLabel;
}

- (BEMCheckBox *)scBox {
    if (_scBox == nil) {
        _scBox = [self createCheckbBox];
        [self addSubview:_scBox];
    }
    return _scBox;
}

- (BEMCheckBox *)highCamBox {
    if (_highCamBox == nil) {
        _highCamBox = [self createCheckbBox];
        _highCamBox.delegate = self;
        [self addSubview:_highCamBox];
    }
    return _highCamBox;
}

- (UILabel *)highCamLabel {
    if (_highCamLabel == nil) {
        _highCamLabel = [self createLabelWithTxt:@"高空云台"];
        [self addSubview:_highCamLabel];
    }
    return _highCamLabel;
}

- (BEMCheckBox *)roadCamBox {
    if (_roadCamBox == nil) {
        _roadCamBox = [self createCheckbBox];
        [self addSubview:_roadCamBox];
    }
    return _roadCamBox;
}

- (UILabel *)roadCamLabel {
    if (_roadCamLabel == nil) {
        _roadCamLabel = [self createLabelWithTxt:@"路口云台"];
        [self addSubview:_roadCamLabel];
    }
    return _roadCamLabel;
}

- (BEMCheckBox *)epCamBox {
    if (_epCamBox == nil) {
        _epCamBox = [self createCheckbBox];
        [self addSubview:_epCamBox];
    }
    return _epCamBox;
}

- (UILabel *)epCamLabel {
    if (_epCamLabel == nil) {
        _epCamLabel = [self createLabelWithTxt:@"电子警察"];
        [self addSubview:_epCamLabel];
    }
    return _epCamLabel;
}

- (BOOL)scOn {
    return self.scBox.on;
}

- (BOOL)hcOn {
    return self.highCamBox.on;
}

- (BOOL)rcOn {
    return self.roadCamBox.on;
}


- (BOOL)epOn {
    return self.epCamBox.on;
}


#pragma mark - setter
- (void)setHcOn:(BOOL)hcOn {
    self.highCamBox.on = hcOn;
}

- (void)setRcOn:(BOOL)rcOn {
    self.roadCamBox.on = rcOn;
}

- (void)setScOn:(BOOL)scOn {
    self.scBox.on = scOn;
}

- (void)setEpOn:(BOOL)epOn {
    self.epCamBox.on = epOn;
}

#pragma mark - private method

- (BEMCheckBox *)createCheckbBox {
    BEMCheckBox *checkBox = [[BEMCheckBox alloc] initWithFrame:CGRectZero];
    checkBox.boxType = BEMBoxTypeSquare;
    checkBox.onAnimationType = BEMAnimationTypeFade;
    checkBox.offAnimationType = BEMAnimationTypeFade;
    checkBox.onTintColor = [UIColor orangeColor];
    checkBox.onCheckColor = [UIColor orangeColor];
    checkBox.delegate = self;
    return checkBox;
}

- (UILabel *)createLabelWithTxt:(NSString *)txt {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
    lbl.text = txt;
    return lbl;
}

# pragma mark - delegate
- (void)didTapCheckBox:(BEMCheckBox*)checkBox {
    if ([checkBox isEqual:self.scBox]) {
        if ([self.delegate respondsToSelector:@selector(TCMapLayerSelectionView:scLayerDidSelected:)]) {
            [self.delegate TCMapLayerSelectionView:self scLayerDidSelected:checkBox.on];
        }
        return;
    }
    
    if ([checkBox isEqual:self.highCamBox]) {
        if ([self.delegate respondsToSelector:@selector(TCMapLayerSelectionView:hcLayerDidSelected:)]) {
            [self.delegate TCMapLayerSelectionView:self hcLayerDidSelected:checkBox.on];
        }
        return;
    }
    
    if ([checkBox isEqual:self.roadCamBox]) {
        if ([self.delegate respondsToSelector:@selector(TCMapLayerSelectionView:rcLayerDidSelected:)]) {
            [self.delegate TCMapLayerSelectionView:self rcLayerDidSelected:checkBox.on];
        }
    }
    
    if ([checkBox isEqual:self.epCamBox]) {
        if ([self.delegate respondsToSelector:@selector(TCMapLayerSelectionView:epLayerDidSelected:)]) {
            [self.delegate TCMapLayerSelectionView:self epLayerDidSelected:checkBox.on];
        }
    }
}

@end
