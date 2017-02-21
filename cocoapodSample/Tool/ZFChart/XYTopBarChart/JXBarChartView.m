//
//  JXBarChartView.m
//  JXBarChartViewExample
//
//  Created by jianpx on 7/18/13.
//  Copyright (c) 2013 PS. All rights reserved.
//

#import "JXBarChartView.h"

@interface JXBarChartView()
@property (nonatomic) CGContextRef context;
@property (nonatomic, strong) NSMutableArray *textIndicatorsLabels;
@property (nonatomic, strong) NSMutableArray *digitIndicatorsLabels;
@property (nonatomic, strong) UILabel *chartTitleLabel;
@property (nonatomic, assign) int index;
@end

@implementation JXBarChartView


- (id)initWithFrame:(CGRect)frame
         startPoint:(CGPoint)startPoint
             values:(NSMutableArray *)values
           maxValue:(float)maxValue
     textIndicators:(NSMutableArray *)textIndicators
          textColor:(UIColor *)textColor
          barHeight:(float)barHeight
        barMaxWidth:(float)barMaxWidth
           gradient:(CGGradientRef)gradient
{
    self = [super initWithFrame:frame];
    if (self) {
        _values = values;
        _maxValue = maxValue;
        _textIndicatorsLabels = [[NSMutableArray alloc] initWithCapacity:[values count]];
        _digitIndicatorsLabels = [[NSMutableArray alloc] initWithCapacity:[values count]];
        _textIndicators = textIndicators;
        _startPoint = startPoint;
        _textColor = textColor ? textColor : [UIColor orangeColor];
        _barHeight = barHeight;
        _barMaxWidth = barMaxWidth;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        //blue gradient
        CGFloat locations[] = {0.0, 0.5, 1.0};
        CGFloat colorComponents1[] = {
            0.154, 0.609, 0.94, 1.0, //red, green, blue, alpha
            0.092, 0.575, 0.88, 1.0,
            0.056, 0.515, 0.856, 1.0
        };
        
        
        self.index = 0;
        size_t count = 3;
        CGGradientRef defaultGradient = CGGradientCreateWithColorComponents(colorSpace, colorComponents1, locations, count);
        _gradient = gradient ?  gradient : defaultGradient;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)setLabelDefaults:(UIButton *)button
{
    button.tintColor = self.textColor;
  
    [button sizeToFit];
    button.titleLabel.font = [UIFont systemFontOfSize:10];
    //label.adjustsLetterSpacingToFitWidth = YES;
    button.backgroundColor = [UIColor clearColor];
}

- (void)setLabelDefault:(UILabel *)label
{
    label.textColor = self.textColor;
    label.textAlignment = NSTextAlignmentLeft;
    label.adjustsFontSizeToFitWidth = YES;
    //label.adjustsLetterSpacingToFitWidth = YES;
    label.backgroundColor = [UIColor clearColor];
}


- (void)drawRectangle:(CGRect)rect context:(CGContextRef)context
{
    
    CGContextSaveGState(self.context);//获取当前上下文
    CGContextAddRect(self.context, rect);//添加上下文
    CGContextClipToRect(self.context, rect);
    CGPoint startPoint = CGPointMake(rect.origin.x, rect.origin.y);
    CGPoint endPoint = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
    
    if (self.index <= 5) {
       CGContextDrawLinearGradient(self.context, self.gradient, startPoint, endPoint, 0);
    }
    else{
        
        CGFloat  colorComponents2[] = {
            0.954, 0.309, 0.14, 1.0, //red, green, blue, alpha
            0.892, 0.275, 0.08, 1.0,
            0.766, 0.115, 0.006, 1.0
        };
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        //blue gradient
        CGFloat locations[] = {0.0, 0.5, 1.0};
        size_t count = 3;
        CGGradientRef defaultGradient = CGGradientCreateWithColorComponents(colorSpace, colorComponents2, locations, count);

        _gradient = defaultGradient;
        CGContextDrawLinearGradient(self.context, _gradient, startPoint, endPoint, 0);

    }
    
    CGContextRestoreGState(self.context);
}

- (void)drawRect:(CGRect)rect
{
    self.context = UIGraphicsGetCurrentContext();
    NSInteger count = [self.values count];
    float startx = self.startPoint.x;
    float starty = self.startPoint.y;
    float barMargin = 10;//间隔
    float marginOfBarAndDigit = 2;//文本与柱状图的距离
    float marginOfTextAndBar = 8;//标签与柱状图的距离
    float digitWidth = 15;//数字的宽度
    float textWidth = 30;//文本框的宽度
    for (int i = 0; i < count; i++) {
        //handle textlabel
        
        NSLog(@"=======%ld,+++++%d",(long)count,i);
        
        float textMargin_y = (i * (self.barHeight + barMargin)) + starty;
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        button.frame = CGRectMake(startx - 15, textMargin_y, textWidth, self.barHeight);
        button.tag = 90000 + i;
        
        [button addTarget:self action:@selector(buttonStep:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [button setTitle:self.textIndicators[i] forState:(UIControlStateNormal)];
        
        [self setLabelDefaults:button];//设置文本框的样式
        @try {
            UILabel *originalTextLabel = self.textIndicatorsLabels[i];
            if (originalTextLabel) {
                [originalTextLabel removeFromSuperview];
            }
        }
        @catch (NSException *exception) {
            [self.textIndicatorsLabels insertObject:button atIndex:i];
        }
        [self addSubview:button];
        
        //handle bar
        float barMargin_y = (i * (self.barHeight + barMargin)) + starty;
        float v = [self.values[i] floatValue] <= self.maxValue ? [self.values[i] floatValue]: self.maxValue;
        float rate = v / self.maxValue;
        float barWidth = rate * self.barMaxWidth;
        CGRect barFrame = CGRectMake(startx + textWidth + marginOfTextAndBar, barMargin_y, barWidth, self.barHeight);
        self.index++;
        [self drawRectangle:barFrame context:self.context];//画图
        
        //handle digitlabel
        UILabel *digitLabel = [[UILabel alloc] initWithFrame:CGRectMake(barFrame.origin.x + barFrame.size.width + marginOfBarAndDigit, barFrame.origin.y, digitWidth, barFrame.size.height)];
        digitLabel.text = [NSString stringWithFormat:@"%@",self.values[i]];
        
        [self setLabelDefault:digitLabel];
        
        @try {
            UILabel *originalDigitLabel = self.digitIndicatorsLabels[i];
            if (originalDigitLabel) {
                [originalDigitLabel removeFromSuperview];
            }
        }
        @catch (NSException *exception) {
            [self.digitIndicatorsLabels insertObject:digitLabel atIndex:i];
        }
        [self addSubview:digitLabel];
    }
}



-(void)buttonStep:(UIButton *)button{

    NSInteger index = button.tag - 90000;
    self.block(index);
}

- (void)setValues:(NSMutableArray *)values
{
    for (int i = 0; i < [values count]; i++) {
        _values[i] = values[i];
    }
    [self setNeedsDisplay];
}

@end
