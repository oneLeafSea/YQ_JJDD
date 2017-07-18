//
//  MainViewController.m
//  TC
//
//  Created by 郭志伟 on 15/11/12.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "MainViewController.h"
#import <Masonry/Masonry.h>

const CGFloat kLeftViewDefaultWidth = 216.0f;

@interface MainViewController()

@property(nonatomic, strong) UIView *leftViewContrainer;
@property(nonatomic, strong) UIView *centerViewContainer;

@end

@implementation MainViewController

- (instancetype)initWithLeftViewController:(UIViewController *)leftViewController centerViewController:(UIViewController *)centerViewController {
    if (self = [super init]) {
        _leftViewControllerWidth = kLeftViewDefaultWidth;
        self.leftViewController = leftViewController;
        self.centerViewController = centerViewController;
        _showLeftViewController = YES;
    }
    return self;
}

- (void)viewDidLoad{
    [self.view addSubview:self.leftViewContrainer];
    [_leftViewContrainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.equalTo(@(self.leftViewControllerWidth));
    }];
    [self.view addSubview:self.centerViewContainer];
    [_centerViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.leftViewContrainer.mas_right);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)setCenterViewController:(UIViewController *)centerViewController {
    
    NSParameterAssert(centerViewController != nil);
    
    if ([self.centerViewController isEqual:centerViewController]) {
        return;
    }

    if (self.centerViewController != nil) {
        [self.centerViewController beginAppearanceTransition:NO animated:NO];
        [self.centerViewContainer removeConstraints:self.centerViewContainer.constraints];
        [self.centerViewController.view removeFromSuperview];
        [self.centerViewController endAppearanceTransition];
        [self.centerViewController willMoveToParentViewController:nil];
        [self.centerViewController removeFromParentViewController];
        [self centerViewControllerWillShiftWithPreViewController:self.centerViewController currentViewController:centerViewController];
    }
    

    [self addChildViewController:centerViewController];
    [self.centerViewContainer addSubview:centerViewController.view];
    [centerViewController didMoveToParentViewController:self];
    _centerViewController = centerViewController;
    [centerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.centerViewContainer);
    }];
    [self.centerViewContainer updateConstraintsIfNeeded];
    
}

- (void)setLeftViewController:(UIViewController *)leftViewController {
    NSParameterAssert(leftViewController != nil);
    
    if ([self.leftViewController isEqual:leftViewController]) {
        return;
    }
    
    if (self.leftViewController != nil) {
        [self.leftViewController beginAppearanceTransition:NO animated:NO];
        [self.leftViewController.view removeConstraints:self.leftViewController.view.constraints];
        [self.leftViewController.view removeFromSuperview];
        [self.leftViewController endAppearanceTransition];
        [self.leftViewController willMoveToParentViewController:nil];
        [self.leftViewController removeFromParentViewController];
    }
    
    [self addChildViewController:leftViewController];
    [self.leftViewContrainer addSubview:leftViewController.view];
    [leftViewController didMoveToParentViewController:self];
    _leftViewController = leftViewController;
    [_leftViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.leftViewContrainer);
    }];
}


- (UIView *)leftViewContrainer {
    if (_leftViewContrainer == nil) {
        _leftViewContrainer = [[UIView alloc] initWithFrame:CGRectZero];
//        [self.view addSubview:_leftViewContrainer];
    }
    return _leftViewContrainer;
}

- (UIView *)centerViewContainer {
    if (_centerViewContainer == nil) {
        _centerViewContainer = [[UIView alloc] initWithFrame:CGRectZero];
//        [self.view addSubview:_centerViewContainer];
        
    }
    return _centerViewContainer;
}

- (void)setShowLeftViewController:(BOOL)showLeftViewController {
    _showLeftViewController = showLeftViewController;
    [UIView animateWithDuration:0.5 animations:^{
        [self.leftViewContrainer mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(showLeftViewController ? 0 : -self.leftViewControllerWidth);
        }];
        [self.view layoutIfNeeded];
    }];
}

- (void)centerViewControllerWillShiftWithPreViewController:(UIViewController *)preViewController
                                     currentViewController:(UIViewController *)currentVewController {
    
}


@end
