//
//  QCPersonalInfoCell.h
//  chargePileManage
//
//  Created by YuMing on 16/6/17.
//  Copyright © 2016年 shQianChen. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^cellBlock)(NSString *sex);

@class QCPersonInfoModel;

@interface QCPersonalInfoCell : UITableViewCell

//@property (nonatomic,copy)cellBlock block;


/**
 *  cell的模型数据
 */
@property (nonatomic,strong) QCPersonInfoModel *item;
//@property (nonatomic,copy) NSString *sex;
//@property (nonatomic,strong) UIImage *Image;
/**
 *  创建cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
