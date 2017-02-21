//
//  QCFaultRecordCell.m
//  cocoapodSample
//
//  Created by cnc on 16/9/5.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import "QCFaultRecordCell.h"


@interface QCFaultRecordCell ()

@property (strong, nonatomic) IBOutlet UILabel *cpid;

@property (strong, nonatomic) IBOutlet UILabel *faultNum;
@property (strong, nonatomic) IBOutlet UILabel *address;

@end




@implementation QCFaultRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(QCFaultRecordModel *)model{


    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
