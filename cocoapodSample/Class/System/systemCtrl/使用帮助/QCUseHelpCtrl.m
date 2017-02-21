//
//  QCUseHelpCtrl.m
//  cocoapodSample
//
//  Created by cnc on 16/9/5.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import "QCUseHelpCtrl.h"
#import "QCSysUseHelpCellData.h"

@interface QCUseHelpCtrl ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *UseTableView;
@property (nonatomic,strong) NSMutableArray *sectionArray;
@property (nonatomic,strong) NSMutableArray *cellDataArray;
@end

@implementation QCUseHelpCtrl

-(UITableView *)UseTableView{

    if (!_UseTableView) {
        _UseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44) style:(UITableViewStyleGrouped)];
//        _UseTableView.backgroundColor = [UIColor cyanColor];
        _UseTableView.delegate = self;
        _UseTableView.dataSource = self;
    }
    return _UseTableView;
}

- (NSMutableArray *)sectionArray{

    if (!_sectionArray) {
        _sectionArray = [NSMutableArray array];
        [_sectionArray addObjectsFromArray:@[@"关于首页",@"查询",@"系统管理"]];
    }
    return _sectionArray;
}

- (NSMutableArray *)cellDataArray{
  
        _cellDataArray = [[QCSysUseHelpCellData shareInstance] cellDataWithStrng];
    return _cellDataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.UseTableView];
    
    [self.UseTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UHCell"];
    [self setNavigation];
}

#pragma mark ----UITableViewDateSource----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.sectionArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%ld",self.cellDataArray.count);
    NSArray * array = self.cellDataArray[section];
    
    return array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UHCell"];
    [cell.textLabel sizeToFit];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    NSArray * array = self.cellDataArray[indexPath.section];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",array[indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            return 180;
        }
        return 150;
    }
    else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return 100;
        }
    }
    return 60;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    header.backgroundColor = [UIColor flatSkyBlueColor];
    
    UILabel *label  =[[UILabel alloc] initWithFrame:CGRectMake(20, 15, 150, 25)];
    label.font = [UIFont systemFontOfSize:18];
    label.text = self.sectionArray[section];
    [label sizeToFit];
    
    [header addSubview:label];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
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
