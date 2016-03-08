//
//  TCFuncTableViewCell.m
//  TC
//
//  Created by 郭志伟 on 15/11/12.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TCFuncTableViewCell.h"
#import "UIColor+Hexadecimal.h"
#import <Masonry/Masonry.h>

@interface TCFuncTableViewCell()

@property(nonatomic, strong) UIView *flagView;
@property(nonatomic, strong) UILabel *titleLabel;

@end

@implementation TCFuncTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commonInit];
    }
    return self;
}

#pragma mark - getter
- (UIView *)flagView {
    if (_flagView == nil) {
        _flagView = [[UIView alloc] initWithFrame:CGRectZero];
        _flagView.backgroundColor = [UIColor colorWithHex:@"41b9c7"];
    }
    
    return _flagView;
}

- (UIImageView *)iconImgView {
    if (_iconImgView == nil) {
        _iconImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"func_video_surveillance"]];
        [self.contentView addSubview:_iconImgView];
    }
    return _iconImgView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_titleLabel];
        _titleLabel.textColor = [UIColor colorWithHex:@"#69707c"];
        _titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _titleLabel;
}

#pragma mark - setter

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
    _title = [title copy];
}

- (void)commonInit {
    self.contentView.backgroundColor = [UIColor colorWithHex:@"#343f51"];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
    bgView.backgroundColor = [UIColor colorWithHex:@"#202636"];
    [bgView addSubview:self.flagView];
    self.selectedBackgroundView = bgView;
    if ([self respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [self setPreservesSuperviewLayoutMargins:NO];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
    [self setupConstraints];
}

- (void)setNormalImgName:(NSString *)normalImgName {
    _normalImgName = normalImgName;
    if (_normalImgName) {
        self.iconImgView.image = [UIImage imageNamed:_normalImgName];
    }
}


- (void)setupConstraints {
    [self.flagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectedBackgroundView);
        make.top.equalTo(self.selectedBackgroundView);
        make.bottom.equalTo(self.selectedBackgroundView);
        make.width.equalTo(@6);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(21);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)cellSelected:(BOOL)selected {
    if (selected) {
        self.titleLabel.textColor = [UIColor whiteColor];
        self.iconImgView.image = [UIImage imageNamed:self.selectedImgName];
    } else {
        self.titleLabel.textColor = [UIColor colorWithHex:@"#69707c"];
        self.iconImgView.image = [UIImage imageNamed:self.normalImgName];
    }

}

@end
