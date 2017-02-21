//
//  QCFeedBackCtrl.m
//  chargePileManage
//
//  Created by YuMing on 16/6/20.
//  Copyright © 2016年 shQianChen. All rights reserved.
//

#import "QCFeedBackCtrl.h"
#import "QCReminderUserTool.h"
@interface QCFeedBackCtrl ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *feedBackText;
@property (weak, nonatomic) IBOutlet UIButton *submit;



@end

@implementation QCFeedBackCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = XYCOLOR(246,246,246,1);
    
    _feedBackText.backgroundColor = [UIColor whiteColor];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    
    [self setNavigation];
    
    self.feedBackText.delegate = self;
}

-(void)tapAction:(UITapGestureRecognizer *)tap{

    [self.feedBackText resignFirstResponder];
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


- (IBAction)upLoadMessage:(id)sender {
    
    NSLog(@"点击了提交按钮");
    
    [QCReminderUserTool showError:self.view str:@"提交成功"];
    
    [self performSelector:@selector(back) withObject:nil afterDelay:1.0];

    
}

#pragma mark =======UITextFieldDelegate=========


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}




- (void)didReceiveMemoryWarning {
    
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
