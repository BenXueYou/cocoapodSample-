//
//  QCPileMainTainCell.m
//  cocoapodSample
//
//  Created by cnc on 16/9/1.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import "QCPileMainTainCell.h"


@interface QCPileMainTainCell ()
@property (strong, nonatomic) IBOutlet UILabel *address;

@property (strong, nonatomic) IBOutlet UILabel *cpid;

@property (strong, nonatomic) IBOutlet UILabel *faultReson;

@property (strong, nonatomic) IBOutlet UILabel *rmPerson;
@property (strong, nonatomic) IBOutlet UILabel *rmPhone;

@end


@implementation QCPileMainTainCell


-(void)setModel:(QCPileListModel *)model{

    _model = model;
    
     _model.faultReason = [self faultReasonWithModel:model];
    
    self.cpid.text = [NSString stringWithFormat:@"%@",model.cpid];
    self.faultReson.text = [NSString stringWithFormat:@"%@",model.faultReason];
    self.rmPerson.text = [NSString stringWithFormat:@"%@",model.rmname];
    self.rmPhone.text = [NSString stringWithFormat:@"%@",model.rmphone];
    
    self.address.text = [NSString stringWithFormat:@"%@%@%@%@",model.province,model.city,model.area,model.address];
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



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
