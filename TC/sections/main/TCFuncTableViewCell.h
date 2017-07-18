//
//  TCFuncTableViewCell.h
//  TC
//
//  Created by 郭志伟 on 15/11/12.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCFuncTableViewCell : UITableViewCell

//@property(nonatomic, copy) NSString *iconName;
@property(nonatomic, copy) NSString *title;

@property(nonatomic, strong) UIImageView *iconImgView;

@property(nonatomic, copy) NSString *normalImgName;
@property(nonatomic, copy) NSString *selectedImgName;

- (void)cellSelected:(BOOL)selected;

@end
