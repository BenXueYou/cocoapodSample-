//
//  QCSystemManager.m
//  cocoapodSample
//
//  Created by cnc on 16/8/17.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import "QCSystemManager.h"
#import "SVSegmentedControl.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "QCChiBaoZiHeader.h"
#import "QCChiBaoZiFooter.h"
#import "YYKit.h"
// DB
#import "QCDataCatchTool.h"
// http
#import "QCHttpTool.h"
#import "QCReminderUserTool.h"

#import "QCChargeRecordModel.h"
#import "QCSupplyRecordModel.h"
#import "QCFaultRecordModel.h"
#import "QCSearchRecordModel.h"

//cell
#import "QCFaultRecordCell.h"
#import "QCChargeRecordCell.h"
#import "QCSupplyRecordCell.h"

#import "QCTabBarController.h"
#import "AppDelegate.h"

//时间筛选

#import "QCChooseRecordCtrl.h"


//详情
#import "QCCheckSupplyCtrl.h"
#import "QCCheckChargeDetailCtrl.h"
#import "QCCheckFaultRecordDetail.h"

//搜索
#import "CustomSearchBar.h"
#import "FZHPopView.h"
@interface QCSystemManager ()<UITableViewDataSource,UITableViewDelegate,CustomSearchBarDelegate,QCChooseRecordCtrlDelegate>
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,weak) UITableView *chargeRecordView;
//@property (nonatomic,weak) UITableView *supplyRecordView;
@property (nonatomic,weak) UITableView *faultRecordView;
@property (nonatomic,weak) UISegmentedControl *segmentedView;
@property (nonatomic,strong) NSMutableArray *chargeRecordDataArray;
@property (nonatomic,strong) NSMutableArray *supplyRecordDataArray;
@property (nonatomic,strong) NSMutableArray *faultRecordDataArray;
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) int requestType;

@property (nonatomic,strong) NSMutableArray *titles;
@property (nonatomic,assign) int date;


@end

@implementation QCSystemManager
//当从首页进入该界面的时候发送通知
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setupSelfView];
    [self setupScrollView];
    [self setupSegAndTableView];
    [self setupBarItem];
    [self loadChargeRecordData];
    [self setupRefrshControl];
   
    _supplyRecordDataArray = [[NSMutableArray  alloc]init];
    _chargeRecordDataArray = [[NSMutableArray alloc]init];
    
    self.titles = [NSMutableArray arrayWithObjects:@"friend",@"article",@"number", nil];

    
}

- (void)setUpView{
    
    QCChiBaoZiHeader *header = [QCChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataWithUrlString:params:)];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 60) style:(UITableViewStylePlain)];
    self.tableView.mj_header = header;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"QCTableViewCell" bundle:nil] forCellReuseIdentifier:@"PLCell"];
    [self.view addSubview:_tableView];
    
}

#pragma - mark setupSubViews
- (void) setupSelfView
{
    self.view.backgroundColor = [UIColor cyanColor];
}
- (void) setupScrollView
{
    self.automaticallyAdjustsScrollViewInsets = NO;// 不去自动调整
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2,0);
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    self.scrollView.delegate = self;
}

#pragma mark ----------添加导航栏搜索按钮--------
- (void) setupBarItem
{
    UIBarButtonItem *uibtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(SearchClick)];
    
    self.navigationItem.rightBarButtonItem = uibtn;

}
-(void)SearchClick {

    QCChooseRecordCtrl *vc = [[QCChooseRecordCtrl alloc] init];
    
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = @"搜索";
    vc.delegate = self;
    vc.selectedIndex  = (int)self.segmentedView.selectedSegmentIndex;
    
    NSLog(@"index = %d",vc.selectedIndex);
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark=========刷新数据库=========
- (void) setupRefrshControl
{
    QCChiBaoZiHeader *chargeRecordheader = [QCChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadChargeRecordData)];
    self.chargeRecordView.mj_header = chargeRecordheader;
    
    self.chargeRecordView.mj_footer = [QCChiBaoZiFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadChargeRecordData)];
    
    self.chargeRecordView.tableHeaderView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    
    QCChiBaoZiHeader *supplyRecordheader = [QCChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadSupplyRecordData)];
    self.faultRecordView.mj_header = supplyRecordheader;
    self.faultRecordView.mj_footer = [QCChiBaoZiFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadSupplyRecordData)];
    self.faultRecordView.tableHeaderView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    
}

#pragma mark========充电记录========
- (void) loadChargeRecordData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cpCnt"] = @10;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",CPMAPI_PREFIX,CPMAPI_CHARGE_HISTORY];
    self.requestType = 0;
    
    NSLog(@"%@",urlString);
    
    [self loadNewDataWithUrlString:urlString params:params];
    
}
#pragma mark========用户记录=========
- (void) loadSupplyRecordData
{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
   
    params[@"cpCnt"] = @10;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",CPMAPI_PREFIX,CPMAPI_CHARGE_HISTORY];
    self.requestType = 1;
    [self loadNewDataWithUrlString:urlString params:params];
    
}

- (void) charge:(UISegmentedControl *)segmented
{
    if (segmented.selectedSegmentIndex == 0) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (segmented.selectedSegmentIndex == 1) {
        [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    } else {
        [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * 2, 0) animated:YES];
    }
    _scrollView.bouncesZoom = NO;
}

#pragma mark - UITableViewDateSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _chargeRecordView) {

        return _chargeRecordDataArray.count;
    
    }

//     return _faultRecordDataArray.count;

    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView == _chargeRecordView) {
        QCChargeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckChargeCell"];
;
        QCChargeRecordModel *model = self.chargeRecordDataArray[indexPath.row];
        cell.model  = model;
        return cell;
    } else  {
        QCFaultRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FRCell"];
 
        return cell;
    }
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

        return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == self.faultRecordView) {
        QCCheckFaultRecordDetail *CSVC = [[QCCheckFaultRecordDetail alloc] init];
        self.tabBarController.tabBar.hidden = YES;
        [self.navigationController pushViewController:CSVC animated:YES];
    }
    if (tableView == self.chargeRecordView) {
        
        QCCheckChargeDetailCtrl *CCDC = [[QCCheckChargeDetailCtrl alloc]init];
        self.tabBarController.tabBar.hidden = YES;
        CCDC.model = self.chargeRecordDataArray[indexPath.row];
        [self.navigationController pushViewController:CCDC animated:YES];

    }

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isMemberOfClass:[UIScrollView class]]) {
        if (scrollView.contentOffset.x < SCREEN_WIDTH / 2) {
            _segmentedView.selectedSegmentIndex = 0;
        }
        if ( scrollView.contentOffset.x >= SCREEN_WIDTH / 2
                   && scrollView.contentOffset.x < SCREEN_WIDTH) {
            _segmentedView.selectedSegmentIndex = 1;
        }
    } else {
    }
}
#pragma - mark mjRefresh Data
// 加载网络数据
- (void) loadNewDataWithUrlString:(NSString *)urlString params:(NSDictionary *)params
{
    
    [QCHttpTool httpQueryData:urlString params:params success:^(id json) {
        
        NSLog(@"+++++++++json=%@",json);
        
        NSString *errorCode = json[@"errorCode"];
        if ([errorCode isNotBlank]) {
            NSArray *userArr = json[@"detail"];
            
            NSLog(@"userArr ====%@",userArr);
            
            if ([userArr  isKindOfClass:[NSNull class]]) {
                return ;
            }
            
            for (NSDictionary *dict in userArr) {
                
                if (self.requestType == 0) {
                    QCChargeRecordModel *model = [QCChargeRecordModel mj_objectWithKeyValues:dict];
                    [self.chargeRecordDataArray addObject:model];
                }
                else {
                    QCFaultRecordModel *model = [QCFaultRecordModel mj_objectWithKeyValues:dict];
                    [self.faultRecordDataArray addObject:model];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.chargeRecordDataArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    QCChargeRecordModel *model1 = (QCChargeRecordModel *)obj1;
                    QCChargeRecordModel *model2 = (QCChargeRecordModel *)obj2;
                    return model1.cpid>model2.cpid?1:0;
                }];
                [self.faultRecordDataArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    QCChargeRecordModel *model1 = (QCChargeRecordModel *)obj1;
                    QCChargeRecordModel *model2 = (QCChargeRecordModel *)obj2;
                    return model1.cpid>model2.cpid?1:0;
                }];
                
                [self.chargeRecordView reloadData];
                [self.faultRecordView reloadData];
                
                [self.chargeRecordView.mj_header endRefreshing];
                [self.faultRecordView.mj_header endRefreshing];
                
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.chargeRecordView.mj_header endRefreshing];
                [self.faultRecordView.mj_header endRefreshing];
                [QCReminderUserTool showError:self.view str:@"服务器繁忙，稍后再试"];
            });
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.chargeRecordView.mj_header endRefreshing];
            [self.faultRecordView.mj_header endRefreshing];
            [QCReminderUserTool showError:self.view str:@"网络错误，请检查网络"];
        });
    }];
    
}

#pragma --------加载界面-------
- (void) setupSegAndTableView
{
    CGFloat segmentedHeight = 27;
    
    NSArray *array = @[@"账单记录",@"故障记录"];
    UISegmentedControl *segmentedView = [[UISegmentedControl alloc] initWithItems:array];
    segmentedView.selectedSegmentIndex = 0;
    segmentedView.tintColor = [UIColor colorWithHex:0x299dff];
    [segmentedView addTarget:self action:@selector(charge:) forControlEvents:UIControlEventValueChanged];
    segmentedView.frame = CGRectMake(74, 5, SCREEN_WIDTH - 74 * 2, segmentedHeight);
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    [self.view addSubview:segmentedView];
    self.segmentedView = segmentedView;
    
    //设置尺寸
    CGFloat tableViewY = segmentedHeight + 6;
    CGFloat tableViewH = self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height - tableViewY;
    CGRect chargeRecordViewFrame = CGRectMake(0, tableViewY, SCREEN_WIDTH, tableViewH);
    
    //    设置充电记录
    UITableView *chargeRecordView = [[UITableView alloc] initWithFrame:chargeRecordViewFrame style:UITableViewStyleGrouped];
    chargeRecordView.rowHeight = 90;
    UIView *chargeHeaderView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 6)];
    chargeRecordView.tableHeaderView = chargeHeaderView;
    chargeRecordView.tableFooterView = chargeHeaderView;
    [_scrollView addSubview:chargeRecordView];
    
    self.chargeRecordView = chargeRecordView;
    [self.chargeRecordView registerNib:[UINib nibWithNibName:@"QCChargeRecordCell" bundle:nil] forCellReuseIdentifier:@"CheckChargeCell"];
    self.chargeRecordView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.chargeRecordView.delegate = self;
    self.chargeRecordView.dataSource = self;
//    self.chargeRecordView.backgroundColor = [UIColor redColor];
    
    //    设置用户记录
    CGRect faultRecordViewFrame = CGRectMake(SCREEN_WIDTH, tableViewY, SCREEN_WIDTH, tableViewH);
    UITableView *faultRecordView = [[UITableView alloc] initWithFrame:faultRecordViewFrame style:UITableViewStyleGrouped];
    faultRecordView.rowHeight = 90;
    UIView *supplyHeaderView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 6)];
    faultRecordView.tableHeaderView = supplyHeaderView;
    faultRecordView.tableFooterView = supplyHeaderView;
    [_scrollView addSubview:faultRecordView];
    self.faultRecordView = faultRecordView;
    self.faultRecordView.delegate = self;
    self.faultRecordView.dataSource = self;
//    self.supplyRecordView.backgroundColor = [UIColor redColor];
    [self.faultRecordView registerNib:[UINib nibWithNibName:@"QCFaultRecordCell" bundle:nil] forCellReuseIdentifier:@"FRCell"];
    self.faultRecordView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


#pragma - mark QCChooseRecordDelegate
- (void)searchRecord:(QCSearchRecordModel *)searchModel
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *urlString = @"";
    if ([searchModel.searchType isEqualToString:@"充电记录"]){
        
         self.segmentedView.selectedSegmentIndex = 0;
        
        params[@"cpid"] = @([searchModel.searchWord intValue]);
        params[@"from"] = searchModel.beginTime;
        params[@"to"] = searchModel.endTime;
        
        urlString = [NSString stringWithFormat:@"%@%@",CPMAPI_PREFIX,CPMAPI_CHARGE_HISTORY];
        
    }
    else if ([searchModel.searchType isEqualToString:@"故障记录"]) {
        
        self.segmentedView.selectedSegmentIndex = 1;
        
        [self charge:self.segmentedView];
        
        params[@"cpuserid"] = searchModel.searchWord;
        params[@"from"] = searchModel.beginTime;
        params[@"to"] = searchModel.endTime;
        
        urlString = [NSString stringWithFormat:@"%@%@",CPMAPI_PREFIX,CPMAPI_FAULT_HISTORY];
        
    }
    else{
        self.segmentedView.selectedSegmentIndex = 0;
        [self charge:self.segmentedView];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        params[@"cpid"] = searchModel.searchWord;
        params[@"datacnt"] = @10;
        params[@"from"] = searchModel.beginTime;
        params[@"to"] = searchModel.endTime;
        
        urlString = [NSString stringWithFormat:@"%@%@",CPMAPI_PREFIX,CPMAPI_CHARGE_HISTORY];
    }
    [self loadNewDataWithUrlString:urlString params:params];
}





@end
