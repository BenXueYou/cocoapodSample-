//
//  Header.h
//  cocoapodSample
//
//  Created by cnc on 16/8/17.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#ifndef Header_h
#define Header_h

#import <UIKit/UIKit.h>

//接口文档
//////////////////////////////////////////////////////

//#define CPMAPI_PREFIX                   @"http://192.168.8.132:8080/ServerForOper01/"
#define CPMAPI_PREFIX                   @"http://116.236.237.244:8080/ServerForOper01/"
#define CPMAPI_PILE_LIST                @"chargePile/cpInfo"
#define CPMAPI_PILE_DETAIL              @"chargePile/cpChargeRealTime"
#define CPMAPI_PILE_DATA                @"chargePile/cpData"
#define CPMAPI_USER_LOGIN               @"user/userLogin"
#define CPMAPI_CHARGE_HISTORY            @"cpUser/chargeRecord"
#define CPMAPI_FAULT_HISTORY            @"alarm/alarmReason"

/////////////////////////////////////////////////////


#define kFBaseWidth [[UIScreen mainScreen]bounds].size.width
#define kFBaseHeight [[UIScreen mainScreen]bounds].size.height
#define kFBaseHeightNoStatus (kFBaseHeight-kFBaseStatusHeight)



#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define IS_IOS_7 [[[UIDevice currentDevice] systemVersion] intValue] >= 7?YES:NO

#define IS_NULL_ARRAY(arr) (arr == nil || (NSObject *)arr == [NSNull null] || arr.count == 0 )
#define IS_NULL(obj) (obj == nil || (NSObject *)obj == [NSNull null])
#define IS_NULL_STRING(str) (str == nil || (NSObject *)str == [NSNull null] || [str stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0)

#define IS_IPHONE_4     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )
#define IS_IPHONE_5     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_6     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )667 ) < DBL_EPSILON )
#define IS_IPHONE_6P    ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )736 ) < DBL_EPSILON )

#define StringFromNumber(num) [NSString stringWithFormat:@"%ld", (long)num]
#define StringFromFloat(num) [NSString stringWithFormat:@"%.2f", num]

//系统版本判断宏
//#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#define IOS8_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )
#define IOS7_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define IOS6_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending )
#define IOS5_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"5.0"] != NSOrderedAscending )
#define IOS4_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"4.0"] != NSOrderedAscending )
#define IOS3_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"3.0"] != NSOrderedAscending )

#define IOS7_OR_EARLIER		( !IOS8_OR_LATER )
#define IOS6_OR_EARLIER		( !IOS7_OR_LATER )
#define IOS5_OR_EARLIER		( !IOS6_OR_LATER )
#define IOS4_OR_EARLIER		( !IOS5_OR_LATER )
#define IOS3_OR_EARLIER		( !IOS4_OR_LATER )

// 7.获取屏幕 宽度、高度
#define SCREEN_FRAME ([UIScreen mainScreen].applicationFrame)
#define STATUS_FRAME ([[UIApplication sharedApplication] statusBarFrame])
#define STATUS_WIDTH ([[UIApplication sharedApplication] statusBarFrame].size.width)
#define STATUS_HEIGHT ([[UIApplication sharedApplication] statusBarFrame].size.height)

// 8.判断设备型号
#define kFBaseWidth [[UIScreen mainScreen]bounds].size.width
#define kFBaseHeight [[UIScreen mainScreen]bounds].size.height
#define kFBaseHeightNoStatus (kFBaseHeight-kFBaseStatusHeight)
//没有状态条和导航栏的高度
#define kFBaseHeightNoStatusNoNav (kFBaseHeight-kFBaseStatusHeight - kFBaseNavHeight)
#define kFBaseHeightNoStatusNoNavNoTab (kFBaseHeight-kFBaseStatusHeight - kFBaseNavHeight -kFBaseTabBarHeight)
#define kIsIphone4Screen ([M2DeviceHelper isIphone4Screen])
#define kIsIphone5Screen ([M2DeviceHelper isIphone5Screen])
#define kIsIphone6Screen ([M2DeviceHelper isIphone6Screen])
#define kIsIphone6PlusScreen ([M2DeviceHelper isIphone6PlusScreen])
#define kIsIphoneSeries ([M2DeviceHelper isIphoneSeries])
#define kIsIpadSeries ([M2DeviceHelper isIpadSeries])



#define IS_IOS_7 [[[UIDevice currentDevice] systemVersion] intValue] >= 7?YES:NO

#define IS_NULL_ARRAY(arr) (arr == nil || (NSObject *)arr == [NSNull null] || arr.count == 0 )
#define IS_NULL(obj) (obj == nil || (NSObject *)obj == [NSNull null])
#define IS_NULL_STRING(str) (str == nil || (NSObject *)str == [NSNull null] || [str stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0)

#define Localized(str) NSLocalizedString(str, nil)


#define XYCOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


// 5.定义UI显示间隔
/** cell的边框宽度 */
#define QCStatusCellBorder 5
/** 间距 */
#define PADDING 5
/** view内部的边框宽度 */
#define QCDetailViewBorder 5
/** 来源的字体 */
#define QCSubTitleFont [UIFont systemFontOfSize:12]
/** 正文的字体 */
#define QCTitleFont [UIFont systemFontOfSize:18]

#define WEAK_SELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#import "UIImage+adaptive_iOS7.h"
#import "UIColor+hex.h"
#import "Chameleon.h"
#import "Masonry.h"
#import "M2DeviceHelper.h"
#import "GlobalClass.h"
#endif /* Header_h */
