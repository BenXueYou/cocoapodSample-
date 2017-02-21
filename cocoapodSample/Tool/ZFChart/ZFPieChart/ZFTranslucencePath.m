//
//  ZFTranslucencePath.m
//  ZFChartView
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFTranslucencePath.h"

@implementation ZFTranslucencePath

+ (instancetype)layerWithArcCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise{
    return [[ZFTranslucencePath alloc] initWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
}

- (instancetype)initWithArcCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise{
    self = [super init];
    if (self) {
        self.fillColor = nil;
        self.opacity = 0.5f;
        self.path = [self translucencePathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise].CGPath;
    }
    return self;
}

- (UIBezierPath *)translucencePathWithArcCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise{
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
    return bezierPath;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com