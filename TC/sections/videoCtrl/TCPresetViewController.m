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
#import "TCVideoContainerView.h"
#import "UVLog.h"
@interface TCPresetViewController()  <UITableViewDataSource, UITableViewDelegate>


@property(nonatomic, strong)UIActivityIndicatorView *waitView;


@end

@implementation TCPresetViewController



- (void)queryPreset {
    //self.tableView.hidden = YES;
    [self.waitView startAnimating];
    [APP_DELEGATE.tvMgr.request execRequest:^{
        UVQueryCondition *condition = [[UVQueryCondition alloc] init];
        [condition setIsQuerySub:YES];
        [condition setOffset:0];
        [condition setLimit:32];
        UVQueryPresetListParam *param = [[UVQueryPresetListParam alloc] init];
       [param setCameraCode:self.resInfo.resCode];
        [param setPageInfo:condition];
        
     [APP_DELEGATE.tvMgr.service cameraQueryPresetList:param];
        
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
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self setupConstraints];
    [self queryPreset];
    UVQueryCondition *condition = [[UVQueryCondition alloc] init];
    [condition setIsQuerySub:YES];
    [condition setOffset:0];
    [condition setLimit:32];
    UVQueryPresetListParam *param = [[UVQueryPresetListParam alloc] init];
    [param setCameraCode:self.resInfo.resCode];
    [param setPageInfo:condition];
    self.presetList = [APP_DELEGATE.tvMgr.service cameraQueryPresetList:param];
    
}

#pragma mark - getter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.hidden=YES;
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
    NSLog(@"self::%ld",self.presetList.count);
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
        UVPresetInfo *info =[self.presetList objectAtIndex:indexPath.row];
       NSLog(@"%d",info.presetValue);
        UVPresetParam *param = [[UVPresetParam alloc] init];
        param.presetValue = info.presetValue;
       
        param.cameraCode = self.resInfo.resCode;
        
        [APP_DELEGATE.tvMgr.request execRequest:^{
            
         [APP_DELEGATE.tvMgr.service cameraUsePreset:param];
           
        }finish:^(UVError *error) {
             NSLog(@"error:%@",error);
          
            if ([self.delegate respondsToSelector:@selector(TCPresetViewController:  SetPresetResult:error:)]) {
                if (error == nil) {
                    [self.delegate TCPresetViewController:self  SetPresetResult:YES error:nil];
                    
                } else {
                    [self.delegate TCPresetViewController:self  SetPresetResult:NO error:error];
                    

                }
            }
            
        }];
    }];
}


@end
