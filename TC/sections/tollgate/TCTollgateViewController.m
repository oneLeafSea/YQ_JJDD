//
//  TCTollgateViewController.m
//  TC
//
//  Created by 郭志伟 on 16/3/3.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import "TCTollgateViewController.h"
#import <Masonry/Masonry.h>
#import "TCTollgateDetailViewController.h"
#import "TCTollgateNotification.h"
#import "AppDelegate.h"

@interface TCTollgateViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *briefTableView;

@property(nonatomic, strong) TCTollgateDetailViewController *detailVC;

@property(nonatomic, strong) NSArray *tgns;

@end

@implementation TCTollgateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tgns = [TCTollgateNotification getNotificationWithDbq:APP_DELEGATE.usr.dbq ByLimit:100];
    self.view.backgroundColor = [UIColor yellowColor];
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}


- (void)setup {
    [self.view addSubview:self.briefTableView];
    [self addChildViewController:self.detailVC];
    [self.view addSubview:self.detailVC.view];
    [self.detailVC didMoveToParentViewController:self];
    [self setupConstaints];
}

- (void)setupConstaints {
    [self.briefTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(@300);
        make.bottom.equalTo(self.view);
    }];
    
    [self.detailVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.briefTableView.mas_right);
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
}


- (UITableView *)briefTableView {
    if (_briefTableView == nil) {
        _briefTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _briefTableView.delegate = self;
        _briefTableView.dataSource = self;
    }
    return _briefTableView;
}

- (TCTollgateDetailViewController *)detailVC {
    if (_detailVC == nil) {
        _detailVC = [[TCTollgateDetailViewController alloc] init];
    }
    return _detailVC;
}

#pragma mark - delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"demo"];
    cell.textLabel.text = @"测试";
    return cell;
}

@end
