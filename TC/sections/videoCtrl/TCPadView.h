//
//  TCPad.h
//  guestureDemo
//
//  Created by 郭志伟 on 15/12/7.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCPadViewDelegate;

typedef NS_ENUM(NSUInteger, TCPadDirection) {
    TCPadDirectionUpLeft = 1,
    TCPadDirectionUp,
    TCPadDirectionUpRight,
    TCPadDirectionLeft,
    TCPadDirectionNone,
    TCPadDirectionRight,
    TCPadDirectionDownLeft,
    TCPadDirectionDown,
    TCPadDirectionDownRight
};

typedef NS_ENUM(NSUInteger, TCPadZoom) {
    TCPadZoomIn = 1,
    TCPadZoomOut,
    TCPadZoomNone
};

@interface TCPadView : UIView

@property(nonatomic, weak)id<TCPadViewDelegate> delegate;
@property (nonatomic, strong) UIButton *zoomInBtn;
@property (nonatomic, strong) UIButton *zoomOutBtn;
@end

@protocol TCPadViewDelegate <NSObject>

- (void)TCPad:(TCPadView *)pad didPressDirection:(TCPadDirection)direction;
- (void)TCPadDidReleaseDirection:(TCPadView *)pad;

- (void)TCPad:(TCPadView *)pad didZoom:(TCPadZoom)zoom;
- (void)TCPadReleaseZoom:(TCPadView *)pad;

@end
