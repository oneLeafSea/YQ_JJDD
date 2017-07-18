//
//  TCSignalCtrlHeadView.m
//  TC
//
//  Created by 郭志伟 on 15/11/18.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TCSignalCtrlHeadView.h"
#import "UIColor+Hexadecimal.h"

#import <Masonry/Masonry.h>

@interface TCSignalCtrlHeadView()

@property(nonatomic, strong) UIView *selectedView;

@property(nonatomic, strong) UIImageView *iconImgView;

@property(nonatomic, strong) UILabel *titleLabel;

@property(nonatomic, strong) UIView *seperatorView;

@end

@implementation TCSignalCtrlHeadView

- (instancetype)initWithSignalCtrlerName:(NSString *)name {
    
    return [self initWithFrame:CGRectZero ctrlerName:name];
}
- (instancetype)initWithFrame:(CGRect)frame ctrlerName:(NSString *)name {
    return [self initWithFrame:frame ctrlerName:name selected:NO];
}

- (instancetype)initWithFrame:(CGRect)frame ctrlerName:(NSString *)name selected:(BOOL)selected {
    if (self = [super initWithFrame:frame]) {
        self.ctrlerName = name;
        _selected = selected;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor colorWithHex:self.selected ? @"#343f51" : @"#2b3346"];
    
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGuesture:)];
        [self addGestureRecognizer:tapGesture];
        [self setupConstraints];
    
    
}

- (void)setupConstraints {
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(8);
        make.centerY.equalTo(self);
    }];
    
    [self.seperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.height.equalTo(@1);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
    }];
    
    [self.selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.width.equalTo(@6);
        make.bottom.equalTo(self);
    }];
}

#pragma mark - setter
- (void)setSelected:(BOOL)selected {
    _selected = selected;
    self.backgroundColor = [UIColor colorWithHex:self.selected ? @"#2b3346": @"#343f51"];
    self.selectedView.hidden = !_selected;
    NSString *iconName = _selected ? @"sc_signal_ctrller" : @"sc_signal_ctrller_un";
    self.iconImgView.image = [UIImage imageNamed:iconName];
    self.titleLabel.textColor = [UIColor colorWithHex:self.selected ? @"#ffffff": @"#848992"];
}

- (void)setCtrlerName:(NSString *)ctrlerName {
    _ctrlerName = ctrlerName;
    self.titleLabel.text = ctrlerName;
}

#pragma mark - getter
- (UIView *)selectedView {
    if (_selectedView == nil) {
        _selectedView = [[UIView alloc] initWithFrame:CGRectZero];
        _selectedView.backgroundColor = [UIColor colorWithHex:@"#41b9c7"];
        _selectedView.hidden = !self.selected;
        [self addSubview:_selectedView];
    }
    return _selectedView;
}

- (UIImageView *)iconImgView {
    if (_iconImgView == nil) {
        NSString *iconName = self.selected ? @"sc_signal_ctrller" : @"sc_signal_ctrller_un";
        _iconImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
        [self addSubview:_iconImgView];
    }
    return _iconImgView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.text = self.ctrlerName;
        _titleLabel.textColor = [UIColor colorWithHex:self.selected ? @"#ffffff": @"#848992"];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIView *)seperatorView {
    if (_seperatorView == nil) {
        _seperatorView = [[UIView alloc] initWithFrame:CGRectZero];
        _seperatorView.backgroundColor = [UIColor colorWithHex:@"#2b3346"];
        [self addSubview:_seperatorView];
    }
    return _seperatorView;
}

#pragma mark - action
- (void)handleTapGuesture:(UITapGestureRecognizer *)guesture {
    self.selected = !self.selected;
    
    if ([self.delegate respondsToSelector:@selector(TCSignalCtrlHeadView:didSelected:)]) {
        [self.delegate TCSignalCtrlHeadView:self didSelected:self.selected];
    }
}

@end
