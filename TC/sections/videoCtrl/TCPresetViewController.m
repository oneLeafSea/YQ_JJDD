//
//  TCPresetViewController.m
//  TC
//
//  Created by 郭志伟 on 15/12/8.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TCPresetViewController.h"
#import <Masonry/Masonry.h>
#import "AppDelegate.h"
#import "UVQueryPresetListParam.h"
#import "LogLevel.h"
#import "UIView+Toast.h"
#import "env.h"
#import "UVPresetInfo.h"
#import "UVPresetParam.h"

@interface TCPresetViewController()  <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIActivityIndicatorView *waitView;
@property(nonatomic, strong)NSMutableArray  *presetList;

@end

@implementation TCPresetViewController

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.presetList = [[NSMutableArray alloc] initWithCapacity:32];
#ifndef YUAN_QU_DA_DUI
    for (int n = 0; n < 10; n++) {
        UVPresetInfo *presetInfo = [[UVPresetInfo alloc]init];
        presetInfo.presetValue = n;
        presetInfo.presetDesc = [NSString stringWithFormat:@"测试%d", n];
        [self.presetList addObject:presetInfo];
    }
#endif
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self setupConstraints];
}

- (void)queryPreset {
    self.tableView.hidden = YES;
    [self.waitView startAnimating];
    [APP_DELEGATE.tvMgr.request execRequest:^{
        UVQueryCondition *condition = [[UVQueryCondition alloc] init];
        [condition setIsQuerySub:YES];
        [condition setOffset:0];
        [condition setLimit:32];
        UVQueryPresetListParam *param = [[UVQueryPresetListParam alloc] init];
        [param setCameraCode:self.resInfo.resCode];
        [param setPageInfo:condition];
        self.presetList = [APP_DELEGATE.tvMgr.service cameraQueryPresetList:param];
    }finish:^(UVError *error) {
        [self.waitView stopAnimating];
#ifndef YUAN_QU_DA_DUI
        self.tableView.hidden = NO;
#else
        if (error == nil) {
            self.tableView.hidden = NO;
        } else {
            [self.view makeToast:[NSString stringWithFormat:@"查询失败:%@", error.message]];
            DDLogError(@"%@", error.message);
        }
#endif
    }];
}

- (void)delPreset:(UVPresetInfo *)presetInfo {
    [self.waitView startAnimating];
    UVPresetParam *param = [[UVPresetParam alloc] init];
    param.presetValue = presetInfo.presetValue;
    param.cameraCode = self.resInfo.resCode;
    [APP_DELEGATE.tvMgr.request execRequest:^{
        [APP_DELEGATE.tvMgr.service cameraDelPreset:param];
    }finish:^(UVError *error) {
        [self.waitView stopAnimating];
#ifndef YUAN_QU_DA_DUI
        [self.presetList removeObject:presetInfo];
        [self.tableView reloadData];
        [self.view makeToast:@"删除成功"];
#else
        if (error == nil) {
            [self.presetList removeObject:presetInfo];
            [self.view makeToast:@"删除成功"];
            [self.tableView reloadData];
        } else {
            [self.view makeToast:[NSString stringWithFormat:@"删除失败: %@", error.message]];
        }
#endif
    }];
}

- (void)setupConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.waitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self queryPreset];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIActivityIndicatorView *)waitView {
    if (_waitView == nil) {
        _waitView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _waitView.hidesWhenStopped = YES;
        [self.view addSubview:_waitView];
    }
    return _waitView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.presetList.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self delPreset:[self.presetList objectAtIndex:indexPath.row]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UVPresetInfo *pi = [self.presetList objectAtIndex:indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = pi.presetDesc;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        UVPresetInfo *item = [self.presetList objectAtIndex:indexPath.row];
        UVPresetParam *param = [[UVPresetParam alloc] init];
        param.presetValue = item.presetValue;
        param.cameraCode = self.resInfo.resCode;
        [APP_DELEGATE.tvMgr.request execRequest:^{
            [APP_DELEGATE.tvMgr.service cameraUsePreset:param];
        }finish:^(UVError *error) {
            if ([self.delegate respondsToSelector:@selector(TCPresetViewController:SetPresetResult:error:)]) {
                if (error == nil) {
                    [self.delegate TCPresetViewController:self SetPresetResult:YES error:nil];
                } else {
                    [self.delegate TCPresetViewController:self SetPresetResult:NO error:error];
                }
            }
            NSLog(@"error:%@", error.message);
        }];
    }];
}


@end
