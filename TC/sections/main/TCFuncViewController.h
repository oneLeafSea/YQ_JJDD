//
//  TCFuncViewController.h
//  TC
//
//  Created by 郭志伟 on 15/11/12.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCNotification.h"


// {"title":"", "normalImg":"", "selectedImg":""} table data

@protocol TCFuncViewControllerDelegate;

@interface TCFuncViewController : UIViewController

@property(weak) id<TCFuncViewControllerDelegate> delegate;

@property(nonatomic, strong)NSArray *tableDatas;

- (BOOL)isReservedWithClassName:(NSString *)className;
-(void)handleExit;
@end


@protocol TCFuncViewControllerDelegate <NSObject>

- (void)TCFuncViewController:(TCFuncViewController *)fucViewController
          didSelectedAtIndex:(NSInteger)index module:(NSDictionary *)module;

@end