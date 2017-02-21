//
//  QCPileListChargingModel.h
//  cocoapodSample
//
//  Created by cnc on 16/9/1.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCPileListChargingModel : NSObject

@property (nonatomic ,strong) NSString * cpid;
@property (nonatomic, assign) NSInteger lastfee;
@property (nonatomic, assign) NSInteger lastquantity;
@property (nonatomic, assign) NSInteger totalfee;
@property (nonatomic ,assign) NSInteger totalquantity;
@end
