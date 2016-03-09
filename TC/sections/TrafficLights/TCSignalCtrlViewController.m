//
//  TCSignalCtrlViewController.m
//  TC
//
//  Created by 郭志伟 on 15/11/16.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TCSignalCtrlViewController.h"
#import "TCSignalCtrlView.h"
#import "TCApplyReq.h"
#import "AppDelegate.h"

#import <Masonry/Masonry.h>

@interface TCSignalCtrlViewController() <TCSignalCtrlViewDelegate>

@property(nonatomic, strong) TCSignalCtrlView *scView;

@end

@implementation TCSignalCtrlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}


- (void)commonInit {
    [self.scView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)addSignalContrller:(TLSignalCtrlerInfo *)scInfo {
    [self.scView addSignalContrller:scInfo];
}

- (void)removeSignalController:(TLSignalCtrlerInfo *)scInfo {
    [self.scView removeSignalController:scInfo];
}


#pragma mark -getter
- (TCSignalCtrlView *)scView {
    if (_scView == nil) {
        _scView = [[TCSignalCtrlView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_scView];
        _scView.delegate = self;
    }
    return _scView;
}

#pragma mark -delegate
- (void)signalCtrlViewBackToMapBtnPressed:(TCSignalCtrlView *)signalCtrlView {
    if ([self.delegate respondsToSelector:@selector(TCSignalCtrlViewControllerBackToMapBtnPressed:)]) {
        [self.delegate TCSignalCtrlViewControllerBackToMapBtnPressed:self];
    }
}

- (void)signalCtrlView:(TCSignalCtrlView *)signalCtrlView didDeleteScInfo:(TLSignalCtrlerInfo *)scInfo {
    if ([self.delegate respondsToSelector:@selector(TCSignalCtrlViewController:didDeleteScInfo:)]) {
        [self.delegate TCSignalCtrlViewController:self didDeleteScInfo:scInfo];
    }
}

- (void)signalCtrlView:(TCSignalCtrlView *)signalCtrlView requestBtnTapped:(UIButton *)btn {
    btn.enabled = NO;
    [TCApplyReq ApplyCtrlWithWsmgr:APP_DELEGATE.wsMgr completion:^(RTWSMsg *msg, NSError *err) {
        btn.enabled = YES;
        
    }];
}

@end
