//
//  TCVideoSignalCtrlViewController.m
//  TC
//
//  Created by 郭志伟 on 15/11/16.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TCVideoSignalCtrlViewController.h"

#import <Masonry/Masonry.h>

#import "TCVideosViewController.h"
#import "TCSignalCtrlViewController.h"
#import "TVElecPoliceInfo.h"
#import "TVHighCamInfo.h"
#import "TVRoadCamInfo.h"


@interface TCVideoSignalCtrlViewController() <TCSignalCtrlViewControllerDelegate, TCVideosViewControllerDelegate>

@property(nonatomic, strong) TCVideosViewController *vvc;
@property(nonatomic, strong) TCSignalCtrlViewController *svc;

@property(nonatomic, assign) BOOL isVideoDirty; // 视频是否已经改变

@end

@implementation TCVideoSignalCtrlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupConstaints];
}

- (void)addSignalContrller:(TLSignalCtrlerInfo *)scInfo {
    [self.svc addSignalContrller:scInfo];
}

- (void)removeSignalController:(TLSignalCtrlerInfo *)scInfo {
    [self.svc removeSignalController:scInfo];
}

- (void)setupConstaints {
    
    [self.svc.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.vvc.view.mas_right);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.equalTo(@216);
    }];
    
    [self.vvc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.svc.view.mas_left);
    }];
    
    
}

- (void)setSelectedCamArray:(NSArray *)selectedCamArray {
    [self isVideoDirty:_selectedCamArray curSelArray:selectedCamArray];
    _selectedCamArray = selectedCamArray;
    if (self.isVideoDirty) {
        self.vvc.selVieoArray = _selectedCamArray;
    }
}

- (void)isVideoDirty:(NSArray *)preSelectedArray
         curSelArray:(NSArray *)curSelArray {
    self.isVideoDirty = NO;
    if (preSelectedArray == nil && curSelArray.count > 0) {
        self.isVideoDirty = YES;
        return;
    }
    
    if (preSelectedArray.count != curSelArray.count) {
        self.isVideoDirty = YES;
        return;
    }
    
    [curSelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __block id curObj = obj;
        __block BOOL equal = NO;
        [preSelectedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TVCamInfo *camInfo = curObj;
            if ([camInfo isSameCam:obj]) {
                equal = YES;
                *stop = YES;
            }
        }];
        if (equal == NO) {
            self.isVideoDirty = YES;
            *stop = YES;
        }
    }];
}



#pragma mark - getter

- (TCSignalCtrlViewController *)svc {
    if (_svc == nil) {
        _svc = [[TCSignalCtrlViewController alloc] init];
        [self addChildViewController:_svc];
        [self.view addSubview:_svc.view];
        [_svc didMoveToParentViewController:self];
        _svc.delegate = self;
    }
    return _svc;
}

- (TCVideosViewController *)vvc {
    if (_vvc == nil) {
        _vvc = [[TCVideosViewController alloc] init];
        _vvc.delegate = self;
        [self.view addSubview:_vvc.view];
        [_vvc didMoveToParentViewController:self];
    }
    return _vvc;
}


- (void)resumeAll {
    [self.vvc resumeAll];
}

#pragma mark -delegate
- (void)TCSignalCtrlViewControllerBackToMapBtnPressed:(TCSignalCtrlViewController *)signalCtrlViewController {
    if ([self.delegate respondsToSelector:@selector(TCVideoSignalCtrlViewControllerBackToMapBtnPressed:)]) {
        [self.delegate TCVideoSignalCtrlViewControllerBackToMapBtnPressed:self];
    }
    [self.vvc pauseAll];
}

- (void)TCSignalCtrlViewController:(TCSignalCtrlViewController *)signalCtrlViewController didDeleteScInfo:(TLSignalCtrlerInfo *)scInfo {
    if ([self.delegate respondsToSelector:@selector(TCVideoSignalCtrlViewController:didDeleteScInfo:)]) {
        [self.delegate TCVideoSignalCtrlViewController:self didDeleteScInfo:scInfo];
    }
}

- (void)TCVideosViewController:(TCVideosViewController *)videoVC
                  camDidClosed:(TVCamInfo *)camInfo {
    NSMutableArray *ma = [NSMutableArray arrayWithArray:self.selectedCamArray];
    [ma removeObject:camInfo];
    _selectedCamArray = ma;
    if ([self.delegate respondsToSelector:@selector(TCVideoSignalCtrlViewController:camDidClosed:)]) {
        [self.delegate TCVideoSignalCtrlViewController:self camDidClosed:camInfo];
    }
}

@end
