//
//  TCMainViewController.m
//  TC
//
//  Created by 郭志伟 on 15/11/12.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TCMainViewController.h"
#import <Masonry/Masonry.h>
#import "TCFuncViewController.h"
#import "TCMapViewController.h"
#import "TCVideoSignalMapViewController.h"

@interface TCMainViewController() <TCFuncViewControllerDelegate>

@property(nonatomic, strong)UIButton *closeLeftViewControllerButton;

@property(nonatomic, assign)NSUInteger selectedIndex;

@property(nonatomic, strong) NSMutableSet *reservedViewControllers;

@end

@implementation TCMainViewController

+ (TCMainViewController *)Instance {
    
    NSArray *funcTableDatas = @[@{@"title":@"视频、信号机控制", @"normalImg":@"func_video_surveillance_un", @"selectedImg":@"func_video_surveillance", @"className":@"TCVideoSignalMapViewController", @"reserved":@YES},
                                @{@"title":@"统计分析", @"normalImg":@"func_analysis_un", @"selectedImg":@"func_analysis", @"className":@"TCAnalysisViewController", @"reserved":@NO},
                                @{@"title":@"卡口订阅", @"normalImg":@"func_tollgate_un", @"selectedImg":@"func_tollgate_un", @"className":@"TCTollgateViewController"},
//                                @{@"title":@"卡口布控", @"normalImg":@"kakoubukong", @"selectedImg":@"kakoubukong", @"className":@"TCTollegateBKViewController"},
//                                @{@"title":@"卡口订阅", @"normalImg":@"kakkouyuedu", @"selectedImg":@"kakkouyuedu", @"className":@"TCTollgateDYViewController"},
                                @{@"title":@"设置", @"normalImg":@"func_setting_un", @"selectedImg":@"func_setting", @"className":@"TCSettingViewController", @"reserved":@NO}
                                ];
    
    TCFuncViewController *funcVC = [[TCFuncViewController alloc] init];
    funcVC.tableDatas = funcTableDatas;
    TCVideoSignalMapViewController *vsmVC = [[TCVideoSignalMapViewController alloc] init];
    TCMainViewController *mainVC = [[TCMainViewController alloc] initWithLeftViewController:funcVC centerViewController:vsmVC];
    funcVC.delegate = mainVC;
    return mainVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"移动智能交通";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.closeLeftViewControllerButton addTarget:self action:@selector(handleClvcBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.selectedIndex = 0;
    self.reservedViewControllers = [[NSMutableSet alloc] initWithCapacity:32];
}


- (UIButton *)closeLeftViewControllerButton {
    if (_closeLeftViewControllerButton == nil) {
        _closeLeftViewControllerButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.view addSubview:_closeLeftViewControllerButton];
        UIImage *img = [UIImage imageNamed:@"main_collapse"];
        UIImage *strechImg = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0, 2, 0, 40) resizingMode:UIImageResizingModeStretch];
        [_closeLeftViewControllerButton setBackgroundImage:strechImg forState:UIControlStateNormal];
        [_closeLeftViewControllerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftViewController.view.mas_right).offset(-16);
            make.top.equalTo(self.view).offset(38);
            make.width.equalTo(@32);
            make.height.equalTo(@54);
        }];
        
    }
    return _closeLeftViewControllerButton;
}

- (void)centerViewControllerWillShiftWithPreViewController:(UIViewController *)preViewController currentViewController:(UIViewController *)currentVewController {
    [super centerViewControllerWillShiftWithPreViewController:preViewController currentViewController:currentVewController];
    NSString *className = NSStringFromClass([preViewController class]);
    if ([self.leftViewController isKindOfClass:[TCFuncViewController class]]) {
        TCFuncViewController *funcVC = (TCFuncViewController *)self.leftViewController;
        BOOL reserved = [funcVC isReservedWithClassName:className];
        if (reserved) {
            [self.reservedViewControllers addObject:preViewController];
        }
    }
}


//- (BOOL)isExsitViewControllerInReservedArray:(NSString *)className {
//    __block BOOL exsit = NO;
//    [self.reservedViewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSString *cn = NSStringFromClass([obj class]);
//        if ([className isEqualToString:cn]) {
//        
//        }
//    }];
//    return exsit;
//}


- (void)handleClvcBtnTapped:(UIButton *)btn {
    self.showLeftViewController = !self.showLeftViewController;
    UIImage *img = [UIImage imageNamed:self.showLeftViewController ?@"main_collapse" : @"main_expand"];
    UIImage *strechImg = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0, 2, 0, 40) resizingMode:UIImageResizingModeStretch];
    [btn setBackgroundImage:strechImg forState:UIControlStateNormal];
}


- (void)TCFuncViewController:(TCFuncViewController *)fucViewController
          didSelectedAtIndex:(NSInteger)index module:(NSDictionary *)module {
    if (index == self.selectedIndex) {
        return;
    }
    
    NSNumber *hide = [module objectForKey:@"hideLeft"];
    if (hide && [hide boolValue]) {
        [self hideLeftViewController:YES];
    }
    self.selectedIndex = index;
    NSString *className = module[@"className"];
    
    UIViewController *vc = [self getViewControllerFromReservedContollersByClassName:className];
    if (vc) {
        self.centerViewController = vc;
    } else {
        Class class = NSClassFromString(className);
        if (class) {
            UIViewController *ctrl = class.new;
            self.centerViewController = ctrl;
        } else {
            NSLog(@"can't find view controller");
        }
    }
}

- (UIViewController *)getViewControllerFromReservedContollersByClassName:(NSString *)className {
    __block UIViewController *vc = nil;
    [self.reservedViewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *cn = NSStringFromClass([obj class]);
        if ([cn isEqualToString:className]) {
            vc = obj;
            *stop = YES;
        }
    }];
    return vc;
}

- (void)hideLeftViewController:(BOOL)hide {
    self.showLeftViewController = !hide;
    UIImage *img = [UIImage imageNamed:self.showLeftViewController ?@"main_collapse" : @"main_expand"];
    UIImage *strechImg = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0, 2, 0, 40) resizingMode:UIImageResizingModeStretch];
    [self.closeLeftViewControllerButton setBackgroundImage:strechImg forState:UIControlStateNormal];
}

- (void)hideCloseLeftViewControllerButton:(BOOL)hide {
    self.closeLeftViewControllerButton.hidden = hide;
}

@end
