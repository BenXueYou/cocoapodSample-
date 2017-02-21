//
//  QCSystemServiceProtocol.m
//  cocoapodSample
//
//  Created by cnc on 16/9/6.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import "QCSystemServiceProtocol.h"

@interface QCSystemServiceProtocol ()

@end

@implementation QCSystemServiceProtocol

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"服务协议";
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
