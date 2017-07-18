//
//  TCBriefTableViewCell.m
//  TC
//
//  Created by guozw on 16/3/8.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import "TCBriefTableViewCell.h"

@interface TCBriefTableViewCell()

@end
@implementation TCBriefTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self commonInit];
        
    }
    return self;
}
- (void)awakeFromNib {
    [self commonInit];
}

-(void)commonInit{
    [self setupContraints];
}
-(void)setupContraints{
    [self.locationLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.left.equalTo(self.contentView).offset(8);
    }];
    [self.plateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.right.equalTo(self.contentView).offset(-8);
    }];
    [self.descLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.locationLbl.mas_bottom);
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-8);
      // make.bottom.equalTo(self.contentView).offset(-8);
        
    }];
    [self.resonLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLbl.mas_bottom);
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-8);
    }];
    [self.desriptionLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resonLbl.mas_bottom).offset(8);
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-8);
        make.bottom.equalTo(self.contentView).offset(-8);
    }];
}

#pragma mark -getter

- (UILabel *)locationLbl {
    if (_locationLbl == nil) {
        _locationLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _locationLbl.textColor = [UIColor blueColor];
        [self.contentView addSubview:_locationLbl];
    }
    return _locationLbl;
}

-(UILabel *)plateLbl {
    if (_plateLbl == nil) {
        _plateLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_plateLbl];
    }
    return _plateLbl;
}

-(UILabel *)descLbl {
    if (_descLbl == nil) {
        _descLbl =[[UILabel alloc] initWithFrame:CGRectZero];
        _descLbl.numberOfLines = 0;
        _descLbl.font = [UIFont systemFontOfSize:14];
        _descLbl.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_descLbl];
    }
    return _descLbl;
}

-(UILabel *)desriptionLbl{
    if (_desriptionLbl==nil) {
        _desriptionLbl=[[UILabel alloc]initWithFrame:CGRectZero];
        _desriptionLbl.numberOfLines=0;
        _desriptionLbl.font=[UIFont systemFontOfSize:14];
        //_desriptionLbl.text=@"详情";
        _desriptionLbl.textColor=[UIColor lightGrayColor];
        [self.contentView addSubview:_desriptionLbl];
        
    }
    return _desriptionLbl;
}
-(UILabel *)resonLbl{
    if (_resonLbl==nil) {
        _resonLbl=[[UILabel alloc ]initWithFrame:CGRectZero];
        
        [self.contentView addSubview:_resonLbl];
    }
    return _resonLbl;
}
@end
