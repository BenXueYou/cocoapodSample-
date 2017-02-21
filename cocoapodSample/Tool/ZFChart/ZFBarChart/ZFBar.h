//
//  ZFBar.h
//  ZFChart
//
//  Created by apple on 16/1/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFBar : UIView

/** bar颜色 */
@property (nonatomic, strong) UIColor * barBackgroundColor;
/** 百分比小数 */
@property (nonatomic, assign) CGFloat percent;
/** 是否带阴影效果(默认为YES) */
@property (nonatomic, assign) BOOL isShadow;

//#warning message - readonly（只读）

/** bar终点Y值 */
@property (nonatomic, assign, readonly) CGFloat endYPos;

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com