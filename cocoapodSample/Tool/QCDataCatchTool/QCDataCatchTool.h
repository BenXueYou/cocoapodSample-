//
//  QCDataCatchTool.h
//  cocoapodSample
//
//  Created by cnc on 16/9/9.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QCPileListModel;
@interface QCDataCatchTool : NSObject

//创建数据库
-(instancetype)initWithDBName:(NSString *)dbName sqlCmd:(NSString *)sql;

#pragma mark ------账户------
//添加账户信息数据
- (void)addChargePileUser:(NSString *)dbName cpData:(QCAdminModel *)data;

//查询账户信息数据
- (NSArray *)getChargePileUser:(NSString *) dbName;

#pragma mark ------列表页-----
//添加多条数据
- (void)addChargePileDatas:(NSString *)dbName sqlCmd:(NSString *)sqlCmd array:(NSArray *)dictArray;
//添加一条数据
- (void)addChargePileData:(NSString *)dbName sqlCmd:(NSString *)sqlCmd dict:(NSDictionary *)dict;
//查询数据
-(NSArray *)getChargePileData:(NSString *)dbName withPileState:(NSString *)pileState;
-(NSArray *)getAllChargePileData:(NSString *)dbName;
-(NSArray *)getChargePileData:(NSString *)dbName withSqlite:(NSString *)sql;

//修改数据
- (void)UpDatePileListData:(NSString *)dbName NewModel:(NSDictionary *)model;



//删除数据库所有数据
- (BOOL)deleteAllDataFromDB:(NSString *)dbName;



#pragma mark -----账单详情-------



@end
