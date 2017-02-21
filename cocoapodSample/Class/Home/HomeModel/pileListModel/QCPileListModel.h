//
//  QCPileListModel.h
//  cocoapodSample
//
//  Created by cnc on 16/9/1.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCPileListModel : NSObject
@property (nonatomic,strong) NSString *area;//区域
@property (nonatomic,strong) NSString *address;//地址
@property (nonatomic,strong) NSString *cpid;//桩编号
@property (nonatomic,assign) NSInteger faulttype;//故障类型
@property (nonatomic,strong) NSString *location;//位置
@property (nonatomic,strong) NSString * alarmtime;//告警时间
@property (nonatomic,strong) NSString *province;//省
@property (nonatomic,strong) NSString *rmphone;//维修电话
@property (nonatomic,strong) NSString *rmname;//维修人员
@property (nonatomic,strong) NSString *faultReason;//故障原因
@property (nonatomic,strong) NSString *city;//市
@property (nonatomic,assign) NSInteger todayfee;//今日收入
@property (nonatomic,assign) NSInteger todayquantity;//今日充电量
@property (nonatomic,assign) NSInteger totalfee;//累计收入
@property (nonatomic,assign) NSInteger totalquantity;//累计充电量
@property (nonatomic, assign) NSInteger lastfee;//本次收入
@property (nonatomic, assign) NSInteger lastquantity;//本次充电
@property (nonatomic,strong) NSString *pileState;//桩类型







@end
