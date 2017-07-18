//
//  TCTollgateDetailViewController.h
//  TC
//
//  Created by 郭志伟 on 16/3/3.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCTollgateNotification.h"

@interface TCTollgateDetailViewController : UIViewController<UIScrollViewDelegate>
{
   UIScrollView *scv;
    
}

typedef NS_ENUM(NSUInteger, TCPadZoom) {
    TCPadZoomIn = 1,
    TCPadZoomOut,
    TCPadZoomNone
};

@property(nonatomic, strong) UIImageView *imgView;

@property(nonatomic, assign)TCPadZoom currentZoom;

- (void)setTgNotification:(TCTollgateNotification *)tgn;

-(void)addGestureRecognizerToView:(UIView *)view;

-(void)returnToOrignSize;
@end
