//
//  TCSignalCtrlTableViewCell.h
//  TC
//
//  Created by 郭志伟 on 15/11/18.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCSignalCtrlView.h"
@protocol TCSignalCtrlTableViewCellDelegate;

@interface TCSignalCtrlTableViewCell : UITableViewCell

//@property(nonatomic, strong) UILabel  *crossIdLabel;
//@property(nonatomic, strong) UILabel  *junctionIdLabel;
@property(nonatomic, strong) UILabel  *lockStageLabel;
@property(nonatomic, strong) UILabel  *lockUserLabel;
@property(nonatomic, strong) UILabel  *noteLabel;
@property(nonatomic, strong) UILabel  *modelDescLabel;
@property(nonatomic, strong) UILabel  *stageLabel;



//@property(nonatomic, strong) UILabel  *curStageLabel;

@property(nonatomic, strong) UIButton *startBtn;

@property(nonatomic, assign) BOOL   controlling;

@property(nonatomic, strong) NSString *preSn;
//@property(nonatomic, assign) NSInteger snTime;
@property(nonatomic,strong)TCSignalCtrlView *scview;
@property(nonatomic, weak) id<TCSignalCtrlTableViewCellDelegate> delegate;

@end


@protocol TCSignalCtrlTableViewCellDelegate <NSObject>

- (void)TCSignalCtrlTableViewCellTapped:(TCSignalCtrlTableViewCell*)cell startBtn:(UIButton *)btn;
- (void)TCSignalCtrlTableViewCellTapped:(TCSignalCtrlTableViewCell*)cell stopBtn:(UIButton *)btn;
- (void)TCSignalCtrlTableViewCellTapped:(TCSignalCtrlTableViewCell*)cell stepBtn:(UIButton *)btn;
- (void)TCSignalCtrlTableViewCell:(TCSignalCtrlTableViewCell*)cell deleteBtnTapped:(UIButton *)btn;

@end