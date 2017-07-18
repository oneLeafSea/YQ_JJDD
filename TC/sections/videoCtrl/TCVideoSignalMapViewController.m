//
//  TCVideoSignalMapViewController.m
//  TC
//
//  Created by 郭志伟 on 15/11/16.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TCVideoSignalMapViewController.h"

#import "TCMapViewController.h"
#import "TCVideoSignalCtrlViewController.h"
#import "TCMainViewController.h"

#import <Masonry/Masonry.h>

@interface TCVideoSignalMapViewController() <TCMapViewControllerDelegate, TCVideoSignalCtrlViewControllerDelegate>

@property(nonatomic, strong) TCMapViewController *mapVC;
@property(nonatomic, strong) TCVideoSignalCtrlViewController *vscVC;
@end

@implementation TCVideoSignalMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (void)commonInit {
    [self.vscVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.mapVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

#pragma mark -getter
- (TCMapViewController *)mapVC {
    if (_mapVC == nil) {
        _mapVC = [[TCMapViewController alloc] init];
        [self addChildViewController:_mapVC];
        [self.view addSubview:_mapVC.view];
        [_mapVC didMoveToParentViewController:self];
        _mapVC.delegate = self;
    }
    return _mapVC;
}

- (TCVideoSignalCtrlViewController *)vscVC {
    if (_vscVC == nil) {
        _vscVC = [[TCVideoSignalCtrlViewController alloc] init];
        [self addChildViewController:_vscVC];
        [self.view  addSubview:_vscVC.view];
        _vscVC.view.hidden = YES;
        [_vscVC didMoveToParentViewController:self];
        _vscVC.delegate = self;
    }
    return _vscVC;
}

#pragma mark - mapView delegate

- (void)mapViewControllerShiftBtnPressed:(TCMapViewController *)mapViewController {
    if ([self.parentViewController isKindOfClass:[TCMainViewController class]]) {
        self.vscVC.view.hidden = NO;
        TCMainViewController * mainVC = (TCMainViewController *)self.parentViewController;
        [mainVC hideLeftViewController:YES];
        [mainVC hideCloseLeftViewControllerButton:YES];
        [UIView transitionFromView:self.mapVC.view
                            toView:self.vscVC.view
                          duration:0.6
                           options:UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionShowHideTransitionViews
                        completion:^(BOOL finished) {
                            self.mapVC.view.hidden = YES;
                            [self.view bringSubviewToFront:self.vscVC.view];
                            self.vscVC.selectedCamArray = self.mapVC.selectedCamArray;
                           
                            [self.vscVC resumeAll];
                        }];
        
    }

}

- (void)mapViewController:(TCMapViewController *)mapViewController SignalCtrlerDidSelected:(BOOL)selected SignalCtrlerInfo:(TLSignalCtrlerInfo *)scInfo {
    if (selected) {
        [self.vscVC addSignalContrller:scInfo];
        
        
    } else {
        [self.vscVC removeSignalController:scInfo];
    }
}

#pragma mark - video signal control deleagte
- (void)TCVideoSignalCtrlViewControllerBackToMapBtnPressed:(TCVideoSignalCtrlViewController *)videoSignalCtrlViewController {
    if ([self.parentViewController isKindOfClass:[TCMainViewController class]]) {
        self.mapVC.view.hidden = NO;
        TCMainViewController * mainVC = (TCMainViewController *)self.parentViewController;
        [mainVC hideLeftViewController:NO];
        [mainVC hideCloseLeftViewControllerButton:NO];
        [UIView transitionFromView:self.vscVC.view
                            toView:self.mapVC.view
                          duration:0.6
                           options:UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionShowHideTransitionViews
                        completion:^(BOOL finished) {
                            self.vscVC.view.hidden = YES;
                            [self.view bringSubviewToFront:self.mapVC.view];
                        }];
        
    }
}

- (void)TCVideoSignalCtrlViewController:(TCVideoSignalCtrlViewController *)videoSignalCtrlViewController didDeleteScInfo:(TLSignalCtrlerInfo *)scInfo {
    [self.mapVC deleteScInfo:scInfo];
}

- (void)TCVideoSignalCtrlViewController:(TCVideoSignalCtrlViewController *)videoSignalCtrlViewController camDidClosed:(TVCamInfo *)camInfo {
    [self.mapVC deleteCamInfo:camInfo];
}

@end
