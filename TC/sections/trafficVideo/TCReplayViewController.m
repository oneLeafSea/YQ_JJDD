//
//  TCReplayViewController.m
//  TC
//
//  Created by 郭志伟 on 15/11/30.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TCReplayViewController.h"
#import "UIColor+Hexadecimal.h"
#import "TCReplayContainerView.h"

#import <Masonry/Masonry.h>

@interface TCReplayViewController()<TCReplayContainerViewDelegage>

//@property(nonatomic, strong)UIButton *closeBtn;
@property(nonatomic, strong)TCReplayContainerView *replayContainerView;

@end

@implementation TCReplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self setup];
}

- (void)setup {
    [self.replayContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - getter

- (TCReplayContainerView *)replayContainerView {
    if (_replayContainerView == nil) {
        _replayContainerView = [[TCReplayContainerView alloc] initWithFrame:CGRectZero cameraInfo:self.camInfo];
        _replayContainerView.currentCameralInfo = self.resInfo;
        [self.view addSubview:_replayContainerView];
        _replayContainerView.parentVC = self;
        _replayContainerView.delegate = self;
    }
    return _replayContainerView;
}

#pragma mark - deleage
- (void)TCReplayContainerViewCloseBtnDidTapped:(TCReplayContainerView *)replayView {
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(TCReplayViewControllerDidClose:)]) {
            [self.delegate TCReplayViewControllerDidClose:self];
        }
    }];
}

@end
