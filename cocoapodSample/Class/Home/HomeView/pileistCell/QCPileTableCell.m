//
//  QCPileTableCell.m
//  cocoapodSample
//
//  Created by cnc on 16/8/24.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import "QCPileTableCell.h"

@interface QCPileTableCell ()

@property (strong, nonatomic) IBOutlet UILabel *cpid;

@property (strong, nonatomic) IBOutlet UILabel *todayFee;
@property (strong, nonatomic) IBOutlet UILabel *todayQuantity;

@property (strong, nonatomic) IBOutlet UILabel *totalFee;
@property (strong, nonatomic) IBOutlet UILabel *totalQuantity;

@end

@implementation QCPileTableCell


- (void)setModel:(QCPileListModel *)model{

    _model = model;
    
    self.cpid.text = [NSString stringWithFormat:@"编号：%@",model.cpid];
    self.todayFee.text = [NSString stringWithFormat:@"今日收入:%ld    (元)",model.todayfee];
    self.todayQuantity.text = [NSString stringWithFormat:@"今日充电量：%ld    (kWh)",model.todayquantity];
    self.totalQuantity.text = [NSString stringWithFormat:@"累计充电量：%ld    (kWh)",model.totalquantity];
    self.totalFee.text = [NSString stringWithFormat: @"累计收入：%ld    （元）",model.totalfee];

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
