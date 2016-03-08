//
//  RTSearchViewController.m
//  MainControllerDemo
//
//  Created by 郭志伟 on 15/11/12.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "RTSearchViewController.h"

#import <Masonry/Masonry.h>

@interface RTSearchViewController() <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, assign)BOOL selected;

@end

@implementation RTSearchViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor clearColor];
    self.textField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.font = [UIFont systemFontOfSize:14];
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.placeholder = @"点击查找";
    [self.textField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self.view addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@30);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.dataArray = [[NSMutableArray alloc] init];
    self.maxTableViewHeight = 300;
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [tapGesture setCancelsTouchesInView:NO];
    [tapGesture setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapGesture];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
//    tap.cancelsTouchesInView = NO;
//    [self.view addGestureRecognizer:tap];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"demo"];
    NSString *str = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = str;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.textField.text = [self.dataArray objectAtIndex:indexPath.row];
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    [self recover];
}

- (void)setMaxTableViewHeight:(CGFloat)maxTableViewHeight {
    _maxTableViewHeight = maxTableViewHeight;
}

- (void)textFieldDidChanged:(UITextField *)textField {
    [self.dataArray addObject:textField.text];
    [self.tableView reloadData];
//    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, CGRectGetWidth(self.view.frame), 30 + self.tableView.contentSize.height);
    [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat height = 30+self.tableView.contentSize.height;
        if (height > 330) {
            height = 330;
        }
        
        if (self.textField.text.length == 0) {
            height = 30;
            [self.dataArray removeAllObjects];
        }
        
        make.height.equalTo(@(height));
    }];
    [self.view setNeedsLayout];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat height = 30;
        make.height.equalTo(@(height));
    }];
    [self.textField resignFirstResponder];
}
- (void)recover {
    [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat height = 30;
        make.height.equalTo(@(height));
    }];
}

@end
