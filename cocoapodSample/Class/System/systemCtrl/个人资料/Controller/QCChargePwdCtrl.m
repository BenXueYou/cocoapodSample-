//
//  QCChargePwdCtrl.m
//  chargePileManage
//
//  Created by YuMing on 16/6/17.
//  Copyright © 2016年 shQianChen. All rights reserved.
//

#import "QCChargePwdCtrl.h"
#import "UIColor+hex.h"
#import "QCReminderUserTool.h"
@interface QCChargePwdCtrl () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITextField *oldPwd;
@property (weak, nonatomic) IBOutlet UITextField *creatPwd;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwd;
- (IBAction)savePwd:(id)sender;
@property (nonatomic,weak) UIImageView *bgImage;
@end

@implementation QCChargePwdCtrl
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = XYCOLOR(246, 246, 246,1);
    _oldPwd.delegate = self;
    _creatPwd.delegate = self;
    _confirmPwd.delegate = self;
    
    _topView.backgroundColor = [UIColor whiteColor];
 
    [self setNavigation];
}

//返回按钮
-(void)setNavigation{
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_arrow"] style:(UIBarButtonItemStyleDone) target:self action: @selector(back)];
    
    self.navigationItem.leftBarButtonItem = button;
}

-(void)back{
    
    //    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)savePwd:(id)sender {
    
    NSLog(@"点击了保存按钮");
    
    [QCReminderUserTool showError:self.view str:@"修改成功"];
    
    [self performSelector:@selector(back) withObject:nil afterDelay:1.0];
    
//    [self back];
    
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _oldPwd) {
        [_oldPwd resignFirstResponder];
    }
    if (textField == _creatPwd) {
        [_creatPwd resignFirstResponder];
    }
    if (textField == _confirmPwd) {
        [_confirmPwd resignFirstResponder];
    }
    return YES;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (![_oldPwd isExclusiveTouch]) {
        [_oldPwd resignFirstResponder];
    }
    if (![_creatPwd isExclusiveTouch]) {
        [_creatPwd resignFirstResponder];
    }
    if (![_confirmPwd isExclusiveTouch]) {
        [_confirmPwd resignFirstResponder];
    }
}
@end
