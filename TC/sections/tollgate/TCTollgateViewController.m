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
#import "TCTollegateBKDetailViewController.h"

#import "UIColor+Hexadecimal.h"

@interface TCTollgateViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *briefTableView;
@property(nonatomic,strong)UITableView *briefBKTableView;
@property(nonatomic,assign)BOOL isSelected;
@property(nonatomic, strong) TCTollgateDetailViewController *detailVC;
@property(nonatomic, strong) NSArray *tgns;


@end

@implementation TCTollgateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *arr1=[[NSArray alloc]init];
    NSArray *arr2=[[NSArray alloc]init];
   arr1=[TCTollgateNotification getNotificationWithDbq:APP_DELEGATE.usr.dbq ByLimit:100];
    arr2=[TCTollgateNotification getNotificationBKWithDbq:APP_DELEGATE.usr.dbq ByLimit:100];
    NSMutableArray *arr=[[NSMutableArray alloc]initWithCapacity:200];
    for (int i=0; i<arr1.count; i++) {
        [arr addObject:arr1[i]];
   }
    for (int i=0; i<arr2.count; i++) {
        [arr addObject:arr2[i]];
    }
    
    NSArray *sortDes = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"capTime" ascending:NO]];
    [arr sortUsingDescriptors:sortDes];
    self.tgns=arr;
    [self.briefTableView reloadData];
    [self setupRefresh];
    [self setup];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.briefTableView deselectRowAtIndexPath:[self.briefTableView indexPathForSelectedRow] animated:YES];

}

#pragma mark - refresh
-(void)setupRefresh
{
    UIRefreshControl *refContrl =[[UIRefreshControl alloc]init];
    [refContrl addTarget:self action:@selector(refreshShowChange:) forControlEvents:UIControlEventValueChanged];
    [self.briefTableView addSubview:refContrl];
    [refContrl beginRefreshing];
    [self refreshShowChange:refContrl];
}

-(void)refreshShowChange:(UIRefreshControl *)refContrl
{   
    //self.tgns = [TCTollgateNotification getNotificationWithDbq:APP_DELEGATE.usr.dbq ByLimit:100];
    NSArray *arr1=[[NSArray alloc]init];
    NSArray *arr2=[[NSArray alloc]init];
    arr1=[TCTollgateNotification getNotificationWithDbq:APP_DELEGATE.usr.dbq ByLimit:100];
    arr2=[TCTollgateNotification getNotificationBKWithDbq:APP_DELEGATE.usr.dbq ByLimit:100];
    NSMutableArray *arr=[[NSMutableArray alloc]initWithCapacity:200];
    for (int i=0; i<arr1.count; i++) {
        [arr addObject:arr1[i]];
    }
    for (int i=0; i<arr2.count; i++) {
        [arr addObject:arr2[i]];
    }
    
    NSArray *sortDes = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"capTime" ascending:NO]];
    [arr sortUsingDescriptors:sortDes];
    self.tgns=arr;
    [self.briefTableView reloadData];
    [refContrl endRefreshing];
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
    NSLog(@"/%ld",self.tgns.count);
    return self.tgns.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
   return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     TCBriefTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCBriefTableViewCell" forIndexPath:indexPath];
     TCTollgateNotification *tgn = [self.tgns objectAtIndex:indexPath.row];
        cell.locationLbl.text =tgn.location;
        cell.plateLbl.text =tgn.plateCode;
    NSLog(@"------>%@------%@-------%@",tgn.alarmControlContent,tgn.alarmControlDes,tgn.alarmContent);
    if (tgn.alarmContrlType!=NULL&&tgn.alarmContent == NULL&&tgn.alarmControlDes!=NULL)
    {
        cell.descLbl.text =[NSString stringWithFormat:@"布控告警车辆%@于%@在%@以%@速率行驶", tgn.plateCode, tgn.capTime, tgn.location ,tgn.speed ] ;
        cell.resonLbl.text=tgn.alarmContrlType;
        cell.descLbl.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
        cell.resonLbl.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
        //cell.backgroundColor=[UIColor redColor];
        cell.desriptionLbl.text = @"布控告警车辆详情";
        cell.desriptionLbl.textColor = [UIColor redColor];
    }
    else if(tgn.alarmContent !=NULL&&tgn.alarmControlDes == NULL)
    {
        cell.descLbl.text =[NSString stringWithFormat:@"违法车辆%@于%@在%@以%@速率行驶,违法代码%@", tgn.plateCode, tgn.capTime, tgn.location ,tgn.speed, tgn.alarmContent] ;
        cell.descLbl.font = [UIFont systemFontOfSize:14];
        cell.resonLbl.hidden = YES;
        [cell.resonLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@1);
        }];
        cell.desriptionLbl.text = @"违法车辆";
        cell.desriptionLbl.textColor = [UIColor lightGrayColor];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
         return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _isSelected=YES;
    
    
        TCTollgateNotification *tgn = [self.tgns objectAtIndex:indexPath.row];
    
        [self.detailVC setTgNotification:tgn];
    //[self.detailVC addGestureRecognizerToView:self.detailVC.imgView];
    TCBriefTableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];

    if (tgn.alarmControlDes) {
        cell.desriptionLbl.text=tgn.alarmControlDes;
        cell.desriptionLbl.textColor = [UIColor redColor];
    }
    [tableView beginUpdates];
    [tableView endUpdates];
    
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    TCBriefTableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    TCTollgateNotification *tgn = [self.tgns objectAtIndex:indexPath.row];
    if (tgn.alarmControlDes) {
        cell.desriptionLbl.text=@"布控车辆详情";
        //[self.detailVC returnToOrignSize];
        cell.desriptionLbl.textColor = [UIColor redColor];
    }
    
    [tableView beginUpdates];
    [tableView endUpdates];
    
}

@end
