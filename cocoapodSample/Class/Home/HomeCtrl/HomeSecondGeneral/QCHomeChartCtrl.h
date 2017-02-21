//
//  QCHomeChartCtrl.h
//  cocoapodSample
//
//  Created by cnc on 16/8/27.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    kChartTypeBarChart = 0,
    kChartTypeLineChart = 1,
    kChartTypePieChart = 2
}kChartType;
@interface QCHomeChartCtrl : UIViewController
@property (nonatomic, assign) kChartType chartType;
@end
