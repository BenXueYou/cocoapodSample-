//
//  QCPileDetailModel.h
//  cocoapodSample
//
//  Created by cnc on 16/8/23.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCPileDetailModel : NSObject
@property (nonatomic,assign) long long chargePileAddress;


@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSString *cpid;
@property (nonatomic,strong) NSString *timeserial;
///////////////////////  sampling infomation /////////////////
@property (nonatomic,assign) NSNumber *commstate;//通信状态
@property (nonatomic,assign) float currentsoc;//当前SOC
@property (nonatomic,assign) int chargetime;//充电时间
@property (nonatomic,assign) int remaintime;//剩余时间
@property (nonatomic,assign) float currentavol;//当前交流电压
@property (nonatomic,assign) float currentacur;//当前交流电流
@property (nonatomic,assign) float outpower;//输出功率
@property (nonatomic,assign) float outquantity;//输出负荷
@property (nonatomic,assign) int acctime;//时间

////////////////////// fault infomation //////////////////////
//@property (nonatomic,strong) NSMutableArray *currentAlarmInfo;
@property (nonatomic,assign) bool cpinovervol;
@property (nonatomic,assign) bool cpoutovervol;
@property (nonatomic,assign) bool cpinundervol;
@property (nonatomic,assign) bool cpoutUndervol;

@property (nonatomic,assign) bool cpinovercur;
@property (nonatomic,assign) bool cpoutovercur;
@property (nonatomic,assign) bool cpinundercur;
@property (nonatomic,assign) bool cpoutundercur;

@property (nonatomic,assign) bool cptemphigh;
@property (nonatomic,assign) bool cpoutShort;
////////////////////// rate infomation ///////////////////////
@property (nonatomic,assign) float totalquantity;
@property (nonatomic,assign) float priceid;
@property (nonatomic,assign) float pointquantity;
@property (nonatomic,assign) float pointprice;
@property (nonatomic,assign) float pointfee;

@property (nonatomic,assign) float peakquantity;
@property (nonatomic,assign) float peakprice;
@property (nonatomic,assign) float peakfee;

@property (nonatomic,assign) float flatquantity;
@property (nonatomic,assign) float flatprice;
@property (nonatomic,assign) float flatfee;

@property (nonatomic,assign) float valleyquantity;
@property (nonatomic,assign) float valleyprice;
@property (nonatomic,assign) float valleyfee;
////////////////////// battery array infomation ///////////////////////
@property (nonatomic,assign) float batterysoc;
@property (nonatomic,assign) bool bmsstate;
@property (nonatomic,assign) float portvol;
@property (nonatomic,assign) int cellnum;
@property (nonatomic,assign) int tempnum;
@property (nonatomic,assign) float maxvol;
@property (nonatomic,assign) float maxchargetemp;
////////////////////// battery safty infomation ///////////////////////
@property (nonatomic,assign) float cellmaxvol;
@property (nonatomic,assign) int cellpos;
@property (nonatomic,assign) float cellminvol;
@property (nonatomic,assign) int cellminvolPos;
@property (nonatomic,assign) float maxtemp;
@property (nonatomic,assign) float mintemp;
////////////////////// battery alarm infomation ///////////////////////
@property (nonatomic,assign) bool voldataalarm;
@property (nonatomic,assign) bool samplevolfault;
@property (nonatomic,assign) bool singlevolalarm;
@property (nonatomic,assign) bool fanfailfault;
@property (nonatomic,assign) bool sampletempfault;
@end
