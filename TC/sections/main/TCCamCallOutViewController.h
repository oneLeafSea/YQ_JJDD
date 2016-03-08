//
//  TCCamCallOutViewController.h
//  TC
//
//  Created by 郭志伟 on 15/11/23.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <ArcGIS/ArcGIS.h>

@protocol TCCamCallOutViewControllerDelegate;

@interface TCCamCallOutViewController : UIViewController

- (instancetype)initWithGraphic:(AGSGraphic *)graphic selected:(BOOL)selected;

@property(nonatomic, strong) AGSGraphic* graphic;

@property(nonatomic, assign) BOOL selected;

@property(weak, nonatomic) id<TCCamCallOutViewControllerDelegate> delegate;

@end

@protocol TCCamCallOutViewControllerDelegate <NSObject>

- (void)camCallOutViewController:(TCCamCallOutViewController *)camCallOutViewController DidSelected:(BOOL)selected;

@end