//
//  RTWSMgr.m
//  websocketDemo
//
//  Created by 郭志伟 on 16/2/26.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import "RTWSMgr.h"
#import "RTWSMsgConstants.h"
#import "RTWSMsgFactory.h"
#import "TCFuncViewController.h"
#import "AppDelegate.h"
#import "NSString+AESCrypt.h"
typedef void (^callback)(id, NSError*);
typedef void (^connectCpl)(NSError*);

@interface RTWSMgr() <SRWebSocketDelegate,NSStreamDelegate> {
    SRWebSocket *_ws;
    connectCpl _connCpl;

}

@property(nonatomic, copy) NSString *addr;
@property(nonatomic, strong) NSMutableDictionary *cpltDict;
@property(nonatomic,strong)NSInputStream *inputStream;
@property(nonatomic,strong)NSOutputStream *outputStream;
@property(nonatomic, strong) NSTimer *timer;

@end

@implementation RTWSMgr


- (instancetype)initWithAddr:(NSString *)addr {
    if (self = [super init]) {
        self.addr = addr;
        self.cpltDict = [[NSMutableDictionary alloc] init];
               }
    return self;
}


- (SRWebSocket *)ws {
    return _ws;
}


- (void)sendMsg:(RTWSMsg *)msg {
    NSString *jsonStr = [msg toJsonString];
    [_ws send:jsonStr];
}

- (void)sendMsg:(RTWSMsg *)msg withCompletion:(void(^)(id result, NSError *error))completion {
    if (completion) {
        [self.cpltDict setValue:completion forKey:msg.msgId];
    }
    [_ws send:[msg toJsonString]];
}

- (void)close {
    [self.timer invalidate];
    [_ws close];
}


- (void)connectWithCompletion:(void(^)( NSError* err))completion {
    if (completion) {
        _connCpl = completion;
    }
    
    _ws = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:self.addr]];
   

    _ws.delegate = self;
    [_ws open];
}

- (void)stopTimer {
    [self.timer invalidate];
}

- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:60.0f target:self selector:@selector(sendPing) userInfo:nil repeats:YES];
}

- (void)sendPing {
    NSLog(@"send ping");
    RTWSMsg *pingMsg = [[RTWSMsg alloc] init];
    pingMsg.topic = kTopicPing;
    [self sendMsg:pingMsg];
    
}

#pragma mark - websocket delegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    
        if (_connCpl) {
            _connCpl(nil);
            _connCpl = nil;
        }
    
   [self startTimer];
    
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    if (_connCpl) {
        _connCpl(error);
        _connCpl = nil;
    }

    if ([self.delegate respondsToSelector:@selector(RTWSMgr:socketDidCloseWithReason:)]) {
        [self.delegate RTWSMgr:self socketDidCloseWithReason:error.description];
        TCFuncViewController *tcf= [[TCFuncViewController alloc]init];
        [tcf handleExit];
        
    }
    
    [self stopTimer];
    
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    //RTWSMsg *msg=[[RTWSMsg alloc]init];
    //[_ws send:msg];
    //[self sendMsg:msg];
    //[_ws send:kTopicLogout];
    [self.cpltDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        callback c = obj;
        c(nil, [NSError errorWithDomain:@"ws" code:10 userInfo:@{@"desc":reason}]);
    }];
    [self.cpltDict removeAllObjects];
   
    
    if ([self.delegate respondsToSelector:@selector(RTWSMgr:socketDidCloseWithReason:)]) {
        [self.delegate RTWSMgr:self socketDidCloseWithReason:reason];
    }
    [self stopTimer];
}


- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
   
    NSLog(@"self.message%@",message);
        if ([message isKindOfClass:[NSString class]]) {
        NSString *str = message;
        NSData *d = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err = nil;
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:d options:NSJSONReadingMutableContainers error:&err];
        NSString *msgid = [dict objectForKey:@"msgid"];
        callback c = [self.cpltDict valueForKey:msgid];
        if (c) {
            c(dict, nil);
            [self.cpltDict removeObjectForKey:msgid];
        } else {
            [RTWSMsgFactory handleMsg:dict];
        }
    } else {
        NSLog(@"接受到非Text类型的消息");
    }
    
    
    

}



@end
