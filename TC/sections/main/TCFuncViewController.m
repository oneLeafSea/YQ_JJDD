//
//  TCFuncViewController.m
//  TC
//
//  Created by 郭志伟 on 15/11/12.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TCFuncViewController.h"

#import <Masonry/Masonry.h>

#import "UIColor+Hexadecimal.h"
#import "UIView+TC.h"
#import "TCFuncTableViewCell.h"
#import "AppDelegate.h"



@interface TCFuncViewController() <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) UIView *roundViewContainer;

@property(nonatomic, strong) UIButton *exitBtn;

@end

@implementation TCFuncViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:@"#343f51"];
    [self setupConstaints];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO  scrollPosition:UITableViewScrollPositionTop];
    TCFuncTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell cellSelected:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.roundViewContainer makeRounded];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorColor:[UIColor colorWithHex:@"#252C3D"]];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self.view addSubview:_tableView];
        _tableView.backgroundColor = [UIColor colorWithHex:@"#343f51"];
        _tableView.scrollEnabled = NO;
        [_tableView registerClass:[TCFuncTableViewCell class] forCellReuseIdentifier:@"TCFuncTableViewCell"];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}

- (UIView *)roundViewContainer {
    if (_roundViewContainer == nil) {
        _roundViewContainer = [[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_roundViewContainer];
        _roundViewContainer.backgroundColor = [UIColor whiteColor];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"func_avatar"]];
        [_roundViewContainer addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_roundViewContainer);
        }];
    }
    return _roundViewContainer;
}

- (UIButton *)exitBtn {
    if (_exitBtn == nil) {
        _exitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _exitBtn.layer.cornerRadius = 8.0f;
        [_exitBtn setTitle:@"退出" forState:UIControlStateNormal];
        [_exitBtn setBackgroundImage:[UIImage imageNamed:@"func_exit"] forState:UIControlStateNormal];
        [_exitBtn addTarget:self action:@selector(handleExit) forControlEvents:UIControlEventTouchUpInside];
        [_exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:_exitBtn];
    }
    return _exitBtn;
}

- (void)setupConstaints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(132);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-60);
    }];
    
    [self.roundViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(27);
        make.height.equalTo(@76);
        make.width.equalTo(@76);
        make.centerX.equalTo(self.view);
    }];
    
    [self.exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(@190);
        make.height.equalTo(@30);
        make.bottom.equalTo(self.view).offset(-10);
    }];
}


#pragma mark - UITableViewDelegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCFuncTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCFuncTableViewCell" forIndexPath:indexPath];
    
    NSDictionary *dict = [self.tableDatas objectAtIndex:indexPath.row];
    cell.title = dict[@"title"];
    cell.normalImgName = dict[@"normalImg"];
    cell.selectedImgName = dict[@"selectedImg"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TCFuncTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell cellSelected:YES];
    
    if ([self.delegate respondsToSelector:@selector(TCFuncViewController:didSelectedAtIndex: module:)]) {
        [self.delegate TCFuncViewController:self didSelectedAtIndex:indexPath.row module:[self.tableDatas objectAtIndex:indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    TCFuncTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell cellSelected:NO];
}

- (BOOL)isReservedWithClassName:(NSString *)className {
    __block BOOL ret = NO;
    [self.tableDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *vcInfo = obj;
        NSString *name = [vcInfo objectForKey:@"className"];
        if ([name isEqualToString:className]) {
            NSNumber *reserved = [vcInfo objectForKey:@"reserved"];
            if (reserved && [reserved boolValue] == YES) {
                ret = YES;
            }
            *stop = YES;
        }
    }];
    return ret;
}

- (void)handleExit {
     [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationExit object:nil];
    [APP_DELEGATE.tvMgr.request execRequest:^{
        [APP_DELEGATE.tvMgr.service logout:NO];
    } finish:^(UVError *error) {
       
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"loginVC"];
        [APP_DELEGATE changeRootViewController:vc];
    }];
}

@end
