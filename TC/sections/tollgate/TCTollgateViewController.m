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
#import "TCBriefTableViewCell.h"

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
    self.view.backgroundColor = [UIColor whiteColor];
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

#pragma mark - getter

- (UITableView *)briefTableView {
    if (_briefTableView == nil) {
        _briefTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _briefTableView.delegate = self;
        _briefTableView.dataSource = self;
        [_briefTableView registerClass:[TCBriefTableViewCell class] forCellReuseIdentifier:@"TCBriefTableViewCell"];
        _briefTableView.estimatedRowHeight = 44;
        _briefTableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _briefTableView;
}

- (TCTollgateDetailViewController *)detailVC {
    if (_detailVC == nil) {
        _detailVC = [[TCTollgateDetailViewController alloc] init];
    }
    return _detailVC;
}



#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tgns.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"demo"];
//    cell.textLabel.text = @"测试";
    TCBriefTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCBriefTableViewCell" forIndexPath:indexPath];
    TCTollgateNotification *tgn = [self.tgns objectAtIndex:indexPath.row];
    cell.locationLbl.text =tgn.location;
    cell.plateLbl.text =tgn.plateCode;
    cell.descLbl.text =[NSString stringWithFormat:@"%@于%@在%@以%@行驶", tgn.plateCode, tgn.capTime, tgn.location ,tgn.speed] ;
    
//    cell.locationLbl.text =tgn ;
//    cell.plateLbl.text = @"苏E12345";
//    cell.descLbl.text = @"这是一个描述的label这是一个描述的label这是一个描述的label这是一个描述的label这是一个描述的label,这是一个描述的label这是一个描述的label这是一个描述的label这是一个描述的label这是一个描述的label";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TCTollgateNotification *tgn = [[TCTollgateNotification alloc] init];
    tgn.imgUrl = @"http://10.100.8.192:8083/tms05guoche1/2016/03/03/16/320594000000060165/16265228105.jpg";
    [self.detailVC setTgNotification:tgn];
    
}

@end
