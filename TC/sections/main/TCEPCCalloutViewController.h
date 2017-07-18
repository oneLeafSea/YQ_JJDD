//
//  TCEPCCalloutViewController.h
//  TC
//
//  Created by 郭志伟 on 16/3/4.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import "TCEPCTollegateViewController.h"
extern NSString *kCam;

@protocol TCEPCCalloutViewControllerDelegate;

@interface TCEPCCalloutViewController : UIViewController

- (instancetype)initWithGraphic:(AGSGraphic *)graphic
                  videoSelected:(BOOL)videoSelected
               tollgateSelected:(BOOL)tgSelected;

@property(nonatomic, assign)BOOL videoSelected;
@property(nonatomic, assign)BOOL tollageSelected;
@property(nonatomic, strong) AGSGraphic* graphic;

@property(nonatomic, weak) id<TCEPCCalloutViewControllerDelegate> delegate;

@end

@protocol TCEPCCalloutViewControllerDelegate <NSObject>

- (void)TCEPCCalloutViewController:(TCEPCCalloutViewController *)vc tollgateDidSelected:(BOOL)selected;
- (void)TCEPCCalloutViewController:(TCEPCCalloutViewController *)vc videoDidSelected:(BOOL)selected;

@end
