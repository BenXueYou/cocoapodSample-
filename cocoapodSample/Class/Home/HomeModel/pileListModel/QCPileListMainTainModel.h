//
//  QCPileListMainTainModel.h
//  cocoapodSample
//
//  Created by cnc on 16/9/1.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCPileListMainTainModel : NSObject
@property (nonatomic,strong) NSString *area;
@property (nonatomic,strong) NSString *address;//地址

@property (nonatomic,strong) NSString *cpid;
@property (nonatomic,assign) NSInteger faulttype;
@property (nonatomic,strong) NSString *location;
@property (nonatomic,strong) NSString *alarmtime;
@property (nonatomic,strong) NSString *province;
@property (nonatomic,strong) NSString *rmphone;
@property (nonatomic,strong) NSString *rmname;
@property (nonatomic,strong) NSString *faultReason;
@property (nonatomic,strong) NSString *city;
@end
