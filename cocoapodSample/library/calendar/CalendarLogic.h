//
//  CalendarLogic.h
//  DKCalendar
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 deike. All rights reserved.

#import <Foundation/Foundation.h>
#import "CalendarDayModel.h"
#import "NSDate+WQCalendarLogic.h"

typedef void (^NSDateWQBlock) (NSDate *WQNSdate);
@interface CalendarLogic : NSObject
//计算当前日期之前几天或者是之后的几天（负数是之前几天，正数是之后的几天）
- (NSMutableArray *)reloadCalendarView:(NSDate *)date  selectDate:(NSDate *)date1 needDays:(int)days_number;

- (void)selectLogic:(CalendarDayModel *)day;

@property (nonatomic, copy) NSDateWQBlock  dateBlock;
@end
