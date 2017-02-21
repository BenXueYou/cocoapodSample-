//
//  XYNaviGationController.m
//  cocoapodSample
//
//  Created by cnc on 16/8/17.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import "XYNaviGationController.h"

@implementation XYNaviGationController
- (void)dealloc
{
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
     
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (IS_IOS_7) {
        self.navigationBar.translucent = NO;
        self.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationBar.barTintColor = [UIColor colorWithHex:0X299dff] ;
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    }else{
        //        self.navigationBar.tintColor = QGCOLOR(41, 148, 219, 1);
        //        self.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor]};
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
