//
//  TCPad.m
//  guestureDemo
//
//  Created by 郭志伟 on 15/12/7.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TCPadView.h"

#import <Masonry/Masonry.h>

@interface TCPadView() {
    TCPadZoom      _currentZoom;
    UIPinchGestureRecognizer *_pinchGesture;
}

@property (nonatomic, assign) TCPadDirection currentDirection;
@property (nonatomic, strong) UIImageView *leftArrowImgView;
@property (nonatomic, strong) UIImageView *rightArrowImgView;
@property (nonatomic, strong) UIImageView *upArrowImgView;
@property (nonatomic, strong) UIImageView *downArrowImgView;
@property (nonatomic, strong) UIImageView *leftUpArrowImgView;
@property (nonatomic, strong) UIImageView *leftDownArrowImgView;
@property (nonatomic, strong) UIImageView *rightUpArrowImgView;
@property (nonatomic, strong) UIImageView *rightDownArrowImgView;
@property (nonatomic, strong) UIImageView *centerImgView;

@property (nonatomic, strong) UIButton *zoomInBtn;
@property (nonatomic, strong) UIButton *zoomOutBtn;
@end

@implementation TCPadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

#pragma mark - setter
- (void)setCurrentDirection:(TCPadDirection)currentDirection {
    _currentDirection = currentDirection;
    switch (_currentDirection) {
        case TCPadDirectionUpLeft:
            [self hideImgeViewBut:self.leftUpArrowImgView];
            break;
        case TCPadDirectionLeft:
            [self hideImgeViewBut:self.leftArrowImgView];
            break;
        case TCPadDirectionDownLeft:
            [self hideImgeViewBut:self.leftDownArrowImgView];
            break;
        case TCPadDirectionUp:
            [self hideImgeViewBut:self.upArrowImgView];
            break;
        case TCPadDirectionNone:
            [self hideImgeViewBut:nil];
            break;
        case TCPadDirectionDown:
            [self hideImgeViewBut:self.downArrowImgView];
            break;
        case TCPadDirectionUpRight:
            [self hideImgeViewBut:self.rightUpArrowImgView];
            break;
        case TCPadDirectionRight:
            [self hideImgeViewBut:self.rightArrowImgView];
            break;
        case TCPadDirectionDownRight:
            [self hideImgeViewBut:self.rightDownArrowImgView];
            break;
            
        default:
            break;
    }
}

- (void) hideImgeViewBut:(UIImageView *)imgView {
    self.leftUpArrowImgView.hidden = !([self.leftUpArrowImgView isEqual:imgView]);
    self.leftArrowImgView.hidden = !([self.leftArrowImgView isEqual:imgView]);
    self.leftDownArrowImgView.hidden = !([self.leftDownArrowImgView isEqual:imgView]);
    self.upArrowImgView.hidden = !([self.upArrowImgView isEqual:imgView]);
    self.centerImgView.hidden = !([self.centerImgView isEqual:imgView]);
    self.downArrowImgView.hidden = !([self.downArrowImgView isEqual:imgView]);
    self.rightUpArrowImgView.hidden = !([self.rightUpArrowImgView isEqual:imgView]);
    self.rightArrowImgView.hidden = !([self.rightArrowImgView isEqual:imgView]);
    self.rightDownArrowImgView.hidden = !([self.rightDownArrowImgView isEqual:imgView]);
}


#pragma mark - getter

- (UIImageView *)leftArrowImgView {
    if (_leftArrowImgView == nil) {
        _leftArrowImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pad_left"]];
        _leftArrowImgView.hidden = YES;
        [self addSubview:_leftArrowImgView];
    }
    return _leftArrowImgView;
}

- (UIImageView *)rightArrowImgView {
    if (_rightArrowImgView == nil) {
        _rightArrowImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pad_right"]];
        _rightArrowImgView.hidden = YES;
        [self addSubview:_rightArrowImgView];
    }
    return _rightArrowImgView;
}

- (UIImageView *)upArrowImgView {
    if (_upArrowImgView == nil) {
        _upArrowImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pad_up"]];
        _upArrowImgView.hidden = YES;
        [self addSubview:_upArrowImgView];
    }
    return _upArrowImgView;
}

- (UIImageView *)downArrowImgView {
    if (_downArrowImgView == nil) {
        _downArrowImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pad_down"]];
        _downArrowImgView.hidden = YES;
        [self addSubview:_downArrowImgView];
    }
    return _downArrowImgView;
}
- (UIImageView *)leftUpArrowImgView {
    if (_leftUpArrowImgView == nil) {
        _leftUpArrowImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pad_leftup"]];
        _leftUpArrowImgView.hidden = YES;
        [self addSubview:_leftUpArrowImgView];
    }
    return _leftUpArrowImgView;
}

- (UIImageView *)leftDownArrowImgView {
    if (_leftDownArrowImgView == nil) {
        _leftDownArrowImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pad_leftdown"]];
        _leftDownArrowImgView.hidden = YES;
        [self addSubview:_leftDownArrowImgView];
    }
    return _leftDownArrowImgView;
}

- (UIImageView *)rightUpArrowImgView {
    if (_rightUpArrowImgView == nil) {
        _rightUpArrowImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pad_rightup"]];
        [self addSubview:_rightUpArrowImgView];
        _rightUpArrowImgView.hidden = YES;
    }
    return _rightUpArrowImgView;
}

- (UIImageView *)rightDownArrowImgView {
    if (_rightDownArrowImgView == nil) {
        _rightDownArrowImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pad_rightdown"]];
        [self addSubview:_rightDownArrowImgView];
        _rightDownArrowImgView.hidden = YES;
    }
    return _rightDownArrowImgView;
}

- (UIImageView *)centerImgView {
    if (_centerImgView == nil) {
        _centerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pad_center"]];
        [self addSubview:_centerImgView];
        _centerImgView.hidden = YES;
    }
    return _centerImgView;
}

- (UIButton *) zoomInBtn {
    if (_zoomInBtn == nil) {
        _zoomInBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_zoomInBtn setTitle:@"放大" forState:UIControlStateNormal];
        [self addSubview:_zoomInBtn];
    }
    return _zoomInBtn;
}

- (UIButton *) zoomOutBtn {
    if (_zoomOutBtn == nil) {
        _zoomOutBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_zoomOutBtn setTitle:@"缩小" forState:UIControlStateNormal];
        [self addSubview:_zoomOutBtn];
    }
    return _zoomOutBtn;
}



- (void)commonInit {
    self.currentDirection = TCPadDirectionNone;
    _currentZoom = TCPadZoomNone;
    _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGuesture:)];
    [self addGestureRecognizer:_pinchGesture];
    [self.zoomInBtn addTarget:self action:@selector(handleZoomInBtnDown) forControlEvents:UIControlEventTouchDown];
    [self.zoomInBtn addTarget:self action:@selector(handleZoomInBtnUp) forControlEvents:UIControlEventTouchUpInside];
   
    
    [self.zoomOutBtn addTarget:self action:@selector(handleZoomOutBtnDown) forControlEvents:UIControlEventTouchDown];
    [self.zoomOutBtn addTarget:self action:@selector(handleZoomOutBtnUp) forControlEvents:UIControlEventTouchUpInside];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    
    [self.leftUpArrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.width.equalTo(self).dividedBy(3);
        make.height.equalTo(self).dividedBy(3);
    }];
    
    [self.leftArrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self);
        make.width.equalTo(self).dividedBy(3);
        make.height.equalTo(self).dividedBy(3);
    }];
    
    [self.leftDownArrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(self).dividedBy(3);
        make.height.equalTo(self).dividedBy(3);
    }];
    
    [self.upArrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self);
        make.width.equalTo(self).dividedBy(3);
        make.height.equalTo(self).dividedBy(3);
    }];
    
    [self.centerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(self.mas_width).dividedBy(3);
        make.height.equalTo(self).dividedBy(3);
    }];
    
    [self.downArrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.centerX.equalTo(self);
        make.width.equalTo(self).dividedBy(3);
        make.height.equalTo(self).dividedBy(3);
    }];
    
    [self.rightUpArrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.width.equalTo(self).dividedBy(3);
        make.height.equalTo(self).dividedBy(3);
    }];
    
    [self.rightArrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.centerY.equalTo(self);
        make.width.equalTo(self).dividedBy(3);
        make.height.equalTo(self).dividedBy(3);
    }];
    
    [self.rightDownArrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(self).dividedBy(3);
        make.height.equalTo(self).dividedBy(3);
    }];
    
    [self.zoomOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    [self.zoomInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.bottom.equalTo(self.zoomOutBtn.mas_top).offset(-10);
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    TCPadDirection direction = [self directionForPoint:point];
    
    if (direction != self.currentDirection) {
        self.currentDirection = direction;
         NSLog(@"%lu", (unsigned long)self.currentDirection);
        if ([self.delegate respondsToSelector:@selector(TCPad:didPressDirection:)]) {
            [self.delegate TCPad:self didPressDirection:self.currentDirection];
        }
    }
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    TCPadDirection direction = [self directionForPoint:point];
    if (self.currentDirection != direction) {
        self.currentDirection = direction;
        NSLog(@"%lu", (unsigned long)self.currentDirection);
        if ([self.delegate respondsToSelector:@selector(TCPad:didPressDirection:)]) {
            [self.delegate TCPad:self didPressDirection:self.currentDirection];
        }
    }
}


- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.currentDirection = TCPadDirectionNone;
    NSLog(@"release, %s", __PRETTY_FUNCTION__);
    if ([self.delegate respondsToSelector:@selector(TCPadDidReleaseDirection:)]) {
        [self.delegate TCPadDidReleaseDirection:self];
    }
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.currentDirection = TCPadDirectionNone;
    NSLog(@"release, %s", __PRETTY_FUNCTION__);
    if ([self.delegate respondsToSelector:@selector(TCPadDidReleaseDirection:)]) {
        [self.delegate TCPadDidReleaseDirection:self];
    }
}

- (TCPadDirection)directionForPoint:(CGPoint)point {
    CGFloat x = point.x;
    CGFloat y = point.y;
    
    if (((x < 0) || (x > [self bounds].size.width)) ||
        ((y < 0) || (y > [self bounds].size.height)))
    {
        return TCPadDirectionNone;
    }
    
    NSUInteger column = x / ([self bounds].size.width / 3);
    NSUInteger row = y / ([self bounds].size.height / 3);
    
    TCPadDirection direction = (row * 3) + column + 1;
    
    return direction;
}

- (TCPadZoom)zoomForScale:(CGFloat)scale {
    TCPadZoom z = TCPadZoomNone;
    if (scale > 1) {
        z = TCPadZoomIn;
    } else {
        z = TCPadZoomOut;
    }
    return z;
}

- (void)handlePinchGuesture:(UIPinchGestureRecognizer *)pinchGesture {
    NSLog(@"pinch, scale: %f", pinchGesture.scale);
    
    switch (pinchGesture.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {
            TCPadZoom z = [self zoomForScale:pinchGesture.scale];
            if (z != _currentZoom) {
                _currentZoom = z;
                if ([self.delegate respondsToSelector:@selector(TCPad:didZoom:)]) {
                    [self.delegate TCPad:self didZoom:_currentZoom];
                }
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
            _currentZoom = TCPadZoomNone;
            if ([self.delegate respondsToSelector:@selector(TCPadReleaseZoom:)]) {
                [self.delegate TCPadReleaseZoom:self];
            }
            break;
        default:
            break;
    }
}

- (void)handleZoomInBtnDown {
    if ([self.delegate respondsToSelector:@selector(TCPad:didZoom:)]) {
        [self.delegate TCPad:self didZoom:TCPadZoomIn];
    }
}

- (void)handleZoomInBtnUp {
    if ([self.delegate respondsToSelector:@selector(TCPad:didZoom:)]) {
        [self.delegate TCPadReleaseZoom:self];
    }
}


- (void)handleZoomOutBtnDown {
    if ([self.delegate respondsToSelector:@selector(TCPad:didZoom:)]) {
        [self.delegate TCPad:self didZoom:TCPadZoomOut];
    }
}

- (void)handleZoomOutBtnUp {
    if ([self.delegate respondsToSelector:@selector(TCPad:didZoom:)]) {
        [self.delegate TCPadReleaseZoom:self];
    }
}


@end
