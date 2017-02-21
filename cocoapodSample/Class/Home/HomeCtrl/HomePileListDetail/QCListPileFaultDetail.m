//
//  QCListPileFaultDetail.m
//  cocoapodSample
//
//  Created by cnc on 16/8/25.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import "QCListPileFaultDetail.h"
#import "KWFormViewQuickBuilder.h"

@interface QCListPileFaultDetail ()
@property (strong, nonatomic) IBOutlet UIView *TableView;



@property (strong, nonatomic) IBOutlet UILabel *address;

@property (strong, nonatomic) IBOutlet UILabel *FaultReason;

@property (nonatomic, strong) NSArray *titles;

@end

@implementation QCListPileFaultDetail

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = [NSString stringWithFormat:@"%@号桩故障",self.model.cpid];
//    self.navigationItem.title = @"7号桩故障";
    
    
    NSString *fault = [self faultReasonWithModel:self.model];
    
    self.FaultReason.text = [NSString stringWithFormat: @"%@",fault];
    self.address.text = [NSString stringWithFormat:@"%@%@%@%@",self.model.province,self.model.city,self.model.area,self.model.address];
    
    //self.address.text  =  @"上海市杨浦区长阳路1080号国际设计交流中心10号楼201B";
    
    
    
    KWFormViewQuickBuilder *builder = [[KWFormViewQuickBuilder alloc] init];
    [builder addRecord: self.titles];
    [builder addRecord:@[@"桩枪头数",@"5",@"输出功率",@"7KW"]];
    [builder addRecord:@[@"输出电流",@"16A",@"输出电压",@"220V"]];
    [builder addRecord:@[@"当前电流",@"16A",@"当前电压",@"243V"]];
    [builder addRecord:@[@"故障电流",@"16A",@"故障电压",@"248V"]];
    
    if (self.model.alarmtime.length) {
        
        [builder addRecord:@[@"故障日期",[self.model.alarmtime componentsSeparatedByString:@" "].firstObject,@"告警时间",[self.model.alarmtime componentsSeparatedByString:@" "].lastObject]];
    }
    
    CGFloat Width = (SCREEN_WIDTH - 30)/4;
    
    KWFormView *formView = [builder startCreatWithWidths:@[@(Width),@(Width),@(Width),@(Width)] startPoint:CGPointMake(15, 35)];
    [self.TableView addSubview:formView];
    [self setNavigation];
}


-(NSString *)faultReasonWithModel:(QCPileListModel *)model{
    
    NSString *faultReason = @"";
    
    
    switch (_model.faulttype) {
        case 0:
            faultReason  = @"输入过压";
            break;
        case 1:
            faultReason  = @"输出过压";
            break;
        case 2:
            faultReason  = @"输入欠压";
            break;
        case 3:
            faultReason  = @"输出欠压";
            break;
        case 4:
            faultReason  = @"输入过流";
            break;
        case 5:
            faultReason  = @"输出过流";
            break;
        case 6:
            faultReason  = @"输入欠流";
            break;
        case 7:
            faultReason  = @"输出欠流";
            break;
        case 8:
            faultReason  = @"断电";
            break;
            
        default:
            faultReason  = @"断网";
            break;
    }
    return faultReason;
}



-(void)setNavigation{
    self.navigationController.navigationBar.translucent = NO;
     UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_arrow"] style:(UIBarButtonItemStyleDone) target:self action: @selector(back)];    
    self.navigationItem.leftBarButtonItem = button;
}

-(void)back{
    

    [self.navigationController popViewControllerAnimated:YES];
}


- (NSArray *)titles
{
    if (!_titles) {
        
        NSString *str = [NSString stringWithFormat:@"%@",self.model.cpid];
        
        _titles = @[@"桩编号",str,@"建桩日期",@"2016-08-15"];
    }
    return _titles;
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
//    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;

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
