//
//  QCListPileChargingDetail.m
//  cocoapodSample
//
//  Created by cnc on 16/8/26.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import "QCListPileChargingDetail.h"

#import "VWWWaterView.h"
#import "WBPopMenuModel.h"
#import "WBPopMenuSingleton.h"

#import "ZCTradeView.h"

#import "QCHttpTool.h"
@interface QCListPileChargingDetail ()<ZCTradeViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *batteryImg;

@property (strong, nonatomic) IBOutlet UILabel *SOC;

@property (strong, nonatomic) IBOutlet UILabel *dumpEnery;

@property (strong, nonatomic) IBOutlet UILabel *leftTime;

@property (strong, nonatomic) IBOutlet UILabel *currentVolage;

@property (strong, nonatomic) IBOutlet UILabel *currentCircle;


@property (strong, nonatomic) IBOutlet UILabel *totalFeeLabel;

@property (strong, nonatomic) IBOutlet UILabel *totalQuantityLabel;


@property (nonatomic,weak) NSTimer *myTimer;

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) VWWWaterView *waterView;




@property (nonatomic,copy) NSString *strPointQuantity;
@property (nonatomic,copy) NSString *strPointPrice;
@property (nonatomic,copy) NSString *strPointFee;

@property (nonatomic,copy) NSString *strPeakQuantity;
@property (nonatomic,copy) NSString *strPeakPrice;
@property (nonatomic,copy) NSString *strPeakFee;

@property (nonatomic,copy) NSString *strFlatQuantity;
@property (nonatomic,copy) NSString *strFlatPrice;
@property (nonatomic,copy) NSString *strFlatFee;

@property (nonatomic,copy) NSString *strValleyQuantity;
@property (nonatomic,copy) NSString *strValleyPrice;
@property (nonatomic,copy) NSString *strValleyFee;


@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign)float SOCFloat;

@end

@implementation QCListPileChargingDetail

-(UITableView *)tableView{

    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//   self.model.cpid = @"1";
   self.navigationItem.title = [NSString stringWithFormat:@"%@号桩详情",self.model.cpid];
//    self.navigationItem.title = @"2号桩充电";
//    初始化电池
     [self refreshBatteryInfoViewData];
    
    
    self.pointPrice = 1.23;
    self.peakPrice = 0.85;
    self.flatPrice = 0.6;
    self.valleyPrice = 0.45;
    
    
    [self setNavigation];
}




//定时器查询数据方法
- (void) timerEvent
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *chargePileID  = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",self.model.cpid ]];
    params[@"cpId"] = chargePileID;
    params[@"datacnt"] = @10;

    [QCHttpTool httpQueryCPData:params success:^(id json) {
        

        NSLog(@"------------json === %@",json);
        
        
        if ([json[@"errorCode"] isEqualToString:@"E0002"]) {
            return ;
        }
        NSArray *array = json[@"detail"];
        for (NSMutableDictionary *dic in array) {
            
            self.SOC.text = [NSString stringWithFormat:@"SOC：%@%%",dic[@"currentSoc"]];
            self.SOCFloat = [dic[@"currentSoc"] floatValue];
            self.currentCircle.text = [NSString stringWithFormat:@"%@",dic[@"currentACur"]];
            self.currentVolage.text = [NSString stringWithFormat:@"%@",dic[@"currentAVol"]];
            self.leftTime.text = [NSString stringWithFormat:@"%@",dic[@"remainTime"]];
            self.dumpEnery.text = [NSString stringWithFormat:@"%@",dic[@"chargeTime"]];
            self.totalFeeLabel.text = [NSString stringWithFormat:@"%@（元）",dic[@"totalfee"]];
            self.totalQuantityLabel.text = [NSString stringWithFormat:@"%@（kWh）",dic[@"totalquantity"]];
           
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"%@",self.SOC.text);
            NSLog(@"%@",self.currentVolage.text);
            NSLog(@"%@",self.currentCircle.text);
            NSLog(@"%@",self.dumpEnery.text);
            NSLog(@"%@",self.leftTime.text);

            [self viewDidLoad];
        });
    
    } failure:^(NSError *error) {
//        获取数据失败
        NSLog(@"++++++%@",error);
        
    }];

    
}
#pragma mark ---- 刷新电池----
-(void)refreshBatteryInfoViewData{

    
//    self.SOC.text = @"48%";
    
    _waterView.currentLinePointY = (1 - self.SOCFloat / 100.0) * self.bgView.frame.size.height;
    
    [self.bgView addSubview:self.waterView];
    [self.batteryImg addSubview:self.bgView];


}
//初始化波纹
-(VWWWaterView *)waterView{

    if (!_waterView) {
        _waterView = [[VWWWaterView alloc]initWithFrame:CGRectMake(3, 3, self.bgView.frame.size.width-5, self.bgView.frame.size.height-3)];
        _waterView.layer.cornerRadius = 10;
        _waterView.currentLinePointY = (1 - self.SOC.text.floatValue / 100.0) * self.bgView.frame.size.height;

        CGFloat pointVX = self.bgView.frame.origin.x + (self.bgView.frame.size.width - 15)/2;
        
        CGFloat pointVY = self.bgView.frame.origin.y -18;
        UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(pointVX, pointVY, 15, 10)];
        pointView.layer.cornerRadius = 5;
        pointView.backgroundColor = [UIColor colorWithHex:0x299dff];
        [self.bgView addSubview:pointView];

    }
    return _waterView;
}

//背景色
- (UIView *)bgView{
    
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.batteryImg.frame.size.width, self.batteryImg.frame.size.height -10)];
        _bgView.layer.cornerRadius = 10;
//        _bgView.layer.masksToBounds = YES;
        _bgView.layer.borderWidth = 3;
        _bgView.layer.borderColor = [UIColor colorWithHex:0x299dff].CGColor;
        _bgView.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:0.5];
    }
    
    return _bgView;
}



//界面已经消失需要停止定时器
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.myTimer setFireDate:[NSDate distantFuture]];
    [self.myTimer invalidate];
    self.myTimer = nil;
}

-(void)dealloc{
    
    [self.myTimer setFireDate:[NSDate distantFuture]];
    [self.myTimer invalidate];
     self.myTimer = nil;
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    
//    定时器定时查询
//    加入主循环池中
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop]addTimer:_myTimer forMode:NSDefaultRunLoopMode];
    
    [_myTimer fire];

    
    self.tabBarController.tabBar.hidden = YES;
}



- (IBAction)feeDetail:(id)sender {
    
    NSMutableArray *obj = [NSMutableArray array];
    
    for (NSInteger i = 0; i < [self titles].count; i++) {
        
        WBPopMenuModel * info = [WBPopMenuModel new];
        info.title = [self titles][i];
        [obj addObject:info];
    }
    
    [[WBPopMenuSingleton shareManager]showPopMenuSelecteWithFrame:200
                                                             item:obj
                                                           action:^(NSInteger index) {
                                                               
                                                               NSLog(@"index:%ld",(long)index);
                                                           }];
}


- (IBAction)start:(id)sender {
    ZCTradeView *view = [[ZCTradeView alloc] init];
    [view show];
    view.delegate = self;
}


- (IBAction)pause:(id)sender {
    
    ZCTradeView *view = [[ZCTradeView alloc] init];
    [view show];
    view.delegate = self;
}

- (IBAction)recover:(id)sender {
    
    ZCTradeView *view = [[ZCTradeView alloc] init];
    [view show];
    view.delegate = self;
}

- (IBAction)stop:(id)sender {
    ZCTradeView *view = [[ZCTradeView alloc] init];
    [view show];
    view.delegate = self;
    
}


//懒加载
- (NSArray *) titles {
    
    //    尖
    _strPointQuantity   = [_strPointQuantity stringByAppendingString:@" 度"];
    _strPointPrice      = [@"尖电价：" stringByAppendingString:[NSString stringWithFormat:@"%.2f", self.pointPrice]];
    _strPointPrice      = [_strPointPrice stringByAppendingString:@" 元/度"];

    
    
    //    峰
    _strPeakQuantity    = [_strPeakQuantity stringByAppendingString:@" 度"];
    _strPeakPrice       = [@"峰电价：" stringByAppendingString:[NSString stringWithFormat:@"%.2f 元/度", self.peakPrice]];
    
    //    平
    _strFlatQuantity    = [_strFlatQuantity stringByAppendingString:@" 度"];
    _strFlatPrice       = [@"平电价：" stringByAppendingString:[NSString stringWithFormat:@"%.2f元/度", self.flatPrice]];

    //    谷

    _strValleyPrice     = [@"谷电价：" stringByAppendingString:[NSString stringWithFormat:@"%.2f元/度", self.valleyPrice]];

    
    
    return @[
             _strPointPrice,//电价
             _strPeakPrice,
             _strFlatPrice,
             _strValleyPrice,
             
             ];
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




- (void) setTotalQuantity:(float)totalQuantity
{
    if (_totalQuantity != totalQuantity) {
        _totalQuantity = totalQuantity;
        _totalQuantityLabel.text = [NSString stringWithFormat:@"%.2f",_totalQuantity];
    }
}
- (void) setTotalFee:(float)totalFee
{
    if (_totalFee != totalFee) {
        _totalFee = totalFee;
        _totalFeeLabel.text =[NSString stringWithFormat:@"%.2f%@",totalFee,@" 元"];
    }
}
- (void) setAveragePrice:(float)averagePrice
{
    if (_averagePrice != averagePrice) {
        _averagePrice = averagePrice;
//        _averageElectPriceLbl.text = [@"平均电价：" stringByAppendingString:[NSString stringWithFormat:@"%.2f%@",averagePrice,@" 元/度"]];
    }
}

- (void) setAverageFee:(float)averageFee
{
    if (_averageFee != averageFee) {
        _averageFee =  averageFee;
//        _averageFeeLbl.text = [@"平均费用：" stringByAppendingString:[NSString stringWithFormat:@"%.2f%@",averageFee,@" 元"]];
    }
}

- (void) setPointQuantity:(float)pointQuantity
{
    if (_pointQuantity != pointQuantity) {
        _pointQuantity =  pointQuantity;
        //_averageFeeLbl.text = [@"平均费用：" stringByAppendingString:[NSString stringWithFormat:@"%.2f%@",averageFee,@" 元"]];
    }
}


@end
