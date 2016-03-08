//
//  TCMapViewController.h
//  TC
//
//  Created by 郭志伟 on 15/11/12.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLSignalCtrlerInfo.h"
#import "TVHighCamInfo.h"
#import "TVElecPoliceInfo.h"
#import "TVRoadCamInfo.h"

@protocol TCMapViewControllerDelegate;

@interface TCMapViewController : UIViewController

@property(nonatomic, weak) id<TCMapViewControllerDelegate> delegate;

/**
 *  信号机信息数组.
 */
@property(nonatomic, readonly)NSArray *selectedSCArray;

/**
 *  TVRoadCamInfo、TVHighCamInfo、TVElecPoliceInfo中的一种
 */
@property(nonatomic, readonly)NSArray *selectedCamArray;

- (void)deleteScInfo:(TLSignalCtrlerInfo *)scInfo;
- (void)deleteCamInfo:(TVCamInfo *)camInfo;

@end

@protocol TCMapViewControllerDelegate <NSObject>

- (void)mapViewControllerShiftBtnPressed:(TCMapViewController *)mapViewController;

- (void)mapViewController:(TCMapViewController *)mapViewController SignalCtrlerDidSelected:(BOOL) selected SignalCtrlerInfo:(TLSignalCtrlerInfo *)scInfo;

@end
