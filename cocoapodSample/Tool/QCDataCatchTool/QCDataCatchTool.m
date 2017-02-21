//
//  QCDataCatchTool.m
//  cocoapodSample
//
//  Created by cnc on 16/9/9.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import "QCDataCatchTool.h"
#import <FMDB/FMDB.h>

#import "MJExtension.h"

//登录
#import "QCAdminModel.h"

//列表

#import "QCPileListModel.h"//故障cell
#import "QCPileListLeisureModel.h"//空闲cell
#import "QCPileListChargingModel.h"//充电cell
#import "QCPileListMainTainModel.h"//维护cell






@implementation QCDataCatchTool
static FMDatabaseQueue *_queue;
#pragma -mark init db
-(instancetype)initWithDBName:(NSString *)dbName sqlCmd:(NSString *)sql{
    
    self = [super init];
    if (self) {
        
        NSString *docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        
        NSString *path = [docsdir stringByAppendingPathComponent:dbName];
        
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:path];
        [queue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:sql];
        }];
        [queue close];
    }
    return self;
}

#pragma - mark add and read USER_INFO
//存数据
- (void)addChargePileUser:(NSString *)dbName cpData:(QCAdminModel *)data
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:dbName];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:path];
    [queue inDatabase:^(FMDatabase *db) {
        NSData *iconData = [NSKeyedArchiver archivedDataWithRootObject:data.icon];
        [db executeUpdate:@"INSERT INTO t_user (userID,passWord,icon,nickName,sex,permission,area) values(?,?,?,?,?,?,?)",data.userID,data.passWord,iconData,data.nickName,data.sex,data.permission,data.area];
    }];
    [queue close];
}
//取数组
- (NSArray *)getChargePileUser:(NSString *) dbName
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:dbName];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:path];
    __block NSMutableArray *statusArray = nil;
    
    [queue inDatabase:^(FMDatabase *db) {
        statusArray = [NSMutableArray array];
        FMResultSet *rs = nil;
        rs = [db executeQuery:@"select * from t_user"];
        
        while (rs.next) {
            QCAdminModel *user = [[QCAdminModel alloc] init];
            user.userID = [rs stringForColumn:@"userID"];
            user.passWord = [rs stringForColumn:@"passWord"];
            user.icon = [NSKeyedUnarchiver unarchiveObjectWithData:[rs dataForColumn:@"icon"]];
            user.nickName = [rs stringForColumn:@"nickName"];
            user.sex = [rs stringForColumn:@"sex"];
            user.permission = [rs stringForColumn:@"permission"];
            user.area = [rs stringForColumn:@"area"];
            [statusArray addObject:user];
        }
    }];
    [queue close];
    return statusArray;
}




#pragma - mark add and read CP_DATA
//  增加多条字典数据
- (void)addChargePileDatas:(NSString *)dbName sqlCmd:(NSString *)sqlCmd array:(NSArray *)dictArray
{
    
    NSArray *arr = [self getAllChargePileData:dbName];//取出所有的model
    
    if (arr.count == 0) {//若数据库为空
          
        for (QCPileListModel *model in dictArray) {

         [self addChargePileData:dbName sqlCmd:sqlCmd dict:[model mj_keyValues]];//直接插入数据库
        }
    }else{

        for (QCPileListModel *model in dictArray) {//遍历数组
            BOOL rs = NO;
            for (QCPileListModel *DBModel in arr) {//遍历数据库
                if ([DBModel.cpid isEqualToString:model.cpid]) {//当数据库中桩已经存在
                    rs = YES;//标记
                }
            }
            
            if (rs == YES) {
                //修改数据库中的桩
                [self UpDatePileListData:dbName NewModel:[model mj_keyValues]];
            }
            else{
                
                [self addChargePileData:dbName sqlCmd:sqlCmd dict:[model mj_keyValues]];
            }
        }
    }
}
- (void)addChargePileData:(NSString *)dbName sqlCmd:(NSString *)sqlCmd dict:(NSDictionary *)dict
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:dbName];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:path];
    [queue inDatabase:^(FMDatabase *db) {
        
    
//        插入语句
        [db executeUpdate:@"insert into t_PileList (cpid,address,province,city,area,totalquantity,totalfee,todayquantity,todayfee,lastquantity,lastfee,faulttype,rmname,rmphone,faultReason,alarmtime,pileState) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",dict[@"cpid"],dict[@"address"],dict[@"province"],dict[@"city"],dict[@"area"],dict[@"totalquantity"],dict[@"totalfee"],dict[@"todayquantity"],dict[@"todayfee"],dict[@"lastquantity"],dict[@"lastfee"],dict[@"faulttype"],dict[@"rmname"],dict[@"rmphone"],dict[@"faultReason"],dict[@"alarmtime"],dict[@"pileState"]];
    }];
    [queue close];
}

//查
-(NSArray *)getChargePileData:(NSString *)dbName withPileState:(NSString *)pileState{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:dbName];
    NSLog(@"%@",path);

    NSString *sql = [NSString stringWithFormat:@"select * from t_PileList where pileState = %@",pileState];
    
    return [self getChargePileData:dbName withSqlite:sql];
}


- (NSArray *)getChargePileData:(NSString *)dbName withSqlite:(NSString *)sql{

     NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:dbName];

    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:path];
    __block NSMutableArray *statusArray = nil;
    statusArray = [NSMutableArray array];
    [queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = nil;
        
        rs = [db executeQuery:sql];
        
        while (rs.next) {
            
            QCPileListModel *model = [[QCPileListModel alloc] init];
            model.cpid = [rs stringForColumn:@"cpid"];
            model.alarmtime = [rs stringForColumn:@"alarmtime"];
            
            
            model.province = [rs stringForColumn:@"province"];
            model.city = [rs stringForColumn:@"city"];
            model.area = [rs stringForColumn:@"area"];
            model.address = [rs  stringForColumn:@"address"];
            
            
            model.rmphone = [rs stringForColumn:@"rmphone"];
            model.rmname = [rs stringForColumn:@"rmname"];
            
            model.faulttype = [[rs stringForColumn:@"faulttype"] integerValue];
            model.faultReason = [rs stringForColumn:@"faultReason"];
            
            
            model.todayfee = [[rs stringForColumn:@"todayfee"] integerValue];
            model.todayquantity = [[rs stringForColumn:@"todayquantity"] integerValue];
            model.lastfee = [[rs stringForColumn:@"lastfee"] integerValue];
            model.lastquantity = [[rs stringForColumn:@"lastquantity"] integerValue];
            model.totalquantity = [[rs stringForColumn:@"totalquantity"] integerValue];
            model.totalfee = [[rs stringForColumn:@"totalfee"] integerValue];
            
            model.pileState = [rs  stringForColumn:@"pileState"];
            [statusArray addObject:model];
        }
    }];
    [queue close];

    
    NSArray *array = [statusArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        QCPileListModel *model1 = (QCPileListModel *)obj1;
        QCPileListModel *model2 = (QCPileListModel *)obj2;
         return model1.cpid > model2.cpid ? 1 : 0;
    }];
    
    return array;
}



-(NSArray *)getAllChargePileData:(NSString *)dbName{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:dbName];
    NSLog(@"%@",path);
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:path];
    __block NSMutableArray *statusArray = nil;
    
    [queue inDatabase:^(FMDatabase *db) {
        statusArray = [NSMutableArray array];
        FMResultSet *rs = nil;
        rs = [db executeQuery:@"select * from t_PileList"];
        while (rs.next) {
            
            QCPileListModel *model = [[QCPileListModel alloc] init];
            model.cpid = [rs stringForColumn:@"cpid"];
            model.alarmtime = [rs stringForColumn:@"alarmtime"];
            
            
            model.province = [rs stringForColumn:@"province"];
            model.city = [rs stringForColumn:@"city"];
            model.area = [rs stringForColumn:@"area"];
            model.address = [rs  stringForColumn:@"address"];
            
            
            model.rmphone = [rs stringForColumn:@"rmphone"];
            model.rmname = [rs stringForColumn:@"rmname"];
            
            model.faulttype = [[rs stringForColumn:@"faulttype"] integerValue];
            model.faultReason = [rs stringForColumn:@"faultReason"];
            
            
            model.todayfee = [[rs stringForColumn:@"todayfee"] integerValue];
            model.todayquantity = [[rs stringForColumn:@"todayquantity"] integerValue];
            model.lastfee = [[rs stringForColumn:@"lastfee"] integerValue];
            model.lastquantity = [[rs stringForColumn:@"lastquantity"] integerValue];
            model.totalquantity = [[rs stringForColumn:@"totalquantity"] integerValue];
            model.totalfee = [[rs stringForColumn:@"totalfee"] integerValue];
            
            model.pileState = [rs  stringForColumn:@"pileState"];
            [statusArray addObject:model];
        }
    }];
    [queue close];
    
    NSArray *arr = [NSArray array];
    arr = [statusArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        QCPileListModel *model = (QCPileListModel *)obj1;
        QCPileListModel *model2 = (QCPileListModel *)obj2;
        return model.cpid>model2.cpid?1:0;
    }];
    
    return arr;
}


//修改数据

- (void)UpDatePileListData:(NSString *)dbName NewModel:(NSDictionary *)dic{
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:dbName];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:path];
    [queue inDatabase:^(FMDatabase *db) {
       
        FMResultSet *rs = nil;
        rs = [db executeQuery:@"select * from t_PileList where cpid = ?",dic[@"cpid"]];
        
        while (rs.next) {
            
         [db executeUpdate:@"update t_PileList set address = ?,province = ?,city = ?,area = ?,totalquantity = ?,totalfee = ?,todayquantity = ?,todayfee = ?,lastquantity= ?,lastfee = ?,faulttype = ?,rmname = ?,rmphone = ?,faultReason = ?,alarmtime = ?,pileState = ? where cpid = ?",dic[@"address"],dic[@"province"],dic[@"city"],dic[@"area"],dic[@"totalquantity"],dic[@"totalfee"],dic[@"todayquantity"],dic[@"todayfee"],dic[@"lastquantity"],dic[@"lastfee"],dic[@"faulttype"],dic[@"rmname"],dic[@"rmphone"],dic[@"faultReason"],dic[@"alarmtime"],dic[@"pileState"],dic[@"cpid"]];
        }
    }];
    [queue close];

    
}
//删除所有的数据
- (BOOL)deleteAllDataFromDB:(NSString *)dbName{
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:dbName];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    __block BOOL success;
    [queue inDatabase:^(FMDatabase *db) {

      success =  [db executeUpdate:@"delete from  t_PileList "];
    }];
     
    [queue close];
    return success;
}



@end
