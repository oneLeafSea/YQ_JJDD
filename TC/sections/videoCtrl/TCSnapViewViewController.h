//
//  TCSnapViewViewController.h
//  TC
//
//  Created by guozw on 16/5/9.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TCSnapViewViewControllerDelegate;

@interface TCSnapViewViewController : UIViewController
@property(nonatomic,weak)id<TCSnapViewViewControllerDelegate>delegate;

@end
@protocol TCSnapViewViewControllerDelegate <NSObject>

-(void)clickBtn:(TCSnapViewViewController*)ctrl;

@end


