//
//  TCTollgateDetailViewController.m
//  TC
//
//  Created by 郭志伟 on 16/3/3.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import "TCTollgateDetailViewController.h"
#import "TCBriefTableViewCell.h"
#import <Masonry/Masonry.h>
#import <UIView+Toast.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface TCTollgateDetailViewController ()

@property(nonatomic, strong) UIWebView *webView;

@end

@implementation TCTollgateDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   // [self setup];
    
    self.view.backgroundColor = [UIColor clearColor];
    scv = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:scv];
    scv.delegate = self;
    
    scv.maximumZoomScale = 4.0;
    scv.minimumZoomScale = 1.0;
    
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)addGestureRecognizerToView:(UIView *)view
{
    
    UIPanGestureRecognizer *panG = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [view addGestureRecognizer:panG];
    
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    tapG.numberOfTapsRequired = 2;
    [view addGestureRecognizer:tapG];
}

-(void)panView:(UIPanGestureRecognizer*)panGesture
{
    UIView *view = panGesture.view;
    CGPoint transpoint = [panGesture translationInView:self.view];
    view.center = CGPointMake(view.center.x+transpoint.x, view.center.y+transpoint.y);
   if(_imgView.center.x < -200||_imgView.center.x>(3*self.view.center.x-40))
   {
       [self returnToOrignSize];
   }
    if(_imgView.center.y < -self.view.center.y||_imgView.center.y>(3*self.view.center.y-40))
    {
        [self returnToOrignSize];
    }
    [panGesture setTranslation:CGPointZero inView:self.view];
}

-(void)tapView:(UITapGestureRecognizer *)tapGesture
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    _imgView.transform = CGAffineTransformIdentity;
    [_imgView setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [UIView commitAnimations];
}

-(void)returnToOrignSize
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    _imgView.transform = CGAffineTransformIdentity;
    [_imgView setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [UIView commitAnimations];
}


#pragma delegate

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imgView;
}

#pragma mark -getter

- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] initWithImage:nil];
        _imgView.frame =self.view.bounds;
        [scv addSubview:_imgView];
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

- (void)setTgNotification:(TCTollgateNotification *)tgn {
    if (tgn.imgUrl) {
        NSURL *url = [NSURL URLWithString:tgn.imgUrl];
        [self.imgView sd_setImageWithURL:url];
    }
}


@end
