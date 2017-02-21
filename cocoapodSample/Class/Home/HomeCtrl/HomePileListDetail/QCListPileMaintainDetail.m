//
//  QCListPileMaintainDetail.m
//  cocoapodSample
//
//  Created by cnc on 16/9/1.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import "QCListPileMaintainDetail.h"

@interface QCListPileMaintainDetail ()

@property (strong, nonatomic) IBOutlet UILabel *cpnum;

@property (strong, nonatomic) IBOutlet UILabel *fualt;

@property (strong, nonatomic) IBOutlet UILabel *address;

@property (strong, nonatomic) IBOutlet UILabel *rmname;

@property (strong, nonatomic) IBOutlet UILabel *rmphone;

@end

@implementation QCListPileMaintainDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigation];
//    self.model.cpid = @"1";
//    self.model.rmname = @"ljf";
//    self.model.rmphone = @"183-2497-7850";
    self.cpnum.text = [NSString stringWithFormat:@"%@",self.model.cpid];
    
    self.address.text = [NSString stringWithFormat:@"%@%@%@%@",self.model.province,self.model.city,self.model.area,self.model.address];
    
//    self.address.text = @"上海市杨浦区长阳路1080号国际设计交流中心10号楼201B";
    
    self.rmname.text = [NSString stringWithFormat:@"%@",self.model.rmname];
    self.rmphone.text = [NSString stringWithFormat:@"%@",self.model.rmphone];
   
    self.navigationItem.title = [NSString stringWithFormat:@"%@号维护桩",self.model.cpid];
//    self.navigationItem.title = [NSString stringWithFormat:@"%@号维护桩",@"1"];
    
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;

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
