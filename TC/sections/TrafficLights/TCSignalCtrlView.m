//
//  TCSignalCtrlView.m
//  TC
//
//  Created by 郭志伟 on 15/11/16.
//  Copyright © 2015年 ;. All rights reserved.
//

#import "TCSignalCtrlView.h"
#import "UIColor+Hexadecimal.h"
#import "UIImage+TC.h"
#import "TCSignalCtrlHeadView.h"
#import "TCSignalCtrlTableViewCell.h"
#import "TCSignalCtrllerUpdater.h"
#import "TLSignaleCtrllerRunTimeInfo.h"
#import "TCSignalCtrllerOperator.h"
#import "TLAPI.h"
#import "JSONKit.h"

#import <Masonry/Masonry.h>

@interface TCSignalCtrlView() <UITableViewDataSource, UITableViewDelegate, TCSignalCtrlHeadViewDelegate, TCSignalCtrllerUpdaterDelegate, TCSignalCtrlTableViewCellDelegate>

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *requestBtn;
@property(nonatomic, strong) UIButton *backtoMapBtn;


@property(nonatomic, copy) NSString *selectedCtrllerId;
@property(nonatomic, strong) NSMutableArray *mutableScInfoArray;
@property(nonatomic, strong) TCSignalCtrllerUpdater *scUpdater;
@property(nonatomic, strong) TCSignalCtrllerOperator *scOperator;


@end

@implementation TCSignalCtrlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}


- (void)awakeFromNib {
    [self commonInit];
}


- (void)commonInit {
    self.selectedCtrllerId = nil;
    self.mutableScInfoArray = [[NSMutableArray alloc] initWithCapacity:16];
    self.backgroundColor = [UIColor colorWithHex:@"#343f51"];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(12);
        make.centerX.equalTo(self);
    }];
    
    [self.requestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.height.equalTo(@34);
        make.top.equalTo(self.titleLabel).offset(50);
    }];
    
    [self.backtoMapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.requestBtn.mas_right).offset(10);
        make.top.equalTo(self.requestBtn);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.equalTo(self.requestBtn);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.requestBtn.mas_bottom).offset(32);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

- (BOOL)isExistSC:(TLSignalCtrlerInfo *)scInfo {
    __block BOOL ret = NO;
    [self.mutableScInfoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TLSignalCtrlerInfo *info = obj;
        if ([scInfo.ctrlerId isEqualToString:info.ctrlerId]) {
            ret = YES;
            *stop = YES;
        }
    }];
    return ret;
}

- (NSInteger)indexOfScID:(NSString *)scInfoID {
    __block NSInteger index = NSNotFound;
    [self.mutableScInfoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TLSignalCtrlerInfo *info = obj;
        if ([info.ctrlerId isEqualToString:scInfoID]) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}

- (TLSignalCtrlerInfo *)getCurSelScInfo {
    TLSignalCtrlerInfo *ret = nil;
    if (self.selectedCtrllerId != nil) {
        NSInteger idx = [self indexOfScID:self.selectedCtrllerId];
        ret = [self.mutableScInfoArray objectAtIndex:idx];
    }
    return ret;
}

- (void)addSignalContrller:(TLSignalCtrlerInfo *)scInfo {
    if ([self isExistSC:scInfo] == NO) {
        [self.mutableScInfoArray addObject:scInfo];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:self.mutableScInfoArray.count - 1] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [self.tableView reloadData];
    }
}

- (void)removeSignalController:(TLSignalCtrlerInfo *)scInfo {
    __block NSInteger index = NSNotFound;
    [self.mutableScInfoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TLSignalCtrlerInfo *info = obj;
        if ([info.ctrlerId isEqualToString:scInfo.ctrlerId]) {
            index = idx;
            *stop = YES;
        }
    }];
    
    if (index != NSNotFound) {
        TLSignalCtrlerInfo *rmInfo = [self.mutableScInfoArray objectAtIndex:index];
        if ([self.selectedCtrllerId isEqualToString:rmInfo.ctrlerId]) {
            self.selectedCtrllerId = nil;
            if (self.scUpdater.isRunning) {
                [self.scUpdater stop];
            }
        }
        [self.mutableScInfoArray removeObjectAtIndex:index];
        [self.tableView reloadData];
        
    }
}

#pragma mark - getter

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.text = @"信号机控制栏";
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIButton *)requestBtn {
    if (_requestBtn == nil) {
        _requestBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_requestBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _requestBtn.layer.cornerRadius = 8.0f;
        _requestBtn.clipsToBounds = YES;
        [_requestBtn setTitle:@"申请控制" forState:UIControlStateNormal];
        [_requestBtn setBackgroundImage:[UIImage imageNamed:@"sc_blue_btn_bg"] forState:UIControlStateNormal];
        [_requestBtn setBackgroundImage:[UIImage imageNamed:@"sc_gray_btn_bg"] forState:UIControlStateDisabled];
        [_requestBtn addTarget:self action:@selector(requestBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_requestBtn];
    }
    return _requestBtn;
}

- (UIButton *)backtoMapBtn {
    if (_backtoMapBtn == nil) {
        _backtoMapBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_backtoMapBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _backtoMapBtn.layer.cornerRadius = 8.0f;
        _backtoMapBtn.clipsToBounds = YES;
        [_backtoMapBtn setTitle:@"返回地图" forState:UIControlStateNormal];
        [_backtoMapBtn setBackgroundImage:[UIImage imageNamed:@"sc_white_btn_bg"] forState:UIControlStateNormal];
        [_backtoMapBtn setBackgroundImage:[UIImage imageNamed:@"sc_gray_btn_bg"] forState:UIControlStateDisabled];
        [_backtoMapBtn addTarget:self action:@selector(backToMapBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backtoMapBtn];
        
    }
    return _backtoMapBtn;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHex:@"#343f51"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerClass:[TCSignalCtrlTableViewCell class] forCellReuseIdentifier:@"TCSignalCtrlTableViewCell"];
        _tableView.estimatedRowHeight = 200.0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (TCSignalCtrllerUpdater *)scUpdater {
    if (_scUpdater == nil) {
        _scUpdater = [[TCSignalCtrllerUpdater alloc] init];
        _scUpdater.delegate = self;
    }
    return _scUpdater;
}

- (TCSignalCtrllerOperator *)scOperator {
    if (_scOperator == nil) {
        _scOperator = [[TCSignalCtrllerOperator alloc] initWithUserName:@"iPad" lockTime:16];
    }
    return _scOperator;
}

#pragma mark - action
- (void)requestBtnTapped:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(signalCtrlView:requestBtnTapped:)]) {
        [self.delegate signalCtrlView:self requestBtnTapped:self.requestBtn];
    }
}

- (void)backToMapBtnTapped:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(signalCtrlViewBackToMapBtnPressed:)]) {
        [self.delegate signalCtrlViewBackToMapBtnPressed:self];
    }
}

#pragma mark - table view delegate & datasorce.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    TLSignalCtrlerInfo *info = [self.mutableScInfoArray objectAtIndex:section];
    if ([self.selectedCtrllerId isEqualToString: info.ctrlerId]) {
        return 1;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.mutableScInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCSignalCtrlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCSignalCtrlTableViewCell"];
    TLSignalCtrlerInfo *scInfo = [self.mutableScInfoArray objectAtIndex:indexPath.section];
    cell.controlling = [self.scOperator isSignalCtrllerControlling:scInfo.ctrlerId];
    cell.delegate = self;
    cell.tag = indexPath.section;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TLSignalCtrlerInfo *info = [self.mutableScInfoArray objectAtIndex:section];
    TCSignalCtrlHeadView *headerVw = [[TCSignalCtrlHeadView alloc] initWithSignalCtrlerName:info.ctrlerNam];
    headerVw.ctrlerId = info.ctrlerId;
    headerVw.selected = [info.ctrlerId isEqualToString:self.selectedCtrllerId];
    headerVw.tag = section;
    headerVw.delegate = self;
    return headerVw;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0;
}

#pragma mark - headView delegate
- (void)TCSignalCtrlHeadView:(TCSignalCtrlHeadView *)headView didSelected:(BOOL)selected {
    [self changeTableViewOnHeadView:headView selected:selected];
    if (self.selectedCtrllerId != nil) {
        
        NSInteger idx = [self indexOfScID:self.selectedCtrllerId];
        TLSignalCtrlerInfo *scInfo = [self.mutableScInfoArray objectAtIndex:idx];
        [self.scUpdater removeAll];
        __block __weak TCSignalCtrlView* weakSelf = self;
        [self.scUpdater addScInfoWithCrossId:scInfo.crossId completion:^(BOOL finished) {
            if (!weakSelf.scUpdater.isRunning) {
                [weakSelf.scUpdater start];
            }
        }];
        
        
    } else {
        [self.scUpdater removeAll];
        [self.scUpdater stop];
    }
}

- (void)changeTableViewOnHeadView:(TCSignalCtrlHeadView *)headView selected:(BOOL)selected {
    if (selected) {
        NSString *preSelectCtrllerId = self.selectedCtrllerId;
        self.selectedCtrllerId = headView.ctrlerId;
        NSInteger selIndex = [self indexOfScID:self.selectedCtrllerId];
        if (preSelectCtrllerId == nil) {
            [self.tableView beginUpdates];
            [self insertTableRow:selIndex];
            [self.tableView endUpdates];
        } else {
            NSInteger preSelIndex = [self indexOfScID:preSelectCtrllerId];
            [self.tableView beginUpdates];
            [self deleteTableRow:preSelIndex];
            [self insertTableRow:selIndex];
            [self.tableView endUpdates];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:preSelIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
    } else {
        NSInteger selIndex = [self indexOfScID:self.selectedCtrllerId];
        self.selectedCtrllerId = nil;
        [self deleteTableRow:selIndex];
    }
}

- (void)insertTableRow:(NSInteger)index {
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:index]] withRowAnimation:UITableViewRowAnimationAutomatic];

}

- (void)deleteTableRow:(NSInteger)index {
     [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:index]]withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - TCSignalCtrllerUpdaterDelegate
- (void)TCSignalCtrllerUpdater:(TCSignalCtrllerUpdater *)scUpdater result:(NSArray *)result crossScheme:(TLCrossScheme *)cs {
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *runTimeDict = obj;
        TLSignaleCtrllerRunTimeInfo *runTimeInfo = [[TLSignaleCtrllerRunTimeInfo alloc] initWithDict:runTimeDict];
        if ([[self getCurSelScInfo].crossId isEqualToString:runTimeInfo.crossId]) {
            NSInteger idx = [self indexOfScID:self.selectedCtrllerId];
            TCSignalCtrlTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:idx]];
            cell.lockStageLabel.text = [NSString stringWithFormat:@"锁定状态: %@", runTimeInfo.lockStage];
            [cell.lockStageLabel sizeToFit];
            cell.lockUserLabel.text = [NSString stringWithFormat:@"操控民警: %@", runTimeInfo.lockUser];
            cell.noteLabel.text = [NSString stringWithFormat:@"备注: %@", [runTimeInfo.note objectForKey:@"note"]];
            cell.modelDescLabel.text = [NSString stringWithFormat:@"控制类型: %@", runTimeInfo.modelDesc];
            NSInteger sn = runTimeInfo.sn;
            if (sn == kSNStateConverting) {
                cell.preSn = nil;
                cell.stageLabel.text = @"状态: 信号转换中";
            } else if (sn == kSNStateUnkown) {
                cell.preSn = nil;
                cell.stageLabel.text = @"状态: 未知状态请稍候";
            } else {
                NSString *totalSec = [cs getSecondsByIntSn:sn];
                NSString *name = [TLCrossScheme getSnNameBySn:sn];
                cell.stageLabel.text = [NSString stringWithFormat:@"状态: %@[%ld/%@]", name, (long) runTimeInfo.duration, totalSec];
            }
            cell.preSn = [NSString stringWithFormat:@"%ld", (long)sn];
            [cell.stageLabel sizeToFit];
            
            
            if ((runTimeInfo.sn == kSNStateConverting || runTimeInfo.sn == kSNStateUnkown) ||
                [runTimeInfo.modelCode isEqualToString:@"0300"] || ([runTimeInfo.modelCode isEqualToString:@"0602"] && (runTimeInfo.lockStage.length != 0 || runTimeInfo.lockUser.length != 0))) {
                cell.startBtn.enabled = NO;
            } else {
                cell.startBtn.enabled = YES;
            }
        }
    }];
}

#pragma mark - TCSignalCtrlTableViewCellDelegate
- (void)TCSignalCtrlTableViewCellTapped:(TCSignalCtrlTableViewCell*)cell startBtn:(UIButton *)btn {
    NSLog(@"点击启动按钮%ld", (long)cell.tag);
    btn.enabled = NO;
    TLSignalCtrlerInfo *scInfo = [self.mutableScInfoArray objectAtIndex:cell.tag];
    [scInfo getCrossRunInfoWithToken:[TLAPI loginToken] Completion:^(NSString *jsonResult, BOOL finished) {
        NSArray *array = [jsonResult objectFromJSONString];
        TLSignaleCtrllerRunTimeInfo *scRunTimeInfo = [[TLSignaleCtrllerRunTimeInfo alloc] initWithDict:array[0]];
        if (scRunTimeInfo.canControlled) {
            [self.scOperator addSignalCtrllerWithCtrllerId:scInfo.ctrlerId crossId:scInfo.crossId sn:[NSString stringWithFormat:@"%02ld", (long)scRunTimeInfo.sn] completion:^(BOOL finished) {
                if (finished) {
                    cell.controlling = YES;
                    NSLog(@"启动成功！");
                } else {
                    NSLog(@"启动失败！");
                }
            }];
        } else {
            NSLog(@"已经被其他民警控制！");
        }
        btn.enabled = YES;
    }];
//    [TLAPI getCrossRunInfoWithCrossId:scInfo.crossId token:[TLAPI loginToken] Completion:^(NSString *jsonResult, BOOL finished) {
//        NSArray *array = [jsonResult objectFromJSONString];
//        TLSignaleCtrllerRunTimeInfo *scRunTimeInfo = [[TLSignaleCtrllerRunTimeInfo alloc] initWithDict:array[0]];
//        if (scRunTimeInfo.canControlled) {
//            [self.scOperator addSignalCtrllerWithCtrllerId:scInfo.ctrlerId crossId:scInfo.crossId sn:[NSString stringWithFormat:@"%02ld", (long)scRunTimeInfo.sn] completion:^(BOOL finished) {
//                if (finished) {
//                    cell.controlling = YES;
//                    NSLog(@"启动成功！");
//                } else {
//                    NSLog(@"启动失败！");
//                }
//            }];
//        } else {
//            NSLog(@"已经被其他民警控制！");
//        }
//        btn.enabled = YES;
//    }];
}

- (void)TCSignalCtrlTableViewCellTapped:(TCSignalCtrlTableViewCell*)cell stopBtn:(UIButton *)btn {
    NSLog(@"%ld", (long)cell.tag);
    btn.enabled = NO;
    TLSignalCtrlerInfo *scInfo = [self.mutableScInfoArray objectAtIndex:cell.tag];
    [self.scOperator removeSignalCtrllerWithCtrllerId:scInfo.ctrlerId completion:^(BOOL finished) {
        if (finished) {
            NSLog(@"停止成功！");
            cell.controlling = NO;
        } else {
            NSLog(@"停止失败!");
        }
        btn.enabled = YES;
    }];
}

- (void)TCSignalCtrlTableViewCellTapped:(TCSignalCtrlTableViewCell*)cell stepBtn:(UIButton *)btn {
    NSLog(@"%ld", (long)cell.tag);
    btn.enabled = NO;
    TLSignalCtrlerInfo *scInfo = [self.mutableScInfoArray objectAtIndex:cell.tag];
    [self.scOperator stepSignalCtrllerWithCtrllerId:scInfo.ctrlerId completion:^(BOOL finished) {
        btn.enabled = YES;
        if (finished) {
            NSLog(@"步进成功！");
        } else {
            NSLog(@"步进失败");
        }
        
    }];
}

- (void)TCSignalCtrlTableViewCell:(TCSignalCtrlTableViewCell *)cell deleteBtnTapped:(UIButton *)btn {
    TLSignalCtrlerInfo *scInfo = [self.mutableScInfoArray objectAtIndex:cell.tag];
    [self.scOperator removeSignalCtrllerWithCtrllerId:scInfo.ctrlerId completion:^(BOOL finished) {
        if (finished) {
            NSLog(@"停止成功！");
            cell.controlling = NO;
        } else {
            NSLog(@"停止失败!");
        }
       
    }];
     [self removeSignalController:scInfo];
    if ([self.delegate respondsToSelector:@selector(signalCtrlView:didDeleteScInfo:)]) {
        [self.delegate signalCtrlView:self didDeleteScInfo:scInfo];
    }
}

@end
