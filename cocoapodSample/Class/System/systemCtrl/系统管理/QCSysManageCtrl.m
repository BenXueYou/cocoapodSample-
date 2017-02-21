//
//  QCSysManageCtrl.m
//  chargePileManage
//
//  Created by YuMing on 16/6/15.
//  Copyright © 2016年 shQianChen. All rights reserved.
//

#import "QCSysManageCtrl.h"

#import "QCSysManageHeaderView.h"
#import "QCSysManageCell.h"

#import "QCLoginCtrl.h"

#import "WQItemModel.h"
#import "WQItemArrowModel.h"

#import "QCPersonalInfoCtrl.h"
#import "QCFeedBackCtrl.h"
#import "QCSysMessenge.h"
#import "QCUseHelpCtrl.h"
#import "QCSysAboutUsCtrl.h"

//弹窗
#import "UIAlertView+Quick.h"
#import "QCReminderUserTool.h"

#import "QCDataCatchTool.h"

//清除缓存
#import "SPClearCacheTool.h"

#define dbName  @"QCPileList.sqlite"

#define sql  @"CREATE TABLE IF NOT EXISTS t_PileList (id integer PRIMARY KEY AUTOINCREMENT,cpid text,alarmtime text,totalfee text,totalquantity text,todayfee text,todayquantity text,lastfee text,lastquantity text,province text,city text,area text,faulttype text,faultReason text,rmname text,rmphone text,address text,pileState text,todatquantity text)"

@interface QCSysManageCtrl () <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic,weak) UITableView *manageView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) QCSysManageHeaderView *header;
@end

@implementation QCSysManageCtrl

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    if ([GlobalClass sharedInStance].Image) {
        
        self.header.userImageView.image = [GlobalClass sharedInStance].Image;
    }
    if ([GlobalClass sharedInStance].name) {
        
        self.header.userNameLbl.text = [GlobalClass sharedInStance].name;
    }
    
   
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = XYCOLOR(246,246,246,1);
    
    CGFloat headerViewH = 135;
    
    self.header = [[QCSysManageHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerViewH)];

    
    CGFloat tableViewH = self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height;
    CGRect tableFrame = CGRectMake(0, 0, SCREEN_WIDTH, tableViewH);
    
    UITableView *manageView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped];
    manageView.backgroundColor = XYCOLOR(246, 246, 246,1);

    manageView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:manageView];
    
    self.manageView = manageView;
    self.manageView.delegate = self;
    self.manageView.dataSource = self;
    
    self.manageView.tableHeaderView = self.header;
    
    [self.manageView registerNib:[UINib nibWithNibName:@"QCSysManageCell" bundle:nil] forCellReuseIdentifier:@"SYSCell"];
    
    [self setupFooterView:manageView];
    [self setupTableView];
}
/**
 *  jump to login view
 */
- (void) logOut
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要退出登录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void) setupFooterView:(UITableView *)tableView
{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, 0, 50);
    view.backgroundColor = XYCOLOR(246, 246, 246,1);
    tableView.tableFooterView = view;
    
    CGFloat btnW = SCREEN_WIDTH - 36;
    UIButton *btn = [[UIButton alloc] init];
//    btn.backgroundColor = [UIColor flatBlueColor];
    [btn setBackgroundImage:[UIImage resizedImageWithName:@"sys_nav_bg"] forState:(UIControlStateNormal)];
    
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(18, 0, btnW, 35);
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 8;
    btn.layer.borderWidth = 1.0;
    btn.layer.borderColor = [XYCOLOR(246,246,246,1) CGColor];
    [view addSubview:btn];
    
}

- (void) setupTableView
{
    WQItemModel *personalInfo = [WQItemArrowModel itemWithIcon:@"personal" title:@"个人资料" destVcClass:[QCPersonalInfoCtrl class]];
    
    WQItemModel *myNews = [WQItemArrowModel itemWithIcon:@"message" title:@"我的消息" destVcClass:[QCSysMessenge class]];
   
    WQItemModel *cleanCatch = [WQItemArrowModel itemWithIcon:@"del" title:@"清除缓存" destVcClass:nil];
    //WQItemModel *pushSwitch = [WQItemArrowModel itemWithIcon:@"swt" title:@"故障推送" destVcClass:nil];
    WQItemModel *feedBack = [WQItemArrowModel itemWithIcon:@"suggestion" title:@"意见反馈" destVcClass:[QCFeedBackCtrl class]];

    WQItemModel *useHelp = [WQItemArrowModel itemWithIcon:@"usinghelp" title:@"使用帮助" destVcClass:[QCUseHelpCtrl class]];
    WQItemModel *aboutUs = [WQItemArrowModel itemWithIcon:@"us" title:@"关于我们" destVcClass:[QCSysAboutUsCtrl class]];
   
    
    NSArray *tempArray = @[personalInfo,myNews,feedBack,cleanCatch,useHelp,aboutUs];
    
    self.dataArray = (NSMutableArray *)tempArray;
}

#pragma mark - UITableViewDateSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QCSysManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SYSCell" forIndexPath:indexPath];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.item = self.dataArray[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
#pragma mark - UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WQItemModel *item = self.dataArray[indexPath.row];
    
    if (item.option) {
        item.option();
    }  else if ([item isKindOfClass:[WQItemArrowModel class]]) {
        WQItemArrowModel *arrowItem = (WQItemArrowModel *)item;
        // 如果没有需要跳转的控制器
        if (arrowItem.destVcClass == nil) {
            
//            清除缓存
        [UIAlertView showWithTitle:@"是否清除缓存?" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];

            return;
        }
        UIViewController *vc = [[arrowItem.destVcClass alloc]init];
        vc.title = arrowItem.title;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }

}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.inputView.hidden = NO;
    if (buttonIndex == 0) {  // 否按钮点击
        
    } else {  // 是按钮点击
        // 清空num数组
       [self action:nil];
        QCDataCatchTool  *catch = [[QCDataCatchTool alloc] initWithDBName:dbName sqlCmd:sql];
        BOOL success = [catch deleteAllDataFromDB:dbName];
        if (success) {
            NSLog(@"删除成功");
        }
       [self.inputView setNeedsDisplay];
    }
}

#pragma mark - 清除缓存

- (void)action:(id)sender

{
    
    NSString *str  = nil;

    BOOL isFinished = [SPClearCacheTool clearCaches];
    
    if (isFinished == NO) return; // isFinished为NO并不代表清理失败，而是用户已经清理过
    
    NSString *fileSize = [SPClearCacheTool getCacheSize];
    
    str = [NSString stringWithFormat: @"缓存大小:%@",fileSize];
    
//    弹窗
    dispatch_async(dispatch_get_main_queue(), ^{
        [QCReminderUserTool showCorrect:self.view str:str];
    });

}
#pragma mark - AlertViewDelegate
/**
 *  alertView dismiss
 */
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    if (buttonIndex == 1) {
        bool autoLogin = [[accountDefaults objectForKey:@"autoLogin"] boolValue];
        if (autoLogin) {
            [accountDefaults setBool:NO forKey:@"autoLogin"];
            [accountDefaults synchronize];
        }
        [UIApplication sharedApplication].keyWindow.rootViewController = [[QCLoginCtrl alloc] init];
    }
}
#pragma mark - gets and sets
- (NSMutableArray *) dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
