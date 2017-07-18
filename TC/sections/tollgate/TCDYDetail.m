//
//  TCDYDetail.m
//  TC
//
//  Created by guozw on 16/8/24.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import "TCDYDetail.h"

#import "TCTollgateDYCell.h"
#import <Masonry/Masonry.h>
#import <UIView+Toast.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface TCDYDetail ()

@property(nonatomic, strong) UIImageView *imgView;

@property(nonatomic, strong) UIWebView *webView;

@end

@implementation TCDYDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setup {
    [self setupConstaints];
}


- (void)setupConstaints {
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    //    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.equalTo(self.view);
    //    }];
}

#pragma mark -getter
- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] initWithImage:nil];
        [self.view addSubview:_imgView];
    }
    return _imgView;
}

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_webView];
    }
    return _webView;
}

#pragma mark - public method

- (void)setTgDYNotification:(TCDYNotificatin *)tgn {
    if (tgn.imgUrl) {
        NSURL *url = [NSURL URLWithString:tgn.imgUrl];
        [self.imgView sd_setImageWithURL:url];
    }
}
@end
