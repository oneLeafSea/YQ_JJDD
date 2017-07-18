//
//  TCTollgateDYViewController.m
//  TC
//
//  Created by guozw on 16/8/24.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import "TCTollgateDYViewController.h"
#import "TCMapViewController.h"
#import <Masonry/Masonry.h>
#import "TCDYDetail.h"
#import "TCTollgateNotification.h"
#import "AppDelegate.h"
#import "TCTollgateDYCell.h"
#import "TCDYNotificatin.h"
#import "TLAPI.h"
#import "RTWSMsgConstants.h"
@interface TCTollgateDYViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tollegateDYView;
@property(nonatomic,strong)NSMutableArray *secArr;
@property(nonatomic, strong) TCDYDetail *detailVC;

@property(nonatomic, strong) NSArray *tgns;
@property(nonatomic,strong)TCMapViewController *tcmap;

@end

@implementation TCTollgateDYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hanlePushDYTollegate:) name:KNotificationDYTollegatePush object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    //[self setupRefresh];
    [self setup];
    //self.secArr=[[NSMutableArray alloc]initWithCapacity:50];
    
    self.tgns=[TCDYNotificatin getNotificationDYWithDbq:APP_DELEGATE.usr.dbq ByLimit:100];
    [self setupRefresh];
    
}
-(void)hanlePushDYTollegate:(NSNotification*)notification{
    RTDYMsg *msg=notification.object;
    NSArray *ns=[TCDYNotificatin notificationArray:msg];
    
    self.secArr=(NSMutableArray*)ns;
    NSLog(@"<>><><><<><>><>%ld",self.secArr.count);
}

-(void)addDeviceId:(TVElecPoliceInfo*)epi{
    NSLog(@"%@",epi);
  
    [self setupRefresh];
}
-(void)removeDeviceId:(TVElecPoliceInfo *)epi{
    //NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:self.marr];
   // [self.marr removeObject:epi.deviceId];
    [self setupRefresh];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

#pragma mark - refresh
-(void)setupRefresh{
    
    UIRefreshControl *refContrl =[[UIRefreshControl alloc]init];
    
    [refContrl addTarget:self action:@selector(refreshShowChange:) forControlEvents:UIControlEventValueChanged];
    [self.tollegateDYView addSubview:refContrl];
    [refContrl beginRefreshing];
    //[self refreshShowChange:refContrl ];

}


//-(void)refreshShowChange:(UIRefreshControl *)refContrl
//{
//    
//    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
//    NSString *name=[ud objectForKey:@"tv.user"];
////    
////    [TLAPI getDYInfomationWithUsername:name completion:^(BOOL finished) {
////       
////    }];
//    self.tgns=[TCDYNotificatin getNotificationDYWithDbq:APP_DELEGATE.usr.dbq ByLimit:100];
//    
//    [self.tollegateDYView reloadData];
//    [refContrl endRefreshing];
//}

- (void)setup {
    [self.view addSubview:self.tollegateDYView];
    [self addChildViewController:self.detailVC];
    [self.view addSubview:self.detailVC.view];
    [self.detailVC didMoveToParentViewController:self];
    [self setupConstaints];
}

- (void)setupConstaints {
    [self.tollegateDYView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(@300);
        make.bottom.equalTo(self.view);
    }];
    
    [self.detailVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.tollegateDYView.mas_right);
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
}

#pragma mark - getter

- (UITableView *)tollegateDYView {
    if (_tollegateDYView == nil) {
        _tollegateDYView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tollegateDYView.delegate = self;
        _tollegateDYView.dataSource = self;
        [_tollegateDYView registerClass:[TCTollgateDYCell class] forCellReuseIdentifier:@"TCTollgateDYCell"];
        _tollegateDYView.estimatedRowHeight = 44;
        _tollegateDYView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tollegateDYView;
}

- (TCDYDetail *)detailVC {
    if (_detailVC == nil) {
        _detailVC = [[TCDYDetail alloc] init];
    }
    return _detailVC;
}



#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (self.secArr.count!=0) {
//         NSLog(@"<><><><>%ld",self.secArr.count);
//        return self.secArr.count;
//    }else{
//        NSLog(@"%ld",self.tgns.count);
//        return self.tgns.count;
//    }
    return self.secArr.count;
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"demo"];
    //    cell.textLabel.text = @"测试";
    TCTollgateDYCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCTollgateDYCell" forIndexPath:indexPath];
    
        TCDYNotificatin *tgn=[self.secArr objectAtIndex:indexPath.row];
        cell.locationLbl.text =tgn.location;
        cell.plateLbl.text =tgn.plateCode;
       cell.descLbl.text =[NSString stringWithFormat:@"%@于%@在%@以%@行驶", tgn.plateCode, tgn.capTime, tgn.location ,tgn.speed] ;
        
    
    //cell.descLbl.text=@"eweeweeweweewew";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.secArr!=NULL) {
        TCDYNotificatin *tgn=[self.secArr objectAtIndex:indexPath.row];
        [self.detailVC setTgDYNotification:tgn];
    }else{
    TCDYNotificatin *tgn = [self.tgns objectAtIndex:indexPath.row];
    [self.detailVC setTgDYNotification:tgn];
    }
}

@end
