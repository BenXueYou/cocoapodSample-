//
//  QCCheckSupplyCtrl.m
//  cocoapodSample
//
//  Created by cnc on 16/8/25.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import "QCCheckSupplyCtrl.h"

@interface QCCheckSupplyCtrl ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UILabel *name;

@property (strong, nonatomic) IBOutlet UILabel *ages;
@property (strong, nonatomic) IBOutlet UILabel *CarKind;
@property (strong, nonatomic) IBOutlet UILabel *carAge;

@property (strong, nonatomic) IBOutlet UILabel *phone;


@property (strong, nonatomic) IBOutlet UILabel *AllCharge;
@property (strong, nonatomic) IBOutlet UILabel *AllFee;


@property (strong, nonatomic) IBOutlet UILabel *resentCharge;

@property (strong, nonatomic) IBOutlet UILabel *chargeNUm;

@property (strong, nonatomic) IBOutlet UILabel *chargeTime;
@property (strong, nonatomic) IBOutlet UILabel *chargeFee;
@property (strong, nonatomic) IBOutlet UILabel *address;

@end

@implementation QCCheckSupplyCtrl

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
