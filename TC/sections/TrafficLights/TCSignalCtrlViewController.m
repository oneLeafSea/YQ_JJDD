//
//  TCSignalCtrlViewController.m
//  TC
//
//  Created by 郭志伟 on 15/11/16.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TCSignalCtrlViewController.h"
#import "TCSignalCtrlView.h"
#import "TCApplyReq.h"
#import "AppDelegate.h"
#import "TLDWSignalCtrlerInfo.h"
#import "TCMapViewController.h"
#import "TLAPI.h"
#import <Masonry/Masonry.h>
#import "JSONKit.h"
#import "TCSignalCtrllerUpdater.h"
@interface TCSignalCtrlViewController() <TCSignalCtrlViewDelegate>

@property(nonatomic, strong) TCSignalCtrlView *scView;

@property(nonatomic,strong)NSString *crossId;
@property(nonatomic,strong)NSString*userUUID;
@property(nonatomic,strong)NSTimer *timer;

@property(nonatomic,strong)NSMutableArray*scCrooIds;
@property(nonatomic,strong)NSString*jsonStrs;
@end

@implementation TCSignalCtrlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
    
}


- (void)commonInit {
    [self.scView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)addSignalContrller:(TLSignalCtrlerInfo *)scInfo {
    [self.scView addSignalContrller:scInfo];
//    NSLog(@"%@",scInfo.crossId);
//    [self.scCrooIds addObject:scInfo.crossId];
//    for (int i =0; i<self.scCrooIds.count; i++) {
//        NSString *str=[self.scCrooIds objectAtIndex:i];
//        NSLog(@"%@",str);
//    }
//    [self.scCrooIds JSONString];
}

- (void)removeSignalController:(TLSignalCtrlerInfo *)scInfo {
    [self.scView removeSignalController:scInfo];
}


#pragma mark -getter
- (TCSignalCtrlView *)scView {
    if (_scView == nil) {
        _scView = [[TCSignalCtrlView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_scView];
        _scView.delegate = self;
    }
    return _scView;
}

#pragma mark -delegate
- (void)signalCtrlViewBackToMapBtnPressed:(TCSignalCtrlView *)signalCtrlView {
    if ([self.delegate respondsToSelector:@selector(TCSignalCtrlViewControllerBackToMapBtnPressed:)]) {
        NSLog(@"%@",self.userUUID);
        if (self.userUUID!=NULL) {
           
            [TLAPI getSingalCtrlReleaseToken:[TLAPI loginToken] reqId:self.userUUID  userId:@"xiangsy" completion:^(BOOL finished) {
                if (finished) {
                    _scView.requestBtn.enabled=YES;
                    
                    [self stopTimer];
                    self.userUUID =NULL;
                    NSLog(@"设备删除");
                    
                }
            }];

        }
                [self.delegate TCSignalCtrlViewControllerBackToMapBtnPressed:self];
    }
}

- (void)signalCtrlView:(TCSignalCtrlView *)signalCtrlView didDeleteScInfo:(TLSignalCtrlerInfo *)scInfo {
    if ([self.delegate respondsToSelector:@selector(TCSignalCtrlViewController:didDeleteScInfo:)]) {
        [self.delegate TCSignalCtrlViewController:self didDeleteScInfo:scInfo];
    }
}

- (void)signalCtrlView:(TCSignalCtrlView *)signalCtrlView requestBtnTapped:(UIButton *)btn {
  btn.enabled=NO;
    self.userUUID = [NSUUID new].UUIDString.lowercaseString;
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSString *userName = [ud objectForKey:@"tv.user"];
    [ud objectForKey:@"tv.pwd"];
    [TLAPI getSingnalCtrlwithTOKEN:[TLAPI loginToken]
                   crossIds:@""        USER_ID:userName REQ_ID:self.userUUID RESULT_PUSH_URL:@"http://10.100.9.20:8082/getJson"Completion:^(BOOL finished) {
        if (finished) {
            [self startTimer];
            
//            if (self.userUUID==nil) {
//                [self stopTimer];
//            }
            //   [self performSelector:@selector(delayAfterFinfished:) withObject:nil afterDelay:60];
            
          }else{
              _scView.requestBtn.enabled=YES;
        }
    
}];
  
    

    
}
-(void)startTimer{
    //_scView.requestBtn.enabled=YES;
     self.timer=[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(delayAfterFinfished:) userInfo:nil repeats:YES];
    
}
-(void)stopTimer{
    [self.timer invalidate];
}
-(void)delayAfterFinfished:(NSString*)reqId{

    
        [TLAPI getUrlfromOurWebSocketWithreqid:self.userUUID  completion:^(NSString*jsonResult,BOOL finished) {
            
            if (finished) {
                NSLog(@"%@",jsonResult);
                
                
                if ([jsonResult isEqualToString:@"A"]) {
                    _scView.requestBtn.enabled=NO;
                    
                    _scView.tableView.hidden=NO;
                    
                    
                }else if([jsonResult isEqualToString:@"R"]){
                    _scView.requestBtn.enabled=YES;
                    _scView.tableView.hidden=YES;
                }else if([jsonResult isEqualToString:@"T"]){
                    _scView.requestBtn.enabled=YES;
                    _scView.tableView.hidden=YES;
                }
            }
            if (finished==NO) {
                _scView.requestBtn.enabled=YES;
                NSLog(@"%@",jsonResult);
                [self stopTimer];
            }
            if ([jsonResult isEqualToString:@"A"]||[jsonResult isEqualToString:@"R"]||[jsonResult isEqualToString:@"T"]) {
                [self stopTimer];
            }
            

 
}];
    


}
@end
