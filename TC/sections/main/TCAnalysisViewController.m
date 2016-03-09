//
//  TCAnalysisViewController.m
//  TC
//
//  Created by 郭志伟 on 15/11/13.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TCAnalysisViewController.h"
#import <Masonry/Masonry.h>
#import "TLAPI.h"
#import <AFNetworking.h>
#import "LogLevel.h"
#import <QuickLook/QuickLook.h>
#import <MRProgress/MRProgress.h>

@interface TCAnalysisViewController() <UIWebViewDelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate>

@property(nonatomic, strong)UIWebView *webView;
@property(nonatomic, strong)QLPreviewController *previewController;
@property(nonatomic, strong) UIButton *backButton;

@end

@implementation TCAnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
//    NSString *str = [NSString stringWithFormat:@"http://10.100.8.70:7001/trafficpolice/downloadServlet?token=%@&mode=download&selectedWeek=-1", @"YkQENkQBZDO1UUMxQzNENEOFVTQ5EjM4MUOBFUO1cTO"] ;
//    http://10.100.8.70:7001/trafficpolice/downloadServlet?token=YkQENkQBZDO1UUMxQzNENEOFVTQ5EjM4MUOBFUO1cTO&mode=download&selectedWeek=-1
    
    NSString *str = @"http://10.100.9.20:8081/menu";
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *urlReq = [[NSURLRequest alloc] initWithURL:url];
    self.webView.delegate = self;
    [self.webView loadRequest: urlReq];
//    [self downloadWithStrUrl:str];
}

- (UIButton *)backButton {
    if (_backButton == nil) {
        _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_backButton addTarget:self action:@selector(handleBackBtnTapped) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setTitle:@"返回" forState:UIControlStateNormal];
    }
    return _backButton;
}

- (QLPreviewController *)previewController {
    if (_previewController == nil) {
        _previewController = [[QLPreviewController alloc] init];
        _previewController.delegate = self;
        _previewController.dataSource = self;
    }
    return _previewController;
}


- (void)downloadWithStrUrl:(NSURL *)serverUrl {
    [MRProgressOverlayView showOverlayAddedTo:self.view.window animated:YES];
    NSURL *url = serverUrl;//[NSURL URLWithString:serverUrl];
    
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"1.pdf"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:filePath append:NO]];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        double p = totalBytesRead / (double)totalBytesExpectedToRead;
        DDLogInfo(@"下载进度%f", p);
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MRProgressOverlayView dismissOverlayForView:self.view.window animated:YES];
        NSError *error;
        [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
        
        if (error) {
            DDLogError(@"下载pdf出错");
        } else {
            [[NSFileManager defaultManager] moveItemAtPath:filePath toPath:filePath error:nil];
            DDLogInfo(@"下载pdf成功");
            [self addChildViewController:self.previewController];
            [self.view addSubview:self.previewController.view];
            self.previewController.view.frame = self.view.bounds;
            [self.previewController didMoveToParentViewController:self];
            [self.view addSubview:self.backButton];
            
            [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).offset(18);
                make.right.equalTo(self.view).offset(-18);
                make.width.equalTo(@40);
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MRProgressOverlayView dismissOverlayForView:self.view.window animated:YES];
        DDLogError(@"下载pdf出错");
    }];
    
    [operation start];
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"1.pdf"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    return url;
}


- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)handleBackBtnTapped {
    [self.previewController removeFromParentViewController];
    [self.previewController.view removeFromSuperview];
    [self.backButton removeFromSuperview];
    _backButton = nil;
    [self.previewController didMoveToParentViewController:nil];
}

// http://10.100.8.107:8080/BizService/auth/login?username=suyc&password=suyc

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *reqUrl = request.URL;
//    NSURL *baseUrl = reqUrl.baseURL;
//    NSString *host = reqUrl.host;
//    NSNumber *port = reqUrl.port;
    NSString *path = reqUrl.path;
//    NSString *parameterString = reqUrl.parameterString;
//    NSString *fragment = reqUrl.fragment;
//    NSString *query = reqUrl.query;
    NSLog(@"%@", reqUrl);
    if ([path hasPrefix:@"/yqjj/file/"]) {
        [self downloadWithStrUrl:reqUrl];
        return NO;
    }
    return YES;
}
@end
