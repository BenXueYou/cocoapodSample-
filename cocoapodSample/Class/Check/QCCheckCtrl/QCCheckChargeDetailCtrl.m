//
//  QCCheckChargeDetailCtrl.m
//  cocoapodSample
//
//  Created by cnc on 16/8/25.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import "QCCheckChargeDetailCtrl.h"
#import "QCChargingDetailCell.h"
@interface QCCheckChargeDetailCtrl ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *chargeDetailTableView;

@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UILabel *feeLabel;


@property (nonatomic,strong) NSMutableArray *dataSuorce;
@property (nonatomic,strong) NSArray *titles;
@end

@implementation QCCheckChargeDetailCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titles = @[@"服务费",@"停车费",@"预约费",@"折扣"];
    self.dataSuorce = [@[@"20￥",@"3￥/H",@"120￥",@"60%"] mutableCopy];
    
    
    self.chargeDetailTableView.delegate = self;
    self.chargeDetailTableView.dataSource = self;
    self.chargeDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setupView];
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

-(void)setupView{

    self.chargeDetailTableView.tableHeaderView = self.headView;
    [self.headView addSubview:self.feeLabel];
    [self.chargeDetailTableView registerNib:[UINib nibWithNibName:@"QCChargingDetailCell" bundle:nil] forCellReuseIdentifier:@"ChargeDetailCell"];
    
}

#pragma mark ---- 懒加载---------
-(UILabel *)feeLabel{

    if (!_feeLabel) {
        _feeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 30 - 150, 20, 150, 30)];
        _feeLabel.text = @"87.0";
        _feeLabel.text = [NSString stringWithFormat:@"%ld",self.model.totalfee];
        _feeLabel.font = [UIFont systemFontOfSize:18];
    }
    return _feeLabel;
}
-(UIView *)headView{

    if (!_headView) {
        
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        _headView.backgroundColor = [UIColor colorWithHex:0X299dfe];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, 120, 30)];
        
        label.text = @"充电费用";
        [_headView addSubview:label];
    }
    return _headView;
}

#pragma mark -------UItableviewDatasource--------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    QCChargingDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChargeDetailCell"];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",self.titles[indexPath.row]];
    cell.detailLabel.text = [NSString stringWithFormat:@"%@",self.dataSuorce[indexPath.row]];
    return cell;
}
//返回高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
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
