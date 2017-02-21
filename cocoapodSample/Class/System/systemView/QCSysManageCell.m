//
//  QCSysManageCell.m
//  cocoapodSample
//
//  Created by cnc on 16/9/14.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import "QCSysManageCell.h"
#import "GlobalClass.h"
@interface QCSysManageCell ()
@property (strong, nonatomic) IBOutlet UIImageView *iconImg;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation QCSysManageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setItem:(WQItemModel *)item{

        _item = item;
        // 1.设置数据
        [self setData];
}

- (void)setData
{
    if (self.item.icon) {
        self.iconImg.image = [UIImage imageNamed:self.item.icon];
    }else{
//        self.iconImg.image = [[GlobalClass sharedInStance] Image];
         self.iconImg.image = [UIImage imageNamed:@"0000.png"];
    }
    if (self.item.title.length == 0) {
        self.titleLabel.text = [GlobalClass sharedInStance].name;
    }else{
        self.titleLabel.text = self.item.title;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
