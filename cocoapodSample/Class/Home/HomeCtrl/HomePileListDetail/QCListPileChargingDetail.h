//
//  QCListPileChargingDetail.h
//  cocoapodSample
//
//  Created by cnc on 16/8/26.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCPileListModel.h"
@interface QCListPileChargingDetail : UIViewController
@property (nonatomic,assign) float totalQuantity;
@property (nonatomic,assign) float totalFee;
@property (nonatomic,assign) float averagePrice;
@property (nonatomic,assign) float averageFee;

@property (nonatomic,assign) float pointQuantity;
@property (nonatomic,assign) float pointPrice;
@property (nonatomic,assign) float pointFee;

@property (nonatomic,assign) float peakQuantity;
@property (nonatomic,assign) float peakPrice;
@property (nonatomic,assign) float peakFee;

@property (nonatomic,assign) float flatQuantity;
@property (nonatomic,assign) float flatPrice;
@property (nonatomic,assign) float flatFee;

@property (nonatomic,assign) float valleyQuantity;
@property (nonatomic,assign) float valleyPrice;
@property (nonatomic,assign) float valleyFee;

//接受列表页的传值
@property (nonatomic,strong) QCPileListModel *model;

@end
