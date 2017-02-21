//
//  QCPersonalInfoCtrl.m
//  chargePileManage
//
//  Created by YuMing on 16/6/16.
//  Copyright © 2016年 shQianChen. All rights reserved.
//

#import "QCPersonalInfoCtrl.h"

#import "WQItemModel.h"
#import "WQItemArrowModel.h"
#import "QCItemIconModel.h"
#import "QCItemSegmentModel.h"
#import "WQTableViewGroupModel.h"

#import "QCPersonalInfoCell.h"

#import "QCNickNameAlertCtrl.h"
#import "QCChargePwdCtrl.h"


#import "QCUserModel.h"

#import "QCPersonInfoModel.h"
#import "QCPersonInfoArrowModel.h"
#import "QCPersonInfoLabelModel.h"
#import "QCPersonInfoSwitchModel.h"
#import "QCPersonInfoIconModel.h"
#import "QCPersonInfoSegmentModel.h"

#import "QCHttpTool.h"
#import "QCLoginCtrl.h"
#import "UIColor+hex.h"

#import "MBProgressHUD.h"
#import "QCReminderUserTool.h"
#import "QCDataCatchTool.h"
@interface QCPersonalInfoCtrl () <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic,weak) UITableView *personalInfoView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) QCUserModel *userData;

@property (nonatomic,copy) NSString *subNickName;
@property (nonatomic,copy) NSString *subPermission;
@property (nonatomic,copy) NSString *subAddress;

@property (nonatomic,strong) NSMutableDictionary *personDic;;

@property(nonatomic,assign)int index;
@property (nonatomic,strong) UIView *lineView;

@end

@implementation QCPersonalInfoCtrl

-(UIView *)lineView{

    if (!_lineView) {
        _lineView = [[UIView alloc]init];
    }
    return _lineView;
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - init
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat tableViewH = self.view.frame.size.height;
    CGRect tableFrame = CGRectMake(0, 0, SCREEN_WIDTH, tableViewH);

    UITableView *personalInfoView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped];
    personalInfoView.backgroundColor = XYCOLOR(226, 226, 226,1);
    
    UIView *headerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    personalInfoView.tableHeaderView = headerView;
    
    [self.view addSubview:personalInfoView];
    self.personalInfoView = personalInfoView;
    self.personalInfoView.delegate = self;
    self.personalInfoView.dataSource = self;
    
    [self setupView];
    
    [self setupFooterView:personalInfoView];
    
    [self setNavigation];
//    self.userData = [self takeDataFromDB];
//    [self takeDataFromDB];
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



- (void) takeDataFromDB
{
    NSString *dbName = @"chargePileData.sqlite";
    NSString *sqlCmd = @"CREATE TABLE IF NOT EXISTS t_user (id integer PRIMARY KEY AUTOINCREMENT,userID text,passWord text,icon blob,nickName text,sex text,permission text,area text)";
    QCDataCatchTool *cache = [[QCDataCatchTool alloc] initWithDBName:dbName sqlCmd:sqlCmd];
    NSArray *arr = [cache getChargePileUser:dbName];
    
    // 从NSUserDefault中得到帐号信息
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [accountDefaults objectForKey:@"name"];
    // 从arr中取出对应帐号的具体信息，并将数据取到模型中
    
    for (QCUserModel *user in arr) {
        if ([user.userID isEqualToString:userName]) {
            self.userData = user;
        }
    }
}
- (void)setupFooterView:(UITableView *)tableView
{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, 0, 50);
    view.backgroundColor = XYCOLOR(226, 226, 226,1);
    tableView.tableFooterView = view;
    
    CGFloat btnW = SCREEN_WIDTH - 20;
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = [UIColor colorWithHex:0x299dff];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(savePersonalInfo) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(10, 0, btnW, 40);
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 8;
    btn.layer.borderWidth = 1.0;
    btn.layer.borderColor = [XYCOLOR(226,226,226,1) CGColor];
    [view addSubview:btn];
    
}
- (void)savePersonalInfo
{
    NSLog(@"保存！！！");

//    NSString *url = http://192.168.8.132:8080/ServerForCO/userInfo/saveInfo;
    
    NSLog(@"model.name = %@,model.gender = %@",[GlobalClass sharedInStance].name,[GlobalClass sharedInStance].gender);
    
    UIImage *image = [GlobalClass sharedInStance].Image;
    NSData *ImagedData = UIImagePNGRepresentation(image);
 
    [self.personDic setValue:[GlobalClass sharedInStance].name forKey:@"name"];
    [self.personDic setValue:[GlobalClass sharedInStance].gender forKey:@"gender"];
    [self.personDic setValue:ImagedData forKey:@"image"];
    
    [QCHttpTool httpQueryData:CPMAPI_PREFIX params:self.personDic success:^(id json) {
       
        NSLog(@"修改成功+++++++++%@",json);

            [QCReminderUserTool showError:self.view str:@"修改信息成功"];

    
    } failure:^(NSError *error) {
        
        NSLog(@"信息保存失败");
            [QCReminderUserTool showError:self.view str:@"服务器繁忙"];
        
    }];
    
}
- (void)setupView
{
    QCPersonInfoModel *icon = [QCPersonInfoIconModel itemWithTitle:@"头像"];
    
    QCPersonInfoModel *nickName = [QCPersonInfoArrowModel itemWithTitle:@"昵称" subTitle:@"输入昵称" destVcClass:[QCNickNameAlertCtrl class]];
    QCPersonInfoModel *sex = [QCPersonInfoSegmentModel itemWithTitle:@"性别"];
    QCPersonInfoModel *changePwd = [QCPersonInfoArrowModel itemWithTitle:@"修改密码" destVcClass:[QCChargePwdCtrl class]];
    QCPersonInfoModel *accountPermission = [QCPersonInfoArrowModel itemWithTitle:@"帐号权限" subTitle:@"一般用户" destVcClass:nil];
   
    NSArray *tempArray = @[icon,nickName,sex,changePwd,accountPermission];
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
    QCPersonalInfoCell *cell = [QCPersonalInfoCell cellWithTableView:tableView];
    QCPersonInfoModel *item = self.dataArray[indexPath.row];
    cell.item = item;
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QCPersonInfoModel *item = self.dataArray[indexPath.row];
    
    if ([item.title isEqualToString:@"头像"]) {
        
        return 80;
    }
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QCPersonInfoModel *item = self.dataArray[indexPath.row];
    
    
    if ([item.title isEqualToString:@"头像"]) {
        self.index = (int)indexPath.row;
    }
    
    if (item.option) {
        item.option();
    }  else if ([item isKindOfClass:[QCPersonInfoArrowModel class]]) {
        QCPersonInfoArrowModel *arrowItem = (QCPersonInfoArrowModel *)item;
        // 如果没有需要跳转的控制器
        if (arrowItem.destVcClass == nil) {
            return;
        }
        
        if (arrowItem.destVcClass == [QCNickNameAlertCtrl class]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入昵称:" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            alert.tag = 0;
            UITextField *text = [alert textFieldAtIndex:0];
             ;
           [GlobalClass sharedInStance].name  = text.text;
            [alert show];
            return;
        }
        
        
        UIViewController *vc = [[arrowItem.destVcClass alloc]init];
        vc.title = arrowItem.title;
        vc.hidesBottomBarWhenPushed = YES;
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UITextField *text = [alertView textFieldAtIndex:0];
    
    if (buttonIndex == 0) {
        NSLog(@"点击取消");
    } else {
        
        if (alertView.tag == 0) {
            for (QCPersonInfoModel *item in self.dataArray) {
                if ([item.title isEqualToString:@"昵称"]) {
                    item.subTitle = text.text;
                    
                    [GlobalClass sharedInStance].name = text.text;
                    
                    [_personalInfoView reloadData];
                    
                    break;
                }
            }
        }
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
- (void)setUserData:(QCUserModel *)userData
{
    if (_userData != userData) {
        _userData = userData;
        
        for (QCPersonInfoModel *user in self.dataArray) {
            if ([user.title isEqualToString:@"昵称"]) {
                user.subTitle = userData.nickName;
            }
            if ([user.title isEqualToString:@"头像"]) {
                user.image = userData.icon;
            }
            if ([user.title isEqualToString:@"性别"]) {
                if ([userData.sex isEqualToString:@"男"]) {
                    user.gender = 0;
                } else {
                    user.gender = 1;
                }
            }
            if ([user.title isEqualToString:@"修改密码"]) {
                
            }
            if ([user.title isEqualToString:@"帐号权限"]) {
                user.subTitle = userData.permission;
            }
            if ([user.title isEqualToString:@"所在小区"]) {
                user.subTitle = userData.area;
            }
            
        }
    }
    [self.personalInfoView reloadData];
}
//懒加载
-(NSMutableDictionary *)personDic{

    if (!_personDic) {
        _personDic = [NSMutableDictionary dictionary];
    }
    return _personDic;
}
@end
