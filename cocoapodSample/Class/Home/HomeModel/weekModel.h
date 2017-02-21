//
//  weekModel.h
//  testWeekCalendar
//
//  Created by cnc on 16/9/8.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface weekModel : NSObject
@property (nonatomic,assign) NSInteger weekCount;
@property (nonatomic,strong) NSString *beginDate;
@property (nonatomic,strong) NSString *endDate;

@property (nonatomic,assign) NSInteger year;
@property (nonatomic,assign) NSInteger month;
@property (nonatomic,assign) NSInteger day;
@end
