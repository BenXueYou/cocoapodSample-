//
//  QCTableViewCell.h
//  cocoapodSample
//
//  Created by cnc on 16/8/18.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCPileListModel.h"
@interface QCTableViewCell : UITableViewCell
@property (nonatomic,strong) QCPileListModel *FaultModel;
@end
