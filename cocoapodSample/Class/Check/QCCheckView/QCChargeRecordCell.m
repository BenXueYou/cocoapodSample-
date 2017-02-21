//
//  QCChargeRecordCell.m
//  cocoapodSample
//
//  Created by 飞翔 on 16/8/24.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import "QCChargeRecordCell.h"


@interface QCChargeRecordCell ()

@property (strong, nonatomic) IBOutlet UILabel *cpid;

@property (strong, nonatomic) IBOutlet UILabel *fee;
@property (strong, nonatomic) IBOutlet UILabel *time;

@property (strong, nonatomic) IBOutlet UILabel *quantity;
@property (strong, nonatomic) IBOutlet UILabel *date;

@end


@implementation QCChargeRecordCell


-(void)setModel:(QCChargeRecordModel *)model{

    _model = model;
    
    self.cpid.text = [NSString stringWithFormat:@"编号：%@",model.cpid];
    self.fee.text = [NSString stringWithFormat:@"费用：%ld（元）",model.totalfee];
    self.time.text = [NSString stringWithFormat:@"时间：%ld（min）",model.totaltime];
    self.date.text = [NSString stringWithFormat:@"日期：%@ ",model.begintime];
    self.quantity.text = [NSString stringWithFormat:@"电量：%ld（kWh）",model.totalquantity];

}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
