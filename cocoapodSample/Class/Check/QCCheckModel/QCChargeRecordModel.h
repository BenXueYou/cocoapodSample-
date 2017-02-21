//
//  QCChargeRecordModel.h
//  chargePileManage
//
//  Created by YuMing on 16/6/27.
//  Copyright © 2016年 shQianChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCChargeRecordModel : NSObject

@property (nonatomic,strong) NSString *cpid;  // 桩号
@property (nonatomic,assign) NSInteger totalfee;//费用
@property (nonatomic,assign) NSInteger totalquantity;//电量
@property (nonatomic,assign) NSInteger totaltime;//时间
@property (nonatomic,assign) NSInteger  price;
@property (nonatomic,strong) NSString *begintime;//日期
@end
