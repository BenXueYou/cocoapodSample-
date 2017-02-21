//
//  QCHomeChartCtrl.m
//  cocoapodSample
//
//  Created by cnc on 16/8/27.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import "QCHomeChartCtrl.h"

#import "ZFChart.h"
#import "JXBarChartView.h"
#import "QCCalendarDataSource.h"
#import "weekModel.h"
#import "QCListPileChargeDetail.h"

#import "DXPopover.h"

#import "QCHomeChartDateCell.h"
@interface QCHomeChartCtrl ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *dateView;
@property (nonatomic,strong) NSArray *dateSource;
@property (nonatomic,assign) BOOL isClink;


@property (nonatomic,strong) NSMutableArray *YValues;
@property (nonatomic,strong) NSMutableArray *XValues;

@property (nonatomic,strong) DXPopover *popover;

@property (nonatomic,assign)NSInteger index;

@property (nonatomic,strong) weekModel *model;
@end

@implementation QCHomeChartCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dateSource = [[QCCalendarDataSource alloc]init].dataSource;
    [self addBarButton];

    [self setNavigation];//设置返回按钮

    self.navigationItem.title = [NSString stringWithFormat:@"收入情况"];
    self.chartType = 0;
    
    NSMutableArray *XLineValues =  [NSMutableArray arrayWithObjects:@"280", @"255", @"308", @"273", @"236", @"267",@"292", nil];
//    NSMutableArray *XLineValues = nil;
    NSMutableArray *YLineValues = [NSMutableArray arrayWithObjects:@"一", @"二", @"三", @"四", @"五", @"六", @"日",nil];
    
    self.XValues = XLineValues;
    self.YValues = YLineValues;
    
    [self showBarChartWithXLineValues:XLineValues YLineValues:YLineValues];//画柱状图
    
    [self showTopBarChartWithXLineValues:XLineValues YLineValues:YLineValues];//画Top柱状图
    
    
}


#pragma mark ------画柱状图
- (void)showBarChartWithXLineValues:(NSMutableArray *)XLineValues YLineValues:(NSMutableArray *)YLineValues{
    ZFBarChart * barChart = [[ZFBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 3 )];
    barChart.xLineValueArray = XLineValues;
    barChart.xLineTitleArray = YLineValues;
    barChart.yLineMaxValue = 500;
    barChart.scrollEnabled = NO;
    barChart.yLineSectionCount = 10;
    [self.view addSubview:barChart];
    [barChart strokePath];

}

#pragma mark ------画Top柱状图
- (void)showTopBarChartWithXLineValues:(NSMutableArray *)XLineValues YLineValues:(NSMutableArray *)YLineValues{

    NSMutableArray *YButtonValues = [NSMutableArray arrayWithObjects:@"一号桩",@"二号桩", @"三号桩", @"四号桩", @"五号桩", @"六号桩", @"七号桩",@"八号桩",@"九号桩",@"十号桩",nil];
    NSMutableArray *XButtonValues =  [NSMutableArray arrayWithObjects:@"300", @"295", @"258", @"223", @"206", @"97",@"72",@"53",@"35",@"22", nil];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT / 3 + 10, SCREEN_WIDTH, 20)];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor redColor];
    titleLabel.text = @"收入排行";
    [self.view addSubview:titleLabel];
    
    JXBarChartView *TopBarChart = [[JXBarChartView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 3 * 2 - 30) startPoint:CGPointMake(20, 20) values:XButtonValues maxValue:500 textIndicators:YButtonValues textColor:[UIColor colorWithHex:0x299dff] barHeight:15 barMaxWidth:SCREEN_HEIGHT / 3 * 2 - 30 gradient:nil];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT / 3 + 30, SCREEN_WIDTH, SCREEN_HEIGHT / 3 * 2 - 30)];
    scrollView.scrollsToTop = YES;
    scrollView.contentSize = CGSizeMake(0, 320);
    
  
    [self.view addSubview:scrollView];
    
    [scrollView addSubview:TopBarChart];
    
    
    TopBarChart.block = ^(NSInteger index){
    
        NSLog(@"跳转到详情页");
        
        QCListPileChargeDetail *LPCD = [[QCListPileChargeDetail alloc] init];
        [self.navigationController pushViewController:LPCD animated:YES];
        
    };
}

#pragma mark ----------添加barButton-------
-(void)addBarButton{

    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list.png"] style:(UIBarButtonItemStylePlain) target:self action:@selector(Date)];
    self.navigationItem.rightBarButtonItem = barButton;
}

//筛选菜单
-(void)Date{
    
//    self.popover.backgroundColor = [UIColor orangeColor];
   
    CGPoint startPoint =  CGPointMake(SCREEN_WIDTH - 20, 0);
    
    [self.popover showAtPoint:startPoint
               popoverPostion:DXPopoverPositionDown
              withContentView:self.dateView
                       inView:self.view];

}
//菜单
-(UIView *)dateView{
    
    if (!_dateView) {
        _dateView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, 142, 219) style:(UITableViewStylePlain)];
    }
    
    _dateView.backgroundColor = [UIColor colorWithHex:0X3D414C];
    _dateView.bounces = NO;
    _dateView.showsHorizontalScrollIndicator = NO;
    _dateView.delegate = self;
    _dateView.dataSource = self;
    _dateView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_dateView registerNib:[UINib nibWithNibName:@"QCHomeChartDateCell" bundle:nil] forCellReuseIdentifier:@"QCDateCell"];
    
    return _dateView;
}

-(DXPopover *)popover{

    if (!_popover) {
        _popover = [DXPopover new];
//        _popoverWidth = 142.0;
    }
    return _popover;
}

#pragma mark ------UITableViewDataSource------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dateSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QCHomeChartDateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QCDateCell"];
    
    weekModel *model = self.dateSource[indexPath.row];
    cell.weekLabel.text = [NSString stringWithFormat:@"第%ld周%@-%@",model.weekCount,model.beginDate,model.endDate];
       return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      self.index = indexPath.row;
      self.navigationItem.title = [NSString stringWithFormat:@"收入情况"];
    
          self.chartType = (int)indexPath.row;
        [(NSMutableArray *)self.view.subviews  removeAllObjects];
        [self loadView];
        [self showBarChartWithXLineValues:self.XValues YLineValues:self.YValues];
        
        NSMutableArray *XLineValues =  [NSMutableArray arrayWithObjects:@"280", @"255", @"308", @"273", @"236", @"267",@"292", nil];
        //    NSMutableArray *XLineValues = nil;
        NSMutableArray *YLineValues = [NSMutableArray arrayWithObjects:@"一", @"二", @"三", @"四", @"五", @"六", @"日",nil];

        [self showTopBarChartWithXLineValues:XLineValues YLineValues:YLineValues];//画Top柱状图
        
    
}

#pragma mark -----设置返回按钮
-(void)setNavigation{
    self.navigationController.navigationBar.translucent = NO;
     UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_arrow"] style:(UIBarButtonItemStyleDone) target:self action: @selector(back)];    
    self.navigationItem.leftBarButtonItem = button;
}

-(void)back{
    
    //    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;

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
