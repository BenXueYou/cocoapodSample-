//
//  QCSysAboutUsCtrl.m
//  cocoapodSample
//
//  Created by cnc on 16/9/5.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import "QCSysAboutUsCtrl.h"
#import "QCSystemServiceProtocol.h"
#import "XYNaviGationController.h"
@interface QCSysAboutUsCtrl ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *aboutUsTableView;
@property (nonatomic,strong) UIView *header;
@property (nonatomic,strong) UILabel *versonLabel;

@property (nonatomic,strong) NSArray *dataSource;
@end

@implementation QCSysAboutUsCtrl

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
}

-(UITableView *)aboutUsTableView{

    if (!_aboutUsTableView) {
        _aboutUsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 20) style:(UITableViewStylePlain)];
        _aboutUsTableView.delegate = self;
        _aboutUsTableView.dataSource = self;
        _aboutUsTableView.backgroundColor = XYCOLOR(246, 246, 246, 1);
        _aboutUsTableView.scrollEnabled = NO;
    }
    return _aboutUsTableView;
}

-(UIView *)header{

    if (!_header) {
        _header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 2.5)];
        
        _header.backgroundColor = [UIColor colorWithHex:0X299dff];
        
        CGFloat iconH = 100;
        CGFloat iconY = SCREEN_HEIGHT / 8;
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - iconH) / 2,iconY , iconH, iconH)];
        iconView.image = [UIImage imageNamed:@"logo.png"];
        iconView.layer.cornerRadius = 30;
        iconView.layer.masksToBounds = YES;
        CGFloat labelW = 150;
        CGFloat labelH = 30;
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - labelW) / 2, iconY + iconH, labelW, labelH)];
        label.font = [UIFont systemFontOfSize:15];
        [_header addSubview:iconView];
        [_header addSubview:label];
        
        self.versonLabel = label;
    }
    
    return _header;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    // bg.png为自己ps出来的想要的背景颜色。
    UIImage *image = [UIImage imageNamed:@"sys_nav_bg"];
    
    [navigationBar setBackgroundImage:image
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    
    [self.view addSubview:self.aboutUsTableView];
    self.aboutUsTableView.tableHeaderView = self.header;
    self.versonLabel.text = @"版本号：Version3.0";
    self.versonLabel.textColor = [UIColor whiteColor];
    
    self.aboutUsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.dataSource = @[@"服务协议",@"联系开发者"];
    [self setNavigation];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{return 1;}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AUCell"];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0.8, SCREEN_WIDTH, 0.8)];
    line.backgroundColor = [UIColor colorWithHex:0XC8C7CC];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"AUCell"];
    }
  
    if (indexPath.row == 0) {
        cell.backgroundColor = XYCOLOR(246, 246, 246, 1);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.dataSource[indexPath.row - 1]];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    if (indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
        
        return cell;
    }
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.text = @"133-6664-9092";
    [cell.contentView addSubview:line];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        return 15;
    }
    return 49;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 1) {
        QCSystemServiceProtocol *SSPV = [[QCSystemServiceProtocol alloc]init];
        [self.navigationController pushViewController:SSPV animated:YES];
    }
    if (indexPath.row == 2) {
        NSLog(@"弹窗拨打电话");
        [self callAction];
    }
}
//拨打电话方式一
- (void)callAction{
    NSString *number = @"183-2497-7850";// 此处读入电话号码
    // NSString *num = [[NSString alloc]initWithFormat:@"tel://%@",number]; //number为号码字符串 如果使用这个方法结束电话之后会进入联系人列表
    
    NSString *num = [[NSString alloc]initWithFormat:@"telprompt://%@",number]; //而这个方法则打电话前先弹框 是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
}
//拨打电话方式二
-(void)CallPhone{
    
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:@"tel:10086"];// 貌似tel:// 或者 tel: 都行
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    //记得添加到view上
    [self.view addSubview:callWebview];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
