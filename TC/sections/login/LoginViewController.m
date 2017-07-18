//
//  LoginViewController.m
//  TC
//
//  Created by 郭志伟 on 15/11/11.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "LoginViewController.h"

#import <MRProgress/MRProgress.h>
#import "MBProgressHUD.h"
#import "UIColor+Hexadecimal.h"
#import "UITextField+TCStyle.h"
#import "UIButton+TCStyle.h"
#import "AppDelegate.h"
#import "TLAPI.h"
#import <UIView+Toast.h>
#import "RTWSContstants.h"
#import "TCLogin.h"
#import "TCTollgate.h"

#import "Reachability.h"


const float kEmblemCenterConstraintDefault = -184;
const float KEmblemCenterConstraintKeyboardShow = -308;

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emblemCenterConstraint;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *waitIndicator;

@end

@implementation LoginViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(BOOL) isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"ws://10.100.8.145:8080/ws"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            [APP_DELEGATE.webSocket open];
            [self loginBtnTapped:self.loginBtn];
                       break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            
            break;
    }
    
    if (!isExistenceNetwork) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        //hud.labelText = NSLocalizedString(INFO_NetNoReachable, nil);
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hide:YES afterDelay:3];
        return NO;
    }
    
    return isExistenceNetwork;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self isConnectionAvailable];
    
    [self.loginTextField setLabelTextFieldWithlabelName:@"  用户名 "];
    [self.pwdTextField setLabelTextFieldWithlabelName:@"  密   码  "];
    self.loginTextField.text = @"";
    self.pwdTextField.text = @"";
    self.waitIndicator.hidden = YES;
    [self.loginBtn setBorderStyleWithBorderColor:[UIColor colorWithHex:@"#29a0f8"] backgoundColor:[UIColor colorWithHex:@"#50b1f8"]];
    [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"sc_gray_btn_bg"] forState:UIControlStateDisabled];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGuesture:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtnTapped:(UIButton *)loginBtn {
    
    if (self.loginTextField.text.length == 0 || self.pwdTextField.text == 0) {
        return;
    }
    
    loginBtn.enabled = NO;
    self.waitIndicator.hidden = NO;
    [self.waitIndicator startAnimating];
    [self.loginTextField resignFirstResponder];
    [self.pwdTextField resignFirstResponder];
    self.loginTextField.enabled = NO;
    self.pwdTextField.enabled = NO;
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:self.loginTextField.text forKey:@"tv.user"];
    [ud setObject:self.pwdTextField.text forKey:@"tv.pwd"];
    [TLAPI loginTollegateDYWithUserName:self.loginTextField.text arr:NULL loginFlag:@"true" completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
    [TLAPI loginWithUserName:self.loginTextField.text pwd:self.pwdTextField.text completion:^(BOOL finished, NSError *error) {
        if (error == nil) {
            dispatch_group_t waitGroup = dispatch_group_create();
            dispatch_group_enter(waitGroup);
            __block BOOL arcTokenResult = YES;
            [TLAPI getArcgisTokenWithUsrName:@"jwmobile" pwd:@"jwmobile" completion:^(NSString *token, BOOL finished) {
                [self.waitIndicator stopAnimating];
                self.loginTextField.enabled = YES;
                                self.pwdTextField.enabled = YES;
                if (finished) {
                                       [[NSUserDefaults standardUserDefaults] setObject:[token copy] forKey:@"tl.mapToken"];
                    NSLog(@"可连接");
                    
                } else {
                    NSLog(@"不可连接");
                }
                arcTokenResult = finished;
                dispatch_group_leave(waitGroup);
            }];
    
//            [TLAPI getArcgisToken:
//             ^(NSString *string, BOOL finished) {
//                [self.waitIndicator stopAnimating];
//                self.loginTextField.enabled = YES;
//                self.pwdTextField.enabled = YES;
//                if (finished) {
//                   //[[NSUserDefaults standardUserDefaults] setObject:[token copy] forKey:@"tl.mapToken"];
//                    NSLog(@"可连接");
//                    
//                } else {
//                    NSLog(@"不可连接");
//                }
//                arcTokenResult = finished;
//                dispatch_group_leave(waitGroup);
//            }];
            
            __block BOOL scResult = YES;
            dispatch_group_enter(waitGroup);
            [APP_DELEGATE.tlMgr buildSCInfos:^(BOOL finished, NSError *error) {
                scResult = finished;
                if (!finished) {
                    [self.view makeToast:@"构造SC错误！"];
                    NSLog(@"%@", @"构造SC错误！");
                }else{
                    NSLog(@"sc可用");
                }
                dispatch_group_leave(waitGroup);
            }];
            
            
            __block BOOL highCamResult = YES;
            dispatch_group_enter(waitGroup);
            [APP_DELEGATE.tlMgr buildHighCamInfosWithToken:[TLAPI loginToken] completion:^(BOOL finished, NSError *error) {
                highCamResult = finished;
                if (!finished) {
                    NSLog(@"token");
                    NSLog(@"%@", @"构造highcam错误！");
                    [self.view makeToast:@"构造highcam错误！"];
                }else{
                    NSLog(@"high可用");
                }
                dispatch_group_leave(waitGroup);
            }];
            
            __block BOOL roadCamResult = YES;
            dispatch_group_enter(waitGroup);
            [APP_DELEGATE.tlMgr buildRoadCamInfosWithToken:[TLAPI loginToken] completion:^(BOOL finished, NSError *error) {
                roadCamResult = finished;
                if (!finished) {
                    NSLog(@"%@", @"构造roadcam错误！");
                    [self.view makeToast:@"构造roadcam错误！"];
                }else {
                    NSLog(@"roadcam可用");
                }
                dispatch_group_leave(waitGroup);
            }];
            
            __block BOOL elecPoliceResult = YES;
            dispatch_group_enter(waitGroup);
            [APP_DELEGATE.tlMgr buildElecPoliceInfosWithToken:[TLAPI loginToken] completion:^(BOOL finished, NSError *error) {
                elecPoliceResult = finished;
                if (!finished) {
                    NSLog(@"%@", @"构造电子警察错误！");
                    [self.view makeToast:@"构造电子警察错误！"];
                }else{
                    NSLog(@"电子警察可用");
                }
                dispatch_group_leave(waitGroup);
            }];
            
            __block BOOL loginVideoSvc = YES;
            dispatch_group_enter(waitGroup);
            @try {
                [APP_DELEGATE.tvMgr loginWithInView:self.view completion:^(BOOL finished, NSError *error) {
                    if (!finished) {
                        NSLog(@"登录宇视服务器失败,%@", error);
                        [self.view makeToast:[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"desc"]]];
                        
                    }else{
                        NSLog(@"get in");
                    }
                    loginVideoSvc = finished;
                    dispatch_group_leave(waitGroup);
                }];
            } @catch (NSException *exception) {
                NSLog(@"%@",exception);
            } @finally {
                
            }
            
            
             // 登录websocket服务器
            __block BOOL loginWs = YES;
            dispatch_group_enter(waitGroup);
            [APP_DELEGATE.wsMgr connectWithCompletion:^(NSError *err) {
                if (err != nil) {
                    loginWs = NO;
                    //NSLog(@"nnnnn");
                    dispatch_group_leave(waitGroup);
                    
                }else{
                   // NSLog(@"nnnnn");
                }
                
                [TCLogin loginWithUsr:self.loginTextField.text pwd:self.pwdTextField.text wsmgr:APP_DELEGATE.wsMgr withResult:^(RTWSMsg *resp) {
                    NSLog(@"%@",self.loginTextField.text);
                    APP_DELEGATE.usr = [[TCUser alloc] initWithUsrId:self.loginTextField.text];
                    dispatch_group_leave(waitGroup);
                }];
            }];
            
            dispatch_group_notify(waitGroup, dispatch_get_main_queue(), ^{
                if ( arcTokenResult&&scResult && highCamResult && roadCamResult && elecPoliceResult &&loginVideoSvc) {
                    [APP_DELEGATE changeRootViewController:[APP_DELEGATE buildMainController]];
                } else {
                    NSLog(@"失败");
                    self.loginTextField.enabled = YES;
                    self.pwdTextField.enabled = YES;
                    self.loginBtn.enabled  = YES;
                    [APP_DELEGATE.wsMgr close];
                }
            });
        } else {
            NSLog(@"登录失败， %@", error);
            loginBtn.enabled = YES;
            [self.waitIndicator stopAnimating];
            self.loginTextField.enabled = YES;
            self.pwdTextField.enabled = YES;
        }
    }];
    
    
}

- (void)handleKeyboardWillShowNotification:(NSNotification *)notification {
    [UIView animateWithDuration:1.0 animations:^{
        self.emblemCenterConstraint.constant = KEmblemCenterConstraintKeyboardShow;
    }];
}

- (void)handleKeyboardWillHideNotification:(NSNotification *)notification {
    [UIView animateWithDuration:1.0 animations:^{
        self.emblemCenterConstraint.constant = kEmblemCenterConstraintDefault;
    }];
}

- (void)handleTapGuesture:(UITapGestureRecognizer *)gesture {
    [self.loginTextField resignFirstResponder];
    [self.pwdTextField resignFirstResponder];
}

@end
