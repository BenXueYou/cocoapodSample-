//
//  QCTableViewCell.m
//  cocoapodSample
//
//  Created by cnc on 16/8/18.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import "QCTableViewCell.h"

@interface QCTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *cpId;

@property (strong, nonatomic) IBOutlet UILabel *faultReason;
@property (strong, nonatomic) IBOutlet UILabel *alarmtime;
@property (strong, nonatomic) IBOutlet UILabel *Address;

@end

@implementation QCTableViewCell

-(void)setFaultModel:(QCPileListModel *)FaultModel{
    _FaultModel = FaultModel;
    
    _FaultModel.faultReason = [self faultReasonWithModel:FaultModel];
    
    self.cpId.text = [NSString stringWithFormat:@"编号：%@",FaultModel.cpid];
    self.faultReason.text  = [NSString stringWithFormat:@"告警原因：%@",_FaultModel.faultReason];
    
    self.alarmtime.text = [NSString stringWithFormat:@"告警时间：%@",_FaultModel.alarmtime];
    self.Address.text = [NSString stringWithFormat:@"地址：%@%@%@%@",_FaultModel.province,_FaultModel.city,_FaultModel.area,_FaultModel.address];
}

-(NSString *)faultReasonWithModel:(QCPileListModel *)model{

    NSString *faultReason = @"";
    
    
    switch (_FaultModel.faulttype) {
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




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
