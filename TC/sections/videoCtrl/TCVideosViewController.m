//
//  TCVideosViewController.m
//  TC
//
//  Created by 郭志伟 on 15/11/16.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TCVideosViewController.h"

#import <Masonry/Masonry.h>

#import "TCVideoContainerView.h"
#import "AppDelegate.h"
#import "TVHighCamInfo.h"
#import "TVElecPoliceInfo.h"
#import "TVRoadCamInfo.h"
#import "TCReplayViewController.h"
#import "TCPresetViewController.h"
#import "UIView+Toast.h"
#import "UVPresetInfo.h"


@interface TCVideosViewController() <TCVideoContainerViewDelegate, TCReplayViewControllerDelgate, TCPresetViewControllerDelegate>

@property(nonatomic, strong) TCVideoContainerView *firstVideoContrainerView;
@property(nonatomic, strong) TCVideoContainerView *secondVideoContrainerView;
@property(nonatomic, strong) TCVideoContainerView *thirdVideoContrainerView;
@property(nonatomic, strong) TCVideoContainerView *forthVideoContrainerView;

@property(nonatomic, strong) UIView *seperatorHView;
@property(nonatomic, strong) UIView *seperatorVView;

@property(nonatomic, strong) NSMutableArray *idleContainerViews;


@end


@implementation TCVideosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupConstraints];
//    self.view.backgroundColor = [UIColor whiteColor];
    self.idleContainerViews = [[NSMutableArray alloc] initWithCapacity:4];
    [self.idleContainerViews addObject:self.firstVideoContrainerView];
    [self.idleContainerViews addObject:self.secondVideoContrainerView];
    [self.idleContainerViews addObject:self.thirdVideoContrainerView];
    [self.idleContainerViews addObject:self.forthVideoContrainerView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)pauseAll {
    [self.firstVideoContrainerView pause];
    [self.secondVideoContrainerView pause];
    [self.thirdVideoContrainerView pause];
    [self.forthVideoContrainerView pause];
}
- (void)resumeAll {
    if (![self isRemovedVideo:self.firstVideoContrainerView]) {
        [self.firstVideoContrainerView resume];
    }
    
    if (![self isRemovedVideo:self.secondVideoContrainerView]) {
        [self.secondVideoContrainerView resume];
    }
    
    if (![self isRemovedVideo:self.thirdVideoContrainerView]) {
        [self.thirdVideoContrainerView resume];
    }
    
    if (![self isRemovedVideo:self.forthVideoContrainerView]) {
        [self.forthVideoContrainerView resume];
    }
    
}

- (void)setSelVieoArray:(NSArray *)selVieoArray {
    _selVieoArray = selVieoArray;
    [self removeVideosWithCompletion:^{
        [self addVideos];
    }];
}

- (void)removeVideosWithCompletion:(void(^)())completion {
     dispatch_group_t waitGroup = dispatch_group_create();
    if ([self isRemovedVideo:self.firstVideoContrainerView]) {
        dispatch_group_enter(waitGroup);
        [self.firstVideoContrainerView stopPlayWithBlock:^{
            [self.firstVideoContrainerView resetCamInfoAndResource];
            [self addToIdleVcContainers:self.firstVideoContrainerView];
            dispatch_group_leave(waitGroup);
        }];
        
    }
    if ([self isRemovedVideo:self.secondVideoContrainerView]) {
        dispatch_group_enter(waitGroup);
        [self.secondVideoContrainerView stopPlayWithBlock:^{
            [self.secondVideoContrainerView resetCamInfoAndResource];
            [self addToIdleVcContainers:self.secondVideoContrainerView];
            dispatch_group_leave(waitGroup);
        }];
       
    }
    
    if ([self isRemovedVideo:self.thirdVideoContrainerView]) {
        dispatch_group_enter(waitGroup);
        [self.thirdVideoContrainerView stopPlayWithBlock:^{
            [self.thirdVideoContrainerView resetCamInfoAndResource];
            [self addToIdleVcContainers:self.thirdVideoContrainerView];
            dispatch_group_leave(waitGroup);
        }];
        
    }
    
    if ([self isRemovedVideo:self.forthVideoContrainerView]) {
        dispatch_group_enter(waitGroup);
        [self.forthVideoContrainerView stopPlayWithBlock:^{
            [self.forthVideoContrainerView resetCamInfoAndResource];
            [self addToIdleVcContainers:self.forthVideoContrainerView];
            dispatch_group_leave(waitGroup);
        }];
    }
    dispatch_group_notify(waitGroup, dispatch_get_main_queue(), ^{
        if (completion) {
            completion();
        }
    });
}

- (void)addVideos {
    // 获取到没有被加入的视频
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:4];
    [self.selVieoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!([self.firstVideoContrainerView.camInfo isSameCam:obj]
            || [self.secondVideoContrainerView.camInfo isSameCam:obj]
            || [self.thirdVideoContrainerView.camInfo isSameCam:obj]
              || [self.forthVideoContrainerView.camInfo isSameCam:obj])) {
            [mutableArray addObject:obj];
        }
    }];
    
    [mutableArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TVCamInfo *camInfo = obj;
        if (self.idleContainerViews.count > 0) {
            TCVideoContainerView *vcView = self.idleContainerViews[0];
            [self.idleContainerViews removeObjectAtIndex:0];
            [vcView startPlayWithCamInfo:camInfo];
        } else {
            NSLog(@"视频不匹配,异常错误！");
            *stop = YES;
        }
    }];
}

- (void)addToIdleVcContainers:(TCVideoContainerView *)containerView {
    if ([self.idleContainerViews containsObject:containerView]) {
        return;
    }
    __block NSInteger index = 0;
    __block NSInteger found = NO;
    [self.idleContainerViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TCVideoContainerView *vc = obj;
        if (vc.tag > containerView.tag) {
            index = idx;
            *stop = YES;
            found = YES;
        }
    }];
    if (found) {
        [self.idleContainerViews insertObject:containerView atIndex:index];
    } else {
        [self.idleContainerViews addObject:containerView];
    }
    
    [self.idleContainerViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TCVideoContainerView *vc = obj;
        NSLog(@"vc tag:%ld", (long)vc.tag);
    }];
}



- (BOOL)isRemovedVideo:(TCVideoContainerView *) vcView {
    __block BOOL removed = YES;
    [self.selVieoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([vcView.camInfo isSameCam:obj]) {
            removed = NO;
            *stop = YES;
        }
    }];
    return removed;
}

#pragma mark - getter
- (TCVideoContainerView *)firstVideoContrainerView {
    if (_firstVideoContrainerView == nil) {
        _firstVideoContrainerView = [[TCVideoContainerView alloc] initWithFrame:CGRectZero];
        _firstVideoContrainerView.tag = 0;
        _firstVideoContrainerView.delegate = self;
        _firstVideoContrainerView.presentViewController = self;
        [self.view addSubview:_firstVideoContrainerView];
    }
    return _firstVideoContrainerView;
}

- (TCVideoContainerView *)secondVideoContrainerView {
    if (_secondVideoContrainerView == nil) {
        _secondVideoContrainerView = [[TCVideoContainerView alloc] initWithFrame:CGRectZero];
        _secondVideoContrainerView.tag = 1;
        _secondVideoContrainerView.delegate = self;
        _secondVideoContrainerView.presentViewController = self;
        [self.view addSubview:_secondVideoContrainerView];
    }
    return _secondVideoContrainerView;
}

- (TCVideoContainerView *)thirdVideoContrainerView {
    if (_thirdVideoContrainerView == nil) {
        _thirdVideoContrainerView = [[TCVideoContainerView alloc] initWithFrame:CGRectZero];
        _thirdVideoContrainerView.tag = 2;
        _thirdVideoContrainerView.delegate = self;
        _thirdVideoContrainerView.presentViewController = self;
        [self.view addSubview:_thirdVideoContrainerView];
    }
    return _thirdVideoContrainerView;
}

- (TCVideoContainerView *)forthVideoContrainerView {
    if (_forthVideoContrainerView == nil) {
        _forthVideoContrainerView = [[TCVideoContainerView alloc] initWithFrame:CGRectZero];
        _forthVideoContrainerView.tag = 3;
        _forthVideoContrainerView.delegate = self;
        _forthVideoContrainerView.presentViewController = self;
        [self.view addSubview:_forthVideoContrainerView];
    }
    return _forthVideoContrainerView;
}

- (UIView *)seperatorHView {
    if (_seperatorHView == nil) {
        _seperatorHView = [[UIView alloc] initWithFrame:CGRectZero];
        _seperatorHView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:_seperatorHView];
    }
    return _seperatorHView;
}

- (UIView *)seperatorVView {
    if (_seperatorVView == nil) {
        _seperatorVView = [[UIView alloc] initWithFrame:CGRectZero];
        _seperatorVView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:_seperatorVView];
    }
    return _seperatorVView;
}

#pragma makr - private method

- (void)setupConstraints {
    // 设置第一个videocontainter
    [self.firstVideoContrainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.equalTo(self.view.mas_width).dividedBy(2);
        make.height.equalTo(self.view.mas_height).dividedBy(2);
        make.top.equalTo(self.view);
    }];
    
    // 设置第二个videocontainter
    [self.secondVideoContrainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.width.equalTo(self.view.mas_width).dividedBy(2);
        make.height.equalTo(self.view.mas_height).dividedBy(2);
        make.top.equalTo(self.view);
    }];
    
    // 设置第三个videocontainter
    [self.thirdVideoContrainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.equalTo(self.view.mas_width).dividedBy(2);
        make.height.equalTo(self.view.mas_height).dividedBy(2);
        make.bottom.equalTo(self.view);
    }];
    
    // 设置第四个videocontainter
    [self.forthVideoContrainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.width.equalTo(self.view.mas_width).dividedBy(2);
        make.height.equalTo(self.view.mas_height).dividedBy(2);
        make.bottom.equalTo(self.view);
    }];
    
    [self.seperatorVView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(@1);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self.seperatorHView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.height.equalTo(@1);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
}

- (void)TCVideoContainerViewDidTapped:(TCVideoContainerView *)containerView {
    if ([containerView isEqual:self.firstVideoContrainerView]) {
        if (self.firstVideoContrainerView.playing || self.firstVideoContrainerView.isFullScreen) {
            if (self.firstVideoContrainerView.isFullScreen == NO) {
                [UIView animateWithDuration:0.5 animations:^{
                    [self.firstVideoContrainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.view);
                        make.width.equalTo(self.view.mas_width);
                        make.height.equalTo(self.view.mas_height);
                        make.top.equalTo(self.view);
                    }];
                    self.secondVideoContrainerView.hidden = YES;
                    self.thirdVideoContrainerView.hidden = YES;
                    self.forthVideoContrainerView.hidden = YES;
                    self.firstVideoContrainerView.isFullScreen = YES;
                    self.seperatorHView.hidden = YES;
                    self.seperatorVView.hidden = YES;
                    [self.view bringSubviewToFront:self.firstVideoContrainerView];
                    [self.view layoutIfNeeded];
                }];
                
            } else {
                [UIView animateWithDuration:0.5 animations:^{
                    [self.firstVideoContrainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.view);
                        make.width.equalTo(self.view.mas_width).dividedBy(2);
                        make.height.equalTo(self.view.mas_height).dividedBy(2);
                        make.top.equalTo(self.view);
                    }];
                    self.secondVideoContrainerView.hidden = NO;
                    self.thirdVideoContrainerView.hidden = NO;
                    self.forthVideoContrainerView.hidden = NO;
                    self.firstVideoContrainerView.isFullScreen = NO;
                    self.seperatorHView.hidden = NO;
                    self.seperatorVView.hidden = NO;
                    [self.view bringSubviewToFront:self.seperatorHView];
                    [self.view bringSubviewToFront:self.seperatorVView];
                    [self.view layoutIfNeeded];
                }];
            }
        }
    }
    
    if ([containerView isEqual:self.secondVideoContrainerView]) {
        if (self.secondVideoContrainerView.playing || self.secondVideoContrainerView.isFullScreen ) {
            if (self.secondVideoContrainerView.isFullScreen == NO) {
                [UIView animateWithDuration:0.5 animations:^{
                    [self.secondVideoContrainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(self.view);
                        make.width.equalTo(self.view.mas_width);
                        make.height.equalTo(self.view.mas_height);
                        make.top.equalTo(self.view);
                    }];
                    self.firstVideoContrainerView.hidden = YES;
                    self.thirdVideoContrainerView.hidden = YES;
                    self.forthVideoContrainerView.hidden = YES;
                    self.secondVideoContrainerView.isFullScreen = YES;
                    self.seperatorHView.hidden = YES;
                    self.seperatorVView.hidden = YES;
                    [self.view bringSubviewToFront:self.secondVideoContrainerView];
                    [self.view layoutIfNeeded];
                }];
                
            } else {
                [UIView animateWithDuration:0.5 animations:^{
                    [self.secondVideoContrainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(self.view);
                        make.width.equalTo(self.view.mas_width).dividedBy(2);
                        make.height.equalTo(self.view.mas_height).dividedBy(2);
                        make.top.equalTo(self.view);
                    }];
                    self.firstVideoContrainerView.hidden = NO;
                    self.thirdVideoContrainerView.hidden = NO;
                    self.forthVideoContrainerView.hidden = NO;
                    self.secondVideoContrainerView.isFullScreen = NO;
                    self.seperatorHView.hidden = NO;
                    self.seperatorVView.hidden = NO;
                    [self.view bringSubviewToFront:self.seperatorHView];
                    [self.view bringSubviewToFront:self.seperatorVView];
                    [self.view layoutIfNeeded];
                }];
            }
        }
    }
    
    if ([containerView isEqual:self.thirdVideoContrainerView]) {
        if (self.thirdVideoContrainerView.playing || self.thirdVideoContrainerView.isFullScreen) {
            if (self.thirdVideoContrainerView.isFullScreen == NO) {
                [UIView animateWithDuration:0.5 animations:^{
                    [self.thirdVideoContrainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.view);
                        make.width.equalTo(self.view.mas_width);
                        make.height.equalTo(self.view.mas_height);
                        make.bottom.equalTo(self.view);
                    }];
                    self.firstVideoContrainerView.hidden = YES;
                    self.secondVideoContrainerView.hidden = YES;
                    self.forthVideoContrainerView.hidden = YES;
                    self.thirdVideoContrainerView.isFullScreen = YES;
                    self.seperatorHView.hidden = YES;
                    self.seperatorVView.hidden = YES;
                    [self.view bringSubviewToFront:self.thirdVideoContrainerView];
                    [self.view layoutIfNeeded];
                }];
                
            } else {
                [UIView animateWithDuration:0.5 animations:^{
                    [self.thirdVideoContrainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.view);
                        make.width.equalTo(self.view.mas_width).dividedBy(2);
                        make.height.equalTo(self.view.mas_height).dividedBy(2);
                        make.bottom.equalTo(self.view);
                    }];
                    self.firstVideoContrainerView.hidden = NO;
                    self.secondVideoContrainerView.hidden = NO;
                    self.forthVideoContrainerView.hidden = NO;
                    self.thirdVideoContrainerView.isFullScreen = NO;
                    self.seperatorHView.hidden = NO;
                    self.seperatorVView.hidden = NO;
                    [self.view bringSubviewToFront:self.seperatorHView];
                    [self.view bringSubviewToFront:self.seperatorVView];
                    [self.view layoutIfNeeded];
                }];
            }
        }
    }
    
    if ([containerView isEqual:self.forthVideoContrainerView]) {
        if (self.forthVideoContrainerView.playing || self.forthVideoContrainerView.isFullScreen) {
            if (self.forthVideoContrainerView.isFullScreen == NO) {
                [UIView animateWithDuration:0.5 animations:^{
                    [self.forthVideoContrainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(self.view);
                        make.width.equalTo(self.view.mas_width);
                        make.height.equalTo(self.view.mas_height);
                        make.bottom.equalTo(self.view);
                    }];
                    self.firstVideoContrainerView.hidden = YES;
                    self.secondVideoContrainerView.hidden = YES;
                    self.thirdVideoContrainerView.hidden = YES;
                    self.forthVideoContrainerView.isFullScreen = YES;
                    self.seperatorHView.hidden = YES;
                    self.seperatorVView.hidden = YES;
                    [self.view bringSubviewToFront:self.forthVideoContrainerView];
                    [self.view layoutIfNeeded];
                }];
                
            } else {
                [UIView animateWithDuration:0.5 animations:^{
                    [self.forthVideoContrainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(self.view);
                        make.width.equalTo(self.view.mas_width).dividedBy(2);
                        make.height.equalTo(self.view.mas_height).dividedBy(2);
                        make.bottom.equalTo(self.view);
                    }];
                    self.firstVideoContrainerView.hidden = NO;
                    self.secondVideoContrainerView.hidden = NO;
                    self.thirdVideoContrainerView.hidden = NO;
                    self.forthVideoContrainerView.isFullScreen = NO;
                    self.seperatorHView.hidden = NO;
                    self.seperatorVView.hidden = NO;
                    [self.view bringSubviewToFront:self.seperatorHView];
                    [self.view bringSubviewToFront:self.seperatorVView];
                    [self.view layoutIfNeeded];
                }];
            }
        }
    }
}

- (void)TCVideoContainerView:(TCVideoContainerView *)containerView FullScreenBtnDidTapped:(UIButton *)fullScreenBtn {
    [self TCVideoContainerViewDidTapped:containerView];
}

- (void)TCVideoContainerView:(TCVideoContainerView *)containerView replayBtnDidTapped:(UIButton *)replayBtn camInfo:(TVCamInfo *)camInfo {
    if (camInfo == nil || containerView.resource == nil) {
        return;
    }
    TCReplayViewController *replayVC = [[TCReplayViewController alloc] init];
    replayVC.delegate = self;
    replayVC.camInfo = containerView.camInfo;
    replayVC.resInfo = containerView.resource;
    [self.view.window.rootViewController presentViewController:replayVC animated:YES completion:^{
        [self pauseAll];
    }];
}

- (void)TCVideoContainerView:(TCVideoContainerView *)containerView closeBtnDidTapped:(UIButton *)replayBtn camInfo:(TVCamInfo *)camInfo {
    [containerView stopPlayWithBlock:^{
        [containerView resetCamInfoAndResource];
        [self addToIdleVcContainers:containerView];
        [self TCVideoContainerViewDidTapped:containerView];
    }];
    if ([self.delegate respondsToSelector:@selector(TCVideosViewController:camDidClosed:)]) {
        [self.delegate TCVideosViewController:self camDidClosed:camInfo];
    }
}

- (void)TCVideoContainerView:(TCVideoContainerView *)containerView presetDidTapped:(UIButton *)presetBtn {
    TCPresetViewController *pvc = [[TCPresetViewController alloc] init];
    pvc.delegate = self;
    pvc.resInfo = containerView.resource;
    if([self respondsToSelector:@selector(popoverPresentationController)] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        pvc.modalPresentationStyle = UIModalPresentationPopover;
        pvc.popoverPresentationController.sourceView = containerView;
        UIButton *button = presetBtn;
        pvc.popoverPresentationController.sourceRect = button.frame;
    }
    pvc.preferredContentSize = CGSizeMake(300, 300);
    [self presentViewController:pvc animated:YES completion:nil];
}

- (void)addPreset:(NSString *)desc
            value:(NSString *)value
          resCode:(NSString *)resCode
    containerView:(TCVideoContainerView *)containerView {
    [APP_DELEGATE.tvMgr.request execRequest:^{
        UVPresetInfo *info = [[UVPresetInfo alloc] init];
        [info setPresetValue:[value intValue]];
        [info setPresetDesc:desc];
        [APP_DELEGATE.tvMgr.service cameraSetPreset:resCode presetInfo:info];
    }finish:^(UVError *error) {
        if (error) {
            [containerView makeToast:[NSString stringWithFormat:@"创建失败：%@", error.message]];
        }
        else {
            [containerView makeToast:@"创建预置位成功。"];
        }
    }];
}

- (void)TCVideoContainerView:(TCVideoContainerView *)containerView addPresetDidTapped:(UIButton *)presetBtn {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"创建预置位" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"预置位号";
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"预置位描述";
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *value = [ac.textFields objectAtIndex:0].text;
        NSString *desc = [ac.textFields objectAtIndex:1].text;
        [self addPreset:desc value:value resCode:containerView.resource.resCode containerView:containerView];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [ac addAction:okAction];
    [ac addAction:cancelAction];
    [self presentViewController:ac animated:YES completion:^{
        
    }];
}

- (void)TCReplayViewControllerDidClose:(TCReplayViewController *)relpalyVC {
    [self resumeAll];
}


- (void)TCPresetViewController:(TCPresetViewController *)presetViewController SetPresetResult:(BOOL)sucess error:(UVError *)error {
    UVResourceInfo *resInfo = presetViewController.resInfo;
    TCVideoContainerView *containerView = nil;
    
    do {
        if ([self.firstVideoContrainerView.resource isEqual:resInfo]) {
            containerView = self.firstVideoContrainerView;
            break;
        }
        
        if ([self.secondVideoContrainerView.resource isEqual:resInfo]) {
            containerView = self.secondVideoContrainerView;
            break;
        }
        
        if ([self.thirdVideoContrainerView.resource isEqual:resInfo]) {
            containerView = self.thirdVideoContrainerView;
            break;
        }
        
        if ([self.forthVideoContrainerView.resource isEqual:resInfo]) {
            containerView = self.forthVideoContrainerView;
            break;
        }
        
    } while (0);
    if (sucess) {
        [containerView makeToast:@"设置预置位成功！"];
    } else {
        [containerView makeToast:[NSString stringWithFormat:@"设置预置位失败:%@", error.message]];
    }
    
}

@end
