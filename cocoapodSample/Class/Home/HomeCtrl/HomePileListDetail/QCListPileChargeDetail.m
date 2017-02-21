//
//  QCListPileChargeDetail.m
//  cocoapodSample
//
//  Created by cnc on 16/8/25.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import "QCListPileChargeDetail.h"

#import "QCTabBarController.h"
#import "AppDelegate.h"
#import "QCPileListCtrl.h"
#import "ZFLineChart.h"
@interface QCListPileChargeDetail ()

@property (weak, nonatomic) ZFLineChart *MoneryChartView;
@property (weak, nonatomic) ZFLineChart *ChargeChartView;

@property (nonatomic,strong) NSMutableArray *XValues;
@property (nonatomic,strong) NSMutableArray *YValues;
@property (nonatomic,strong) NSMutableArray *MoneryValues;
@property (nonatomic,strong) NSMutableArray *ChargeValues;

@end

@implementation QCListPileChargeDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    self.XValues = [@[@"7",@"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17"] mutableCopy];
  
    
    [self DrawChargeView];
    [self DrawMoneryView];
    
//    self.model.cpid = @"1";
    self.navigationItem.title = [NSString stringWithFormat:@"%@号桩运营",self.model.cpid];
//    self.navigationItem.title = @"3号桩运营";
    [self setNavigation];
}

-(void)setNavigation{
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_arrow"] style:(UIBarButtonItemStyleDone) target:self action: @selector(back)];
    
    self.navigationItem.leftBarButtonItem = button;
}

-(void)back{

//    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)DrawChargeView{
    
   
    CGFloat chartViewW = 300;
    CGFloat chartViewX = (SCREEN_WIDTH - 300) / 2;
    CGFloat chartViewY = SCREEN_HEIGHT / 2;
    
    CGFloat chartViewH = SCREEN_HEIGHT / 3;
   
    self.YValues = [ @[@"75kWh", @"20kWh", @"90kWh", @"50kWh", @"55kWh", @"60kWh", @"50kWh", @"50kWh", @"34kWh", @"67kWh"] mutableCopy];
    
    ZFLineChart *lineChart = [[ZFLineChart alloc]initWithFrame:CGRectMake(chartViewX, chartViewY, chartViewW, chartViewH) withTextX:@"kWh" withTextT:@"h"];
    lineChart.title =  @"充电情况折线图/kWh";
    lineChart.xLineValueArray = self.YValues;
    lineChart.xLineTitleArray = self.XValues;
    lineChart.yLineMaxValue = 100;
    lineChart.yLineSectionCount = 10;
    lineChart.textY = @"kWh";
    lineChart.textX = @"h";
    NSLog(@"self.text == %@",lineChart.textY);

    lineChart.lineColor = [UIColor greenColor];
    [self.view addSubview:lineChart];
    [lineChart strokePath];
    lineChart.scrollEnabled = NO;
    self.MoneryChartView = lineChart;
}


-(void)DrawMoneryView{
    
    CGFloat chartViewW = 300;
    CGFloat chartViewX = (SCREEN_WIDTH - 300) / 2;
    CGFloat chartViewY = 20;
    
    CGFloat chartViewH = SCREEN_HEIGHT / 2.5;
    
    self.YValues = [ @[@"75元", @"20元", @"90元", @"50元", @"55元", @"60元", @"50元", @"50元", @"34元", @"67元"] mutableCopy];

    ZFLineChart *lineChart = [[ZFLineChart alloc]initWithFrame:CGRectMake(chartViewX, chartViewY, chartViewW, chartViewH) withTextX:@"h" withTextT:@"元"];
    lineChart.textY = @"元";
    lineChart.textX = @"h";
    NSLog(@"self.text == %@",lineChart.textX);
    NSLog(@"self.text == %@",lineChart.textY);
    lineChart.title = @"收入情况折线图/元";
    
    lineChart.lineColor = [UIColor purpleColor];
    
    lineChart.xLineValueArray = self.YValues;
    lineChart.xLineTitleArray = self.XValues;
    lineChart.yLineMaxValue = 100;
    lineChart.yLineSectionCount = 10;
  

    [self.view addSubview:lineChart];
    [lineChart strokePath];
   
    self.ChargeChartView = lineChart;
    
    
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}


-(NSMutableArray *)XValues{
    
    if (!_XValues) {
        _XValues = [[NSMutableArray alloc] init];
    }
    return _XValues;
}

-(NSMutableArray *)YValues{
    
    if (!_YValues) {
        _YValues = [[NSMutableArray alloc] init];
    }
    return _YValues;
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
