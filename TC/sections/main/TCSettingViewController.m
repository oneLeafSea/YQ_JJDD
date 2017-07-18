//
//  TCSettingViewController.m
//  TC
//
//  Created by 郭志伟 on 15/11/13.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TCSettingViewController.h"

#import <Masonry/Masonry.h>

@interface TCSettingViewController()

@property(nonatomic, strong)UITextView *aboutTV;

@end

@implementation TCSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupConstaints];
}

#pragma mark - setup

- (void)setupConstaints {
    [self.aboutTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(@70);
    }];
}


#pragma mark - getter
- (UITextView *)aboutTV {
    if (_aboutTV == nil) {
        _aboutTV = [[UITextView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_aboutTV];
        _aboutTV.text = @"移动智能交通\n version: 1.2\n 更新内容：卡口违法过车和布控告警同视图显示";
        
        [_aboutTV sizeToFit];
        _aboutTV.textAlignment = NSTextAlignmentCenter;
        [_aboutTV setEditable:NO];
        [_aboutTV setSelectable:NO];
    }
    return _aboutTV;
}


@end
