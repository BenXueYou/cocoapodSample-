//
//  QCDateTableViewCell.m
//  cocoapodSample
//
//  Created by cnc on 16/8/23.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import "QCDateTableViewCell.h"

@interface QCDateTableViewCell ()

@property (nonatomic, strong) UIImageView *cheakView;


@end

@implementation QCDateTableViewCell

- (UIImageView *)cheakView
{
    if (_cheakView == nil) {
        _cheakView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"选中对号"]];
        self.accessoryView = _cheakView;
    }
    return _cheakView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.contentView.backgroundColor = [UIColor redColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
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
