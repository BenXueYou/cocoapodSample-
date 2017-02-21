//
//  QCPileListCtrl.m
//  cocoapodSample
//
//  Created by cnc on 16/8/17.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import "QCPileListCtrl.h"

//tool
#import "QCDataCatchTool.h"
#import "QCChiBaoZiHeader.h"
#import "QCReminderUserTool.h"
#import "QCHttpTool.h"
#import "MJExtension.h"


#import "QCHistoryRecord.h"
#import "QCTabBarController.h"
#import "AppDelegate.h"

//弹窗
#import "DXPopover.h"


//cell
#import "QCTableViewCell.h"
#import "QCPileTableCell.h"
#import "QCPileChargingCell.h"
#import "QCTableViewCell.h"
#import "QCPileMainTainCell.h"
#import "QCHomePileListStateCell.h"

//详情页
#import "QCListPileChargeDetail.h"
#import "QCListPileFaultDetail.h"
#import "QCListPileChargingDetail.h"
#import "QCListPileMaintainDetail.h"

//model
#import "QCPileListModel.h"
#import "QCPileListLeisureModel.h"
#import "QCPileListChargingModel.h"
#import "QCPileListMainTainModel.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define dbName  @"QCPileList.sqlite"
#define sql  @"CREATE TABLE IF NOT EXISTS t_PileList (id integer PRIMARY KEY AUTOINCREMENT,cpid text,alarmtime text,totalfee text,totalquantity text,todayfee text,todayquantity text,lastfee text,lastquantity text,province text,city text,area text,faulttype text,faultReason text,rmname text,rmphone text,address text,pileState text,todatquantity text)"
#define sqlCheck @"select * from t_PileList where pileState = ?"

@interface QCPileListCtrl ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate>


@property (nonatomic,strong) UITableView *tableView;


//请求网络参数
@property(nonatomic,strong)NSMutableDictionary *pragrams;
@property(nonatomic,assign)int index;

//菜单状态数组
@property (nonatomic,strong) NSArray *stateArray;
@property (nonatomic,strong) NSArray *iconArray;
@property (nonatomic,strong) UITableView *menuTableView;

//搜索
@property (nonatomic,strong) UITextField *searchBarText;
@property (nonatomic,strong) UITableView *searchBarTableView;
@property (nonatomic,strong) UIView * searchBg;
@property (nonatomic,strong) UIView *coverView;//蒙版
@property (nonatomic,assign) BOOL isClink;//标记是否选中

@property (nonatomic,strong) NSMutableArray *resultDataSource;
//弹窗
@property (nonatomic,strong) DXPopover *popover;

//数据源数组
@property (nonatomic,strong) NSMutableArray *FaultModelArray;
@property (nonatomic,strong) NSMutableArray *ChargingModelArray;
@property (nonatomic,strong) NSMutableArray *ChargeModelArray;
@property (nonatomic,strong) NSMutableArray *MainTainModelArray;
@property (nonatomic,strong) NSMutableArray *AllModeArray;

@property (nonatomic,strong) QCPileListModel *faultModel;
//搜索框的内容
@property (nonatomic,strong) NSMutableString *textStr;

//定时器
@property (nonatomic,weak) NSTimer *myTimer;


@property (nonatomic,strong) UIView *nullMask;
@end

@implementation QCPileListCtrl

#pragma mark --------init UI -----
//懒加载筛选界面数据源
-(NSArray *)stateArray{

    if (!_stateArray) {
        _stateArray = @[@"全部",@"空闲",@"故障",@"充电"];
    }
    return _stateArray;
}

//初始化列表按钮
-(UIBarButtonItem *)leftBarButton{

    if (!_leftBarButton) {
        _leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list_state.png"] style:(UIBarButtonItemStyleDone) target:self action:@selector(stateMenu)];
    }
    return _leftBarButton;
}
//初始化搜索按钮
- (UIBarButtonItem *)searchBar{

    if (!_searchBar) {
        _searchBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemSearch) target:self action:@selector(clinkSearchBar)];
    }
    return _searchBar;
}
//初始化筛选菜单界面
-(UITableView *)menuTableView{

    if (!_menuTableView) {
        _menuTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 118, 174) style:UITableViewStylePlain];
        _menuTableView.dataSource = self;
        _menuTableView.delegate = self;
        _menuTableView.backgroundColor = [UIColor colorWithHex:0X3D414C];
    }
    return _menuTableView;
}

#pragma mark ------Load View -------

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
//判断从首页跳进来的路径
    if (self.fromHome) {
        self.commstate = 0;
    }
    if (self.isfromHome) {
        self.commstate = 6;
    }
//    定时器定时查询
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
    
//    加入主循环池中
    [[NSRunLoop mainRunLoop]addTimer:_myTimer forMode:NSDefaultRunLoopMode];
    [_myTimer fire];
    

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//   去除标识
    self.isfromHome = NO;
    self.fromHome = NO;
    self.tabBarController.tabBar.hidden = NO;
    
    [_myTimer invalidate];
    _myTimer = nil;
    
}

-(void)dealloc{

    [_myTimer invalidate];
    _myTimer = nil;
}
-(void)viewDidLoad{

    self.navigationController.navigationBar.translucent = NO;
    
//    添加菜单栏
    [self setUpView];
    [self setNavigation];
    self.textStr = [NSMutableString string];
    self.pragrams = [@{} mutableCopy];
    
    self.navigationItem.rightBarButtonItems = @[self.leftBarButton,self.searchBar];
 
    NSLog(@"%ld",self.commstate);
    
    [self getDataSourceFromDB];

//    注册
/* 故障*/
    [self.tableView registerNib:[UINib nibWithNibName:@"QCTableViewCell" bundle:nil] forCellReuseIdentifier:@"TableCell"];
/* 空闲*/
    [self.tableView registerNib:[UINib nibWithNibName:@"QCPileTableCell" bundle:nil] forCellReuseIdentifier:@"PTCell"];
/* 充电*/
    [self.tableView registerNib:[UINib nibWithNibName:@"QCPileChargingCell" bundle:nil] forCellReuseIdentifier:@"PCCell"];
/* 维护*/
    [self.tableView registerNib:[UINib nibWithNibName:@"QCPileMainTainCell" bundle:nil] forCellReuseIdentifier:@"PMCell"];
/* 状态菜单*/
    [self.menuTableView registerNib:[UINib nibWithNibName:@"QCHomePileListStateCell" bundle:nil] forCellReuseIdentifier:@"HPLSCell"];
    
    
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView == self.searchBarTableView){
        [self.searchBarText resignFirstResponder];
        
        NSLog(@"滑动");
    }


}

-(void)clearDataSource{
    
    [self.ChargeModelArray removeAllObjects];
    [self.ChargingModelArray removeAllObjects];
    [self.AllModeArray removeAllObjects];
    [self.MainTainModelArray removeAllObjects];
}

//从数据库中取出数据
-(void)getDataSourceFromDB{

    [self clearDataSource];
    
    
    QCDataCatchTool *catch = [[QCDataCatchTool alloc]initWithDBName:dbName sqlCmd:sql];
    
    if (self.commstate == 6) {
        
        self.AllModeArray = [[catch getAllChargePileData:dbName] mutableCopy];
    }
    else{
        self.AllModeArray = [[catch getChargePileData:dbName withPileState:[NSString stringWithFormat:@"%ld",(long)self.commstate]] mutableCopy];
    }

    [self.tableView reloadData];
}


#pragma mark -------UItableViewDataSource------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.menuTableView) {
        return self.stateArray.count;
    }
    if (self.AllModeArray.count == 0) {
        
        [self showMsgWithNullDataSource];
    }else{
        [self.nullMask removeFromSuperview];
    }

    return self.AllModeArray.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.menuTableView == tableView) {
        QCHomePileListStateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HPLSCell"];
        cell.stateLabel.text = [NSString stringWithFormat:@"%@",self.stateArray[indexPath.row]];
        cell.icon.image = self.iconArray[indexPath.row];
        
        tableView.separatorStyle = NO;
        return cell;
    }
    
    
    if (self.AllModeArray.count == 0) {
        
        return [[UITableViewCell alloc] init];
    }
    else{
        
        [self.nullMask removeFromSuperview];
        
    if (self.commstate == 0) {
        
        QCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"];
        self.navigationItem.title = @"故障桩列表";
        cell.FaultModel = self.AllModeArray[indexPath.row];
        
        return cell;
    }
    else if (self.commstate == 1) {
        
        QCPileTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PTCell"];
        self.navigationItem.title = @"空闲桩列表";
        cell.model = self.AllModeArray[indexPath.row];
        return cell;
    }
    else if (self.commstate == 2) {
        QCPileChargingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PCCell"];
        self.navigationItem.title = @"充电桩列表";
        cell.model = self.AllModeArray[indexPath.row];
        return cell;
    }
    else if (self.commstate == 3) {
        QCPileMainTainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PMCell"];
        self.navigationItem.title = @"维护桩列表";
        
        cell.model = self.AllModeArray[indexPath.row];
        return cell;
    }

    else{
        self.navigationItem.title = @"全部桩列表";

        QCPileListModel *model = self.AllModeArray[indexPath.row];
        
        if ([model.pileState isEqualToString:@"0"]) {//故障桩
            QCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"];
            cell.FaultModel = (QCPileListModel *)model;
            return cell;
        }
        else if ([model.pileState isEqualToString:@"2"]) {//充电桩
            QCPileChargingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PCCell"];
            cell.model = (QCPileListModel *)model;
            return cell;
        }
        //空桩闲
        else if ([model.pileState isEqualToString:@"1"]) {
            QCPileTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PTCell"];
            cell.model = (QCPileListModel *)model;
            return cell;
        }
        else{
        //维护桩
        QCPileMainTainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PMCell"];
        cell.model = (QCPileListModel *)model;
       
            return cell;
        }
    }
  }
}

-(void)showMsgWithNullDataSource{

     [self.tableView addSubview:self.nullMask];
}

#pragma mark --------UItableViewDelegate--------
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    点击菜单选项
    if (tableView == self.menuTableView) {
        [self requestDataWithClinkIndexPath:(int)indexPath.row];
        [self.popover dismiss];
    }
//    点击列表cell
    else{
        self.tabBarController.tabBar.hidden = YES;
        
        
        if (self.AllModeArray.count==0) {
            [self getDataSourceFromDB];
        }
        
        
        QCPileListModel *model = self.AllModeArray[indexPath.row];
        if (self.commstate == 0 || [model.pileState isEqualToString:@"0"]) {
        
            QCListPileFaultDetail *faultDetail = [[QCListPileFaultDetail alloc]init];

            self.tabBarController.hidesBottomBarWhenPushed = YES;
            faultDetail.model = model;
            [self.navigationController pushViewController:faultDetail animated:YES];
        }
    
        else if (self.commstate == 1 || [model.pileState isEqualToString:@"1"]) {
        
            QCListPileChargeDetail *LPCDetail = [[QCListPileChargeDetail alloc] init];
            self.tabBarController.hidesBottomBarWhenPushed = YES;
            LPCDetail.model = model;
            [self.navigationController pushViewController:LPCDetail animated:YES];
        
        }
        else if(self.commstate == 2 || [model.pileState isEqualToString:@"2"]) {
            QCListPileChargingDetail *chargingDetail = [[QCListPileChargingDetail alloc]init];
            
            chargingDetail.model = model;
            
            [self.navigationController pushViewController:chargingDetail animated:YES];
        
        }
        else {
            
            QCListPileMaintainDetail *maintainDetail = [[QCListPileMaintainDetail alloc]init];
            
            maintainDetail.model = model;
            
            [self.navigationController pushViewController:maintainDetail animated:YES];
            
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.menuTableView) {
        return 44;
    }
    if(self.commstate == 1 || self.commstate == 0 || self.commstate == 2){return 120;}
           return 120;
}
#pragma mark ---------返回区头------------
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *cellHeader = [[UIView alloc] init];
    return cellHeader;
}

#pragma mark ------------状态选择------------
-(DXPopover *)popover{
    
    if (!_popover) {
        _popover = [DXPopover new];
    }
    return _popover;
}

-(void)stateMenu{
    
    CGPoint startPoint =  CGPointMake(SCREEN_WIDTH - 20, 0);
    
    [self.popover showAtPoint:startPoint
               popoverPostion:DXPopoverPositionDown
              withContentView:self.menuTableView
                       inView:self.view];

}

#pragma mark ----设置界面--------
- (void)setUpView{

    QCChiBaoZiHeader *header = [QCChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDatawithState:)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight - 44) style:(UITableViewStylePlain)];
    self.tableView.mj_header = header;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"QCTableViewCell" bundle:nil] forCellReuseIdentifier:@"PLCell"];
    
// 添加菜单
    self.iconArray = @[[UIImage imageNamed:@"all.png"],[UIImage imageNamed:@"free.png"],[UIImage imageNamed:@"guz.png"],[UIImage imageNamed:@"char.png"],[UIImage imageNamed:@"set.png"]];
    
    self.tableView.tableFooterView = [[UIView alloc] init];//当数据源为空的时候可以去掉分割线
    
    [self.view addSubview:_tableView];
    
   
}

#pragma mark ---- 网络加载 --------
-(void)loadNewDatawithState:(NSInteger)commstate{

    
    
    QCDataCatchTool *catch = [[QCDataCatchTool alloc] initWithDBName:dbName sqlCmd:sql];
    self.FaultModelArray = [[catch getChargePileData:dbName withPileState:@"0"] mutableCopy];
    NSLog(@"%ld",self.commstate);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cpCnt"] = @10;
    params[@"commstate"] = [NSNumber numberWithInteger:self.commstate];
    
    NSLog(@"%ld",self.commstate);
    NSLog(@"%@",params[@"commstate"]);

    
    [QCHttpTool httpQueryCPNumber:params success:^(id json) {
        
        NSLog(@"刷新列表：json ==== %@",json);
        NSArray *detailArray = json[@"detail"];
        
        
        if ([json[@"errorCode"] isEqualToString:@"E0002"]) {//网络处理异常
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                //[QCReminderUserTool showError:self.view str:@"服务器繁忙，稍后再试"];
            });
            return ;
        }
    
        switch (self.commstate) {
            case 6:
                [self analysisAllPileWithArray:detailArray];
                break;
            default:
                self.AllModeArray = [self analysisModelWithArray:detailArray pileState:[NSString stringWithFormat:@"%ld",self.commstate]];
                break;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        });
        
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [QCReminderUserTool showError:self.view str:@"网络错误，请检查网络"];
        });
    }];

}

#pragma mark -------解析数据--------
-(NSMutableArray *)analysisModelWithArray:(NSArray *)array pileState:(NSString *)pileState{
    
    QCDataCatchTool *catch = [[QCDataCatchTool alloc] initWithDBName:dbName sqlCmd:sql];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        NSMutableDictionary *dict = [dic mutableCopy];
        [dict setObject:pileState forKey:@"pileState"];
        QCPileListModel *model = [[QCPileListModel alloc]init];
        [arr addObject:[model mj_setKeyValues:dict]];
    }
//    插入多条数据 去重操作
    [catch addChargePileDatas:dbName sqlCmd:sql array:arr];
    
    NSMutableArray *ar = [[catch getChargePileData:dbName withPileState:pileState] mutableCopy];
    
    return ar;
}

-(void)analysisAllPileWithArray:(NSArray *)array{

    [self clearDataSource];
    
    NSMutableArray *errorList = [NSMutableArray array];
    NSMutableArray *fixList = [NSMutableArray array];
    NSMutableArray *lastList = [NSMutableArray array];
    NSMutableArray *todayList = [NSMutableArray array];
   
   QCDataCatchTool *catch = [[QCDataCatchTool alloc]initWithDBName:dbName sqlCmd:sql];

    for (NSDictionary *dic in array) {
        errorList = dic[@"errorList"];
        fixList = dic[@"fixList"];
        lastList = dic[@"lastList"];
        todayList = dic[@"todayList"];
    }
    
    
//    给每一个model添加一个标识，为了便宜在显示列表状态的全部桩
    for (NSDictionary *dic in errorList) {
        NSMutableDictionary *dict = [dic mutableCopy];
        [dict setValue:@"0" forKey:@"pileState"];
        
        QCPileListModel *model = [[QCPileListModel alloc] init];
        
        [self.AllModeArray addObject:[model mj_setKeyValues:dict]];
        
        }

    for (NSDictionary *dic in fixList) {
        NSMutableDictionary *dict = [dic mutableCopy];
        [dict setValue:@"3" forKey:@"pileState"];
        QCPileListModel *model = [[QCPileListModel alloc] init];
        
        [self.AllModeArray addObject:[model mj_setKeyValues:dict]];
    }
   
    for (NSDictionary *dic in lastList) {
        NSMutableDictionary *dict = [dic mutableCopy];
        [dict setValue:@"2" forKey:@"pileState"];
        QCPileListModel *model = [[QCPileListModel alloc] init];
        
        [self.AllModeArray addObject:[model mj_setKeyValues:dict]];
        
    }
    
    for (NSDictionary *dic in todayList) {
        NSMutableDictionary *dict = [dic mutableCopy];
        [dict setValue:@"1" forKey:@"pileState"];
        QCPileListModel *model = [[QCPileListModel alloc] init];
        
        [self.AllModeArray addObject:[model mj_setKeyValues:dict]];
    }
    
//    插入数据库
    [catch addChargePileDatas:dbName sqlCmd:sql array:self.AllModeArray];
    
//    排序
    [self.AllModeArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        QCPileListModel *model1 = (QCPileListModel *)obj1;
        QCPileListModel *model2 = (QCPileListModel *)obj2;
        return model1.cpid > model2.cpid ? 1 : 0;
    }];

}

#pragma mark -----点击状态菜单，转换状态标识------
-(void)requestDataWithClinkIndexPath:(int)index{
    
    switch (index) {
        case 0:
            NSLog(@"请求全部的桩列表");
            self.commstate = 6;
            self.navigationItem.title = @"全部桩列表";
            break;
        case 1:
            NSLog(@"请求空闲的桩列表");
            self.commstate = 1;
            self.navigationItem.title = @"空闲桩列表";
            break;
        case 2:
            NSLog(@"请求故障的桩列表");
            self.commstate = 0;
            self.navigationItem.title = @"故障桩列表";
            
            break;
        case 3:
            NSLog(@"请求充电的桩列表");
            self.commstate = 2;
            self.navigationItem.title = @"充电桩列表";
            break;
        case 5:
            NSLog(@"请求预约的桩列表");
            self.commstate = 4;
            self.navigationItem.title = @"预约桩列表";
            break;
        case 4:
            NSLog(@"请求维护的桩列表");
            self.commstate = 3;
            self.navigationItem.title = @"维护桩列表";
            break;
        default:
            NSLog(@"请求停车状态的桩列表");
            self.commstate = 5;
            self.navigationItem.title = @"停车桩列表";
            break;
    }
    
//   从数据库中取出数据源
    [self getDataSourceFromDB];
}

#pragma mark -----Search Coding -------
-(void)clinkSearchBar{
    
//    清除view内的所有子控件
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
//    添加蒙版
    [self.view addSubview:self.coverView];
    [self.view addSubview:self.searchBarTableView];
    
    self.searchBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.searchBg.backgroundColor = [UIColor colorWithHex:0x299dff];
    [self.navigationController.view addSubview:_searchBg];

//    添加搜索框
    [self.searchBg addSubview:self.searchBarText];
    
//    添加导航栏左侧的按钮
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    [leftBtn setImage:[UIImage imageNamed:@"Search_noraml"] forState:UIControlStateNormal];
    self.searchBarText.leftView = leftBtn;
    [self.searchBarText.leftView setFrame:CGRectMake(0, 0, 25, 20)];
    self.searchBarText.leftViewMode = UITextFieldViewModeAlways;
   
//    添加搜索框右侧的取消按钮
    UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat cancleBtnW = 40;
    CGFloat cancleBtnH = 18;
    CGFloat cancleBtnX = SCREEN_WIDTH - 10 - cancleBtnW;
    CGFloat cancleBtnY = (44 * 0.5 - 9) + 20;
    cancleBtn.frame = CGRectMake(cancleBtnX, cancleBtnY, cancleBtnW, cancleBtnH);
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:XYCOLOR(132, 134, 137,1.0) forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchBg addSubview:cancleBtn];

}

//蒙版使用
-(UIView *)coverView{
    
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _coverView.backgroundColor = XYCOLOR(246, 246, 246, 0.5);
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapClick)];
        singleTap.cancelsTouchesInView = NO;
        [_coverView addGestureRecognizer:singleTap];
    }
    return _coverView;
}


- (UITableView *)searchBarTableView{
    if (!_searchBarTableView) {
        _searchBarTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120 * self.resultDataSource.count) style:UITableViewStylePlain];
        _searchBarTableView.tableFooterView = [[UIView alloc] init];
//        _searchBarTableView.backgroundColor = XYCOLOR(246, 246, 246, 0.5);
       // _searchBarTableView.backgroundColor = [UIColor redColor];
      
        _searchBarTableView.delegate =self;
        _searchBarTableView.dataSource = self;
        _searchBarTableView.delegate = self;
        _searchBarTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registSearchBarTableviewCell];

    }
    _searchBarTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    return _searchBarTableView;
}

//注册
-(void)registSearchBarTableviewCell{

    /* 故障*/
    [self.searchBarTableView registerNib:[UINib nibWithNibName:@"QCTableViewCell" bundle:nil] forCellReuseIdentifier:@"TableCell"];
    /* 空闲*/
    [self.searchBarTableView registerNib:[UINib nibWithNibName:@"QCPileTableCell" bundle:nil] forCellReuseIdentifier:@"PTCell"];
    /* 充电*/
    [self.searchBarTableView registerNib:[UINib nibWithNibName:@"QCPileChargingCell" bundle:nil] forCellReuseIdentifier:@"PCCell"];
    /* 维护*/
    [self.searchBarTableView registerNib:[UINib nibWithNibName:@"QCPileMainTainCell" bundle:nil] forCellReuseIdentifier:@"PMCell"];
    /* 状态菜单*/
    [self.searchBarTableView registerNib:[UINib nibWithNibName:@"QCHomePileListStateCell" bundle:nil] forCellReuseIdentifier:@"HPLSCell"];

}
//初始化搜索框

/*typedef enum {
 UIReturnKeyDefault,
 UIReturnKeyGo,
 UIReturnKeyGoogle,
 UIReturnKeyJoin,
 UIReturnKeyNext,
 UIReturnKeyRoute,
 UIReturnKeySearch,
 UIReturnKeySend,
 UIReturnKeyYahoo,
 UIReturnKeyDone,
 UIReturnKeyEmergencyCall,
 } UIReturnKeyType;
 
 */
-(UITextField *)searchBarText{
    
    if (!_searchBarText) {
        _searchBarText = [[UITextField alloc] initWithFrame:CGRectMake(7, 27, SCREEN_WIDTH * 0.8 , 31)];
        _searchBarText.borderStyle = UITextBorderStyleRoundedRect;
        _searchBarText.delegate = self;
        _searchBarText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_searchBarText becomeFirstResponder];
        _searchBarText.returnKeyType = UIReturnKeySearch;
        [_searchBarText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _searchBarText;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSLog(@"输入的值******************%@",string);
    [self.textStr appendFormat:@"%@",string];
    NSLog(@"拼接后^^^^^^^^^^^^^^^^%@",self.textStr);
    if ([string isEqualToString:@"\n"]){
    
        NSLog(@"回车搜索");
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM t_PileList WHERE cpid LIKE %@",self.textStr];
        QCDataCatchTool *catchTool = [[QCDataCatchTool alloc] initWithDBName:dbName sqlCmd:sql];

        self.resultDataSource = [[catchTool getChargePileData:dbName withSqlite:sqlStr] mutableCopy];
        self.AllModeArray = self.resultDataSource;

        [self.searchBarTableView reloadData];
    }
    return YES;
}
//监听搜索框内容,处理搜索逻辑
- (void)textFieldDidChange:(UITextField *)textField
{
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    self.textStr = [textField.text mutableCopy];
    
    if (self.textStr.length == 0 || [self.textStr  isEqual: @""]) {
        
        
        [QCReminderUserTool showError:self.view str:@"你还未输入~~~"];
    }
    
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM t_PileList WHERE cpid LIKE %@",self.textStr];
    QCDataCatchTool *catchTool = [[QCDataCatchTool alloc] initWithDBName:dbName sqlCmd:sql];
    
    self.resultDataSource = [[catchTool getChargePileData:dbName withSqlite:sqlStr] mutableCopy];
    self.AllModeArray = self.resultDataSource;
    [self.searchBarTableView reloadData];
    [textField resignFirstResponder];
    NSLog(@"呵呵呵");
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{

    NSLog(@"结束编辑");
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.textStr = [@"" mutableCopy];
    NSLog(@"did begin edit %@",textField.text);
}
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    NSLog(@"clear");
    self.textStr = [@"" mutableCopy];
    return YES;
}

//点击取消按钮的方法
-(void)cancleClick:(UIButton *)sender {
    
    self.tableView.hidden = YES;
    self.searchBg.hidden = YES;
    [self.searchBg removeFromSuperview];
    [self.coverView removeFromSuperview];
    [self.searchBarTableView removeFromSuperview];
    [self.searchBarText resignFirstResponder];
    
//重新加载view，添加子控件
    [self viewDidLoad];
}

//点击蒙版手势的方法
-(void)TapClick{
    self.tableView.hidden = YES;
    self.searchBg.hidden = YES;
    [self.coverView removeFromSuperview];
    [self.searchBg removeFromSuperview];
    [self.searchBarTableView removeFromSuperview];
    [self.searchBarText resignFirstResponder];
    [self viewDidLoad];
    
    self.isClink = !self.isClink;
}

//滑动搜索界面

#pragma mark ---- LAZY array ------
-(NSMutableArray *)FaultModelArray{

    if (!_FaultModelArray) {
        _FaultModelArray = [NSMutableArray array];
    }
    return _FaultModelArray;
}

- (NSMutableArray *)ChargeModelArray{

    if (!_ChargeModelArray) {
        _ChargeModelArray = [NSMutableArray array];
    }
    return _ChargeModelArray;
}

-(NSMutableArray *)ChargingModelArray{

    if (!_ChargingModelArray) {
        _ChargingModelArray = [NSMutableArray array];
    }
    return _ChargingModelArray;
}

-(NSMutableArray *)MainTainModelArray{

    if (!_MainTainModelArray) {
        _MainTainModelArray = [NSMutableArray array];
    }
    return _MainTainModelArray;
}

-(NSMutableArray *)AllModeArray{

    if (!_AllModeArray) {
        _AllModeArray = [[NSMutableArray alloc] init];
    }
    return _AllModeArray;
}

-(NSMutableArray *)resultDataSource{
    
    if (!_resultDataSource) {
        _resultDataSource = [NSMutableArray arrayWithCapacity:10];
    }
    return _resultDataSource;
}
-(UIView *)nullMask{

    if (!_nullMask) {
        
        _nullMask = [[UIView alloc]initWithFrame:self.view.frame];
        //    nullMask.backgroundColor = [UIColor redColor];
       
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, 100)];
        
        label.text = @"抱歉@~@ 暂无最新数据 \n 请稍后再试";
        label.textAlignment = NSTextAlignmentCenter;
        [_nullMask addSubview:label];
    }
    return _nullMask;
}

//返回按钮
-(void)setNavigation{
    
    self.navigationController.navigationBar.translucent = NO;
     UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_arrow"] style:(UIBarButtonItemStyleDone) target:self action: @selector(back)];
    
    self.navigationItem.leftBarButtonItem = button;
}

-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark ====LocationPush=======
-(void)locationPushShow:(int)index{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //本地推送
        UILocalNotification*notification = [[UILocalNotification alloc]init];
        NSDate * pushDate = [NSDate dateWithTimeIntervalSinceNow:5];
        if (notification != nil) {
            notification.fireDate = pushDate;
            notification.timeZone = [NSTimeZone defaultTimeZone];
            notification.repeatInterval = kCFCalendarUnitDay;
            notification.soundName = UILocalNotificationDefaultSoundName;
            notification.alertBody = [NSString stringWithFormat:@"新增故障桩:%d个",self.index];
            notification.applicationIconBadgeNumber = 0;
            NSDictionary*info = [NSDictionary dictionaryWithObject:@"test" forKey:@"name"];
            notification.userInfo = info;
             if (self.index > 0) {
                 [[UIApplication sharedApplication] scheduleLocalNotification:notification];//执行注册通知
             }else{
                 [[UIApplication sharedApplication] cancelLocalNotification:notification];//取消通知
             
             }
        }
        
    });
}


#pragma mark --- 定时器事件 ---
-(void)timerEvent{

    NSArray *array = [self requestDataForFaultPile];
   
    int index = (int)(array.count - self.FaultModelArray.count);
    self.index = index;
    
    if (self.index > 0) {
        NSLog(@"array = *****%ld   self.faultMOdelArray = *******%ld",array.count,self.FaultModelArray.count);
        [self locationPushShow:self.index];
    }

}

-(NSArray *)requestDataForFaultPile{

    [self.FaultModelArray removeAllObjects];
    QCDataCatchTool *catch = [[QCDataCatchTool alloc] initWithDBName:dbName sqlCmd:sql];
    
    self.FaultModelArray = [[catch getChargePileData:dbName withPileState:@"0"] mutableCopy];
    
    NSLog(@"%ld",self.commstate);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cpCnt"] = @10;
    params[@"commstate"] = [NSNumber numberWithInteger:0];
    
    NSLog(@"%ld",self.commstate);
    NSLog(@"%@",params[@"commstate"]);
    
     __block NSArray *arr = [NSArray array];
    
    [QCHttpTool httpQueryCPNumber:params success:^(id json) {
        
        NSLog(@"查询故障桩：json ==== %@",json);
        NSArray *detailArray = json[@"detail"];
        
        
        if ([json[@"errorCode"] isEqualToString:@"E0002"]) {//网络处理异常
            dispatch_async(dispatch_get_main_queue(), ^{
//                [QCReminderUserTool showError:self.view str:@"网络错误，请检查网络"];
            });
            return ;
        }
        
        arr = [self analysisModelWithArray:detailArray pileState:[NSString stringWithFormat:@"%ld",self.commstate]];
        
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            //[QCReminderUserTool showError:self.view str:@"网络错误，请检查网络"];
        });
    }];

    return arr;
}

@end
