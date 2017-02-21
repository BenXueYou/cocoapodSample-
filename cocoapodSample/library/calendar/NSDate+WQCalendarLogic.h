//
//  NSDate+WQCalendarLogic.h
//  DKCalendar
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 deike. All rights reserved.


#import <Foundation/Foundation.h>

@interface NSDate (WQCalendarLogic)

- (NSUInteger)numberOfDaysInCurrentMonth;///*计算这个月有多少天*/

- (NSUInteger)numberOfWeeksInCurrentMonth;////获取这个月有多少周

- (NSUInteger)weeklyOrdinality;///*计算这个月的第一天是礼拜几*/

- (NSDate *)firstDayOfCurrentMonth;////计算这个月最开始的一天

- (NSDate *)lastDayOfCurrentMonth;////计算这个月最后一天

- (NSDate *)dayInThePreviousMonth;////上一个月

- (NSDate *)dayInTheFollowingMonth;////下一个月

- (NSDate *)dayInTheFollowingMonth:(int)month;//获取当前日期之后的几个月

- (NSDate *)dayInTheFollowingDay:(int)day;//获取当前日期之后的几个天

- (NSDateComponents *)YMDComponents;//获取年月日对象

- (NSDate *)dateFromString:(NSString *)dateString;//NSString转NSDate

- (NSString *)stringFromDate:(NSDate *)date;//NSDate转NSString

+ (int)getDayNumbertoDay:(NSDate *)today beforDay:(NSDate *)beforday;////两个日历之间相差多少月//

-(int)getWeekIntValueWithDate;

@property (nonatomic, assign) NSUInteger num;

//判断日期是今天,明天,后天,周几
-(NSString *)compareIfTodayWithDate;
//通过数字返回星期几
+(NSString *)getWeekStringFromInteger:(int)week;

@end
