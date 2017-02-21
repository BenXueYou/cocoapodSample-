//
//  QCLoginCtrl.m
//  cocoapodSample
//
//  Created by cnc on 16/8/18.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import "QCLoginCtrl.h"
#import "QCTabBarController.h"
#import "YYKit.h"
#import "MBProgressHUD.h"
#import "QCHttpTool.h"
#import "QCReminderUserTool.h"
#import "GlobalClass.h"

#import "QCAdminModel.h"

@interface QCLoginCtrl ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userIDText;//用户名
@property (weak, nonatomic) IBOutlet UITextField *pwdText;//密码
@property (weak, nonatomic) IBOutlet UIButton *autoLogin;//自动登录
@property (weak, nonatomic) IBOutlet UIButton *rememberPwd;//记住密码

@property (nonatomic,assign) bool rememberPwdFlg;//记住密码标识
@property (nonatomic,assign) bool autoLoginFlg;//自动登录标识

@end

@implementation QCLoginCtrl
//常量字符串，定义key值
NSString *const UserRememberBoolKey     = @"rememberPwd";//用户记住密码
NSString *const UserAutoLoginBoolKey    = @"autoLogin";//用户自动登录
NSString *const userNameStrKey          = @"name";//用户名
NSString *const userPwdStrKey           = @"userPwd";//用户密码
NSString *const userKindStrKey           = @"userkind";//用户类型


- (void) viewDidAppear:(BOOL)animated
{
    //    判断自动登录
    if (_autoLoginFlg) {
        [UIApplication sharedApplication].keyWindow.rootViewController = [[QCTabBarController alloc]init];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _userIDText.delegate = self;
    _pwdText.delegate    = self;
//    加载页面
    [self setupView];
}

- (void) setupView
{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    
    _rememberPwdFlg = [[accountDefaults objectForKey:UserRememberBoolKey] boolValue];
    
    if (_rememberPwdFlg) {
        [self.rememberPwd setImage:[UIImage imageNamed:@"selected.png" ] forState:UIControlStateNormal];
        self.userIDText.text = [accountDefaults objectForKey:userNameStrKey];
        self.pwdText.text = [accountDefaults objectForKey:userPwdStrKey];
    } else {
        [self.rememberPwd setImage:[UIImage imageNamed:@"select.png" ] forState:UIControlStateNormal];
    }
    _autoLoginFlg = [[accountDefaults objectForKey:UserAutoLoginBoolKey] boolValue];
    if (_autoLoginFlg) {
        [self.autoLogin setImage:[UIImage imageNamed:@"selected.png" ] forState:UIControlStateNormal];
    } else {
        [self.autoLogin setImage:[UIImage imageNamed:@"select.png" ] forState:UIControlStateNormal];
    }
}

- (IBAction)login:(id)sender {
    //    设置根视图
    [UIApplication sharedApplication].keyWindow.rootViewController = [[QCTabBarController alloc]init];
    
    
    // save password,through the server for account validation
    if ([self.userIDText.text isNotBlank] && [self.pwdText.text isNotBlank]) { // 帐号密码都不为空
        
//        添加悬浮动画
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = NSLocalizedString(@"登录中...", @"HUD loading title");
        [hud showAnimated:YES];
        
        
//        将输入框内容转换为字典参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"loginid"] = self.userIDText.text;
        params[@"passwd"] = self.pwdText.text;
        NSString *ulrString = [NSString stringWithFormat:@"%@%@",CPMAPI_PREFIX,CPMAPI_USER_LOGIN];
        
//        将参数传回服务器
        [QCHttpTool httpQueryData:ulrString params:params success:^(id json) {

//            请求返回的数据
            NSString *errorCode = json[@"errorCode"];
//            NSLog(@"---json---%@",json);
            
//            数据返回不为空，则切换根视图登录APP展示数据
            if (![errorCode isNotBlank]) {
                [hud hideAnimated:YES];
                
//       登录账号信息保存
                [self saveLoginAccount:json];
//      切换根视图
        [UIApplication sharedApplication].keyWindow.rootViewController = [[QCTabBarController alloc]init];
                
//          检查登录状态
                [self checkRemenberState];
                
            } else {
//                否则弹窗提示错误
                [hud hideAnimated:YES];
                [QCReminderUserTool showError:self.view str:@"服务器繁忙"];
            }
        } failure:^(NSError *error) {
            
            NSLog(@"%@",error);
            //            弹窗错误提醒
            [QCReminderUserTool showError:self.view str:@"登录失败，用户名或密码错误"];
            [hud hideAnimated:YES];
        }];
    } else {
        if (![self.userIDText.text isNotBlank]) {
            //            提醒弹窗
            [QCReminderUserTool showError:self.view str:@"用户名不能为空"];
        } else if (![self.pwdText.text isNotBlank]) {
            //            提醒弹窗
            [QCReminderUserTool showError:self.view str:@"密码不能为空"];
        }
        
    }
    
}

#pragma =======账号信息保存=======
-(void)saveLoginAccount:(NSDictionary *)json{
    
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];

    NSArray *userArr = json[@"detail"];
    for (NSDictionary *dict in userArr) {
        NSLog(@"---userName---%@",dict[@"username"]);
        NSLog(@"---userKind---%@",dict[@"userkind"]);
        //        将用户名保存本地
        [accountDefaults setObject:dict[@"username"] forKey:userNameStrKey];
        //        将用户类型保存本地
        [accountDefaults setObject:dict[@"userkind"] forKey:userKindStrKey];
    }

    QCAdminModel *userData = [[QCAdminModel alloc] init];
    userData.userID = [accountDefaults objectForKey:userNameStrKey];
    userData.passWord = [accountDefaults objectForKey:userPwdStrKey];
    userData.icon = [UIImage imageNamed:@"icon"];
    userData.nickName = @"小小鸟er";
    userData.sex = @"男";
    
    int userRight = [[accountDefaults objectForKey:userKindStrKey] intValue];
    switch (userRight) {
        case 1: {
            userData.permission = @"超级管理员";
            break;
        }
        case 2: {
            userData.permission = @"普通管理员";
            break;
        }
        case 3: {
            userData.permission = @"普通用户";
            break;
        }
        default: {
            userData.permission = @"普通用户";
            break;
        }
    }

    [GlobalClass sharedInStance].model = userData;
}

#pragma ========检查登录状态=======
-(void)checkRemenberState{

    if (_rememberPwdFlg) {  // 登录时，如果有选中记住密码，则记住
        if (self.userIDText.text && self.pwdText.text) {
            [[NSUserDefaults standardUserDefaults] setObject:self.userIDText.text forKey:userNameStrKey];
            [[NSUserDefaults standardUserDefaults] setObject:self.pwdText.text forKey:userPwdStrKey];
        }
    }

}

- (IBAction)rememberPwd:(id)sender {
    _rememberPwdFlg = !_rememberPwdFlg;
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    if (_rememberPwdFlg) {
        [self.rememberPwd setImage:[UIImage imageNamed:@"selected.png" ] forState:UIControlStateNormal];
        
        if (self.userIDText.text && self.pwdText.text) {
            [accountDefaults setObject:self.userIDText.text forKey:userNameStrKey];
            [accountDefaults setObject:self.pwdText.text forKey:userPwdStrKey];
        }
        
    } else {
        [self.rememberPwd setImage:[UIImage imageNamed:@"select.png" ] forState:UIControlStateNormal];
    }
    
    [accountDefaults setBool:_rememberPwdFlg forKey:UserRememberBoolKey];
    [accountDefaults synchronize];
}
- (IBAction)autoLogin:(id)sender {
    _autoLoginFlg = !_autoLoginFlg;
    
    if (_autoLoginFlg) {
        [self.autoLogin setImage:[UIImage imageNamed:@"selected.png" ] forState:UIControlStateNormal];
    } else {
        [self.autoLogin setImage:[UIImage imageNamed:@"select.png" ] forState:UIControlStateNormal];
    }
    //    将自动登录按钮添加到本地保存
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setBool:_autoLoginFlg forKey:UserAutoLoginBoolKey];
    [accountDefaults synchronize];
}

#pragma mark - UITextFiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (![_userIDText isExclusiveTouch]) {
        [_userIDText resignFirstResponder];
    }
    if (![_pwdText isExclusiveTouch]) {
        [_pwdText resignFirstResponder];
    }
}

@end
