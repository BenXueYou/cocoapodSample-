//
//  QCPileListLeisureModel.h
//  cocoapodSample
//
//  Created by cnc on 16/9/1.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCPileListLeisureModel : NSObject
@property (nonatomic,strong) NSString *cpid;
@property (nonatomic,assign) NSInteger todayfee;
@property (nonatomic,assign) NSInteger todayquantity;
@property (nonatomic,assign) NSInteger totalfee;
@property (nonatomic,assign) NSInteger totalquantity;

@end
