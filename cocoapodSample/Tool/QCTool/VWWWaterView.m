//
//  VWWWaterView.m
//  Water Waves
//
//  Created by Veari_mac02 on 14-5-23.
//  Copyright (c) 2014年 Veari. All rights reserved.
//

#import "VWWWaterView.h"

@interface VWWWaterView ()
{
    UIColor *_currentWaterColor;//颜色
    
    float _currentLinePointY;//Y值
    
    float a;
    float b;
    
    BOOL jia;
}
@end


@implementation VWWWaterView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        a = 1.5;
        b = 0;
        jia = NO;
        
        _currentWaterColor = [UIColor colorWithRed:86/255.0f green:202/255.0f blue:139/255.0f alpha:1];
        _currentLinePointY = 80;
        
        [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(animateWave) userInfo:nil repeats:YES];
        
    }
    return self;
}

-(void)animateWave
{
    if (jia) {
        a += 0.01;
    }else{
        a -= 0.01;
    }
    
    
    if (a<=1) {
        jia = YES;
    }
    
    if (a>=1.5) {
        jia = NO;
    }
    
    
    b+=0.1;
    
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
//    创建对象，获取当前上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    //画水
    CGContextSetLineWidth(context, 1);
    CGContextSetFillColorWithColor(context, [_currentWaterColor CGColor]);
    
//    _currentLinePointY = 110;
    
    float y=_currentLinePointY;
    
    CGPathMoveToPoint(path, NULL, 0, y);
    
//    根据正弦函数画波
    for(float x=0;x<=320;x++){
        y= a * sin( x/180*M_PI + 4*b/M_PI ) * 5 + _currentLinePointY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, 320, rect.size.height);
    CGPathAddLineToPoint(path, nil, 0, rect.size.height);
    CGPathAddLineToPoint(path, nil, 0, _currentLinePointY);
    
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);

}


@end