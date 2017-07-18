//
//  TCMapLayerSelectionView.h
//  TC
//
//  Created by 郭志伟 on 15/11/24.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCMapLayerSelectionViewDelegate;

@interface TCMapLayerSelectionView : UIView

@property(nonatomic, weak) id<TCMapLayerSelectionViewDelegate>delegate;

@property(nonatomic, assign)BOOL scOn;
@property(nonatomic, assign)BOOL hcOn;
@property(nonatomic, assign)BOOL rcOn;
@property(nonatomic, assign)BOOL epOn;


@end

@protocol TCMapLayerSelectionViewDelegate <NSObject>

- (void)TCMapLayerSelectionView:(TCMapLayerSelectionView *)mapLayerSelectionView
             hcLayerDidSelected:(BOOL)selected;
- (void)TCMapLayerSelectionView:(TCMapLayerSelectionView *)mapLayerSelectionView
             rcLayerDidSelected:(BOOL)selected;

- (void)TCMapLayerSelectionView:(TCMapLayerSelectionView *)mapLayerSelectionView
             scLayerDidSelected:(BOOL)selected;

- (void)TCMapLayerSelectionView:(TCMapLayerSelectionView *)mapLayerSelectionView
             epLayerDidSelected:(BOOL)selected;

@end
