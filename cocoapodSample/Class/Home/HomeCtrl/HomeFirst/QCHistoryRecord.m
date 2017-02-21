//
//  QCHistoryRecord.m
//  cocoapodSample
//
//  Created by cnc on 16/8/17.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import "QCHistoryRecord.h"

#import "QCHomePileCell.h"
//网络
#import "QCHttpTool.h"
//弹窗
#import "QCReminderUserTool.h"
//全局
#import "GlobalClass.h"

//详情
#import "QCHomeChartCtrl.h"

//区域
#import "SXButton.h"
#import "UIView+TF.h"
#import "QCLocationCtrl.h"
//定位
#import <CoreLocation/CoreLocation.h>

//个人资料
#import "QCSysManageCtrl.h"
//列表页
#import "QCPileListCtrl.h"
#import "QCTabBarController.h"
#import "XYNaviGationController.h"
#import "AppDelegate.h"

#import "QCSystemManager.h"
#import "QCHomeHeadView.h"

//动画刷新
#import "MJRefresh.h"
#import "QCChiBaoZiHeader.h"
#import "QCChiBaoZiFooter.h"
#define headerFrame self.header.headerImage.frame
@interface QCHistoryRecord ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) QCHomeHeadView *header;


@property (nonatomic,strong) UIButton *detailBtn;

@property (nonatomic,strong) QCPileListCtrl* plistVC;
@property (nonatomic,strong) QCSystemManager *checkVC;

@property (nonatomic,strong) CLLocationManager *manager;

@property (nonatomic,strong)  SXButton *SXButton;
@end

@implementation QCHistoryRecord


//初始化定位代理对象
-(CLLocationManager *)manager{

    if (!_manager) {
        _manager = [[CLLocationManager alloc]init];
        _manager.delegate = self;//设置代理
        _manager.desiredAccuracy = kCLLocationAccuracyBest;//设置定位精度
    }
    
    return _manager;
}


-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    //一进入界面加载就开始定位
    
    [self.manager requestAlwaysAuthorization];
    [self.manager startUpdatingLocation];
    
    
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    //设置界面
    [self setUpView];
    //进入界面检查更新头像
    if ([GlobalClass sharedInStance].Image) {
        self.header.headImg.image = [GlobalClass sharedInStance].Image;
    }
    if ([GlobalClass sharedInStance].name) {
        self.header.name.text = [NSString stringWithFormat:@"%@",[GlobalClass sharedInStance].name];
    }
    
    //手势
    [self addGestureRecognizer];
    //切换城市
    [self addLocationBarButton];
    
    
    
}

#pragma mark - 定位代理方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    //1.获取用户信息
    CLLocation *location = locations.lastObject;
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    NSLog(@"纬度：%f 经度：%f",coordinate.latitude,coordinate.longitude);
    
    
    // 2.停止定位
    [manager stopUpdatingLocation];

}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //将经度显示到label上
    NSString *longitude = [NSString stringWithFormat:@"%lf", newLocation.coordinate.longitude];
    //将纬度现实到label上
    NSString *latitude = [NSString stringWithFormat:@"%lf", newLocation.coordinate.latitude];
    
    NSLog(@"纬度：%@ 经度：%@",longitude,latitude);
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            //将获得的所有信息显示到label上
            NSString *locationText = placemark.name;
            
            NSLog(@"获取的所有信息:%@",locationText);
            
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSLog(@"city = %@", city);
            
            [[GlobalClass sharedInStance] setAreaTitle:city];//存入全局变量
            
            [_SXButton setTitle:city forState:UIControlStateNormal];//更改界面按钮标题
        }
        else if (error == nil && [array count] == 0)
        {
            NSLog(@"No results were returned.");
        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}





- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
        NSLog(@"开启定位失败：%@",error);
    }
    
    NSLog(@"gggggggg定位失败：%@",error);
}


#pragma mark - 区域
-(void)addLocationBarButton{

    
    self.SXButton = [SXButton buttonWithType:(UIButtonTypeCustom)];
    
    self.SXButton.frame = CGRectMake(0, 0, 80, 20);
   
    [self.SXButton addTarget:self action:@selector(screenAction) forControlEvents:UIControlEventTouchUpInside];
    [self.SXButton setTitle:@"北京市" forState:UIControlStateNormal];
    [self.SXButton setImage:[UIImage imageNamed:@"zhankai"] forState:UIControlStateNormal];
    UIBarButtonItem *LeftBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.SXButton];
    self.navigationItem.leftBarButtonItem = LeftBarButton;
}

- (void)screenAction{
    
    QCLocationCtrl *LCVC = [[QCLocationCtrl alloc] init];
    
    UINavigationController *naV = [[UINavigationController alloc]initWithRootViewController:LCVC];
    [LCVC setSucceed:^(NSString *str) {
        
        if (str.length > 3) {
            
            self.SXButton.width = 110;
            self.SXButton.titleLabel.width = 80;
            
        }else{
            
            if (str.length == 3) {
                
                self.SXButton.width = 80;
                self.SXButton.titleLabel.width = 55;
                
            }else{
                
                self.SXButton.width = 40;
                self.SXButton.titleLabel.width = 40;
                
            }
        }
        
        [self.SXButton setTitle:str forState:UIControlStateNormal];
    }];
    
    [self presentViewController:naV animated:YES completion:^{
        
    }];
}


#pragma mark ------跳入详情--------
-(void)pushBtnAction{
    
    NSLog(@"具体明细");
    QCHomeChartCtrl *homeCC = [[QCHomeChartCtrl alloc] init];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:homeCC animated:YES];
    
}

#pragma mark -------添加手势--------
//添加手势进入个人资料管理页
-(void)addGestureRecognizer{

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(StepToPersonCtrl)];
    self.header.userInteractionEnabled = YES;
    self.header.headImg.userInteractionEnabled = YES;
    [self.header.headImg addGestureRecognizer:tap];
}
-(void)StepToPersonCtrl{

    QCSysManageCtrl *personCtrl = [[QCSysManageCtrl alloc] init];
    [self.navigationController pushViewController:personCtrl animated:YES];
}

#pragma mark ------设置头视图--------

-(void)setUpView{
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    // bg.png为自己ps出来的想要的背景颜色。
    UIImage *image = [UIImage imageNamed:@"sys_nav_bg"];
    
    [navigationBar setBackgroundImage:image
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];


    self.header = [[NSBundle mainBundle] loadNibNamed:@"QCHomeHeadView" owner:self options:nil].firstObject;
    self.header.frame = CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT / 2);

    
    [self loadHeadViewData];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 70) style:(UITableViewStylePlain)];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = YES;
    
    
    
    QCChiBaoZiHeader *CBZHeader = [QCChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestTotalData)];
    self.tableView.mj_header = CBZHeader;
    
//    添加控件
    self.detailBtn = self.header.pushBtn;
    [self.detailBtn addTarget:self action:@selector(pushBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    
//    设置代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.header;
    [self.view addSubview:_tableView];
//    注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"QCHomePileCell" bundle:nil] forCellReuseIdentifier:@"HPCell"];
}

#pragma mark ------UItableViewDelegate-------
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QCHomePileCell *cell = [tableView cellForRowAtIndexPath:indexPath];
     [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QCHomePileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HPCell"];
    
    [cell.PileNumImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(StepToPileList1)]];
    [cell.PileFaultImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(StepToPileList2)]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return self.view.frame.size.height / 2 - 80;
}

#pragma mark ------跳转到列表页--------
-(void)StepToPileList1{
    QCPileListCtrl *QCPLCtrl = [[QCPileListCtrl alloc]init];
    self.tabBarController.tabBar.hidden = YES;
     QCPLCtrl.commstate = 6;
    QCPLCtrl.isfromHome = YES;
    [self.navigationController pushViewController:QCPLCtrl animated:YES];
    
}

-(void)StepToPileList2{
    
    QCPileListCtrl *QCPLCtrl = [[QCPileListCtrl alloc]init];
    self.tabBarController.tabBar.hidden = YES;
    QCPLCtrl.commstate = 0;
    QCPLCtrl.fromHome = YES;
    [self.navigationController pushViewController:QCPLCtrl animated:YES];
}



#pragma mark ------加载数据-------

-(void)requestTotalData{

    NSLog(@"下拉刷新");
    
    for (UIView *tempView in self.view.subviews) {
        [tempView removeFromSuperview];
    }
    [self viewDidLoad];
}

//headView的数据刷新
-(void)loadHeadViewData{

    float step1 = 0;
    float step2 = 0;
    
    step1 += arc4random() % 50 + (arc4random() % 10) / 10.0;
    step2 += arc4random() % 100 + (arc4random() % 10) / 10.0;
    
    
    NSLog(@"step1 === %f ++++++++ step2 === %f",step1,step2);
    
    self.header.TMLabel.text = [NSString stringWithFormat:@"%d,%.2f",59, (146 + step1)];
    self.header.TQLabel.text = [NSString stringWithFormat:@"%.2f",(62 + step2)];
    self.header.totalML.text = [NSString stringWithFormat:@"%.2f",(34.286 + step1)];
    self.header.totalQL.text = [NSString stringWithFormat:@"%.2f",(621.254 + step2)];

    NSLog(@"%@",self.header.TMLabel.text);
    NSLog(@"%@",self.header.TQLabel.text);
    NSLog(@"%@",self.header.totalML.text);
    NSLog(@"%@",self.header.totalQL.text);
}

@end
