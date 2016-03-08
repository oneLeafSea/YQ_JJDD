//
//  TCHighCamCallOutViewController.h
//  TC
//
//  Created by 郭志伟 on 15/11/23.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <ArcGIS/ArcGIS.h>
#import "TVHighCamInfo.h"


@protocol TCHighCamCallOutViewControllerDelegate;



@interface TCHighCamCallOutViewController : UIViewController

- (instancetype)initWithGraphic:(AGSGraphic *)graphic selected:(BOOL)selected;

@property(nonatomic, strong) AGSGraphic* graphic;

@property(nonatomic, assign) BOOL selected;

@property(weak, nonatomic) id<TCHighCamCallOutViewControllerDelegate> delegate;

@end

@protocol TCHighCamCallOutViewControllerDelegate <NSObject>

- (void)highCamCallOutViewController:(TCHighCamCallOutViewController *)hcCallOutViewController DidSelected:(BOOL)selected hcInfo:(TVHighCamInfo *)hcInfo;

@end
