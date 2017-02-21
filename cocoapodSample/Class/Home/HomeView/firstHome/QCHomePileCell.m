//
//  QCHomePileCell.m
//  cocoapodSample
//
//  Created by cnc on 16/8/23.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import "QCHomePileCell.h"

@implementation QCHomePileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.PileNumImage.userInteractionEnabled = YES;
    self.PileFaultImage.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
