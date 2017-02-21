//
//  QCPileChargingCell.m
//  cocoapodSample
//
//  Created by cnc on 16/8/29.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import "QCPileChargingCell.h"

@interface QCPileChargingCell ()

@property (strong, nonatomic) IBOutlet UILabel *cpid;

@property (strong, nonatomic) IBOutlet UILabel *lastCharge;

@property (strong, nonatomic) IBOutlet UILabel *lastfee;

@property (strong, nonatomic) IBOutlet UILabel *totalfee;
@property (strong, nonatomic) IBOutlet UILabel *totalquantity;

@end

@implementation QCPileChargingCell




-(void)setModel:(QCPileListModel *)model{

    _model = model;
    
    self.cpid.text = [NSString stringWithFormat:@"编号：%@",model.cpid];
    self.lastfee.text = [NSString stringWithFormat:@"本次费用：%ld  (元)",model.lastfee];
    self.lastCharge.text = [NSString stringWithFormat:@"本次充电：%ld （kWh）",model.lastquantity];
    self.totalfee.text = [NSString stringWithFormat:@"累计收入：%ld  (元)",model.totalfee];
    self.totalquantity.text = [NSString stringWithFormat:@"累计充电：%ld  （kWh）",model.totalquantity];
    
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
