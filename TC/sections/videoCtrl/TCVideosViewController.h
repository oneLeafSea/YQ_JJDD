//
//  TCVideosViewController.h
//  TC
//
//  Created by 郭志伟 on 15/11/16.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVCamInfo.h"

@protocol TCVideosViewControllerDelegate;

@interface TCVideosViewController : UIViewController

@property(nonatomic, strong)NSArray *selVieoArray;

- (void)pauseAll;
- (void)resumeAll;

@property(nonatomic, weak) id<TCVideosViewControllerDelegate> delegate;

@end

@protocol TCVideosViewControllerDelegate <NSObject>

- (void)TCVideosViewController:(TCVideosViewController *)videoVC
                  camDidClosed:(TVCamInfo *)camInfo;

@end
