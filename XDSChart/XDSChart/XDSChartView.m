//
//  XDSChartView.m
//  XDSChart
//
//  Created by zhengda on 15/5/12.
//  Copyright (c) 2015年 zhengda. All rights reserved.
//

#import "XDSChartView.h"

#define chartMargin     10
#define kYLabelHeight    10
#define kYLabelWidth   30
#define kXLabelHeight     15
#define kMinPointAndButtomLineMargin(max, min)  10*(self.frame.size.width - 20)/(max - min)

#define kTopMargin 15
#define kRightMargin 20
#define kLabelFont [UIFont systemFontOfSize:12.0f]

#define kGreen        [UIColor colorWithRed:77.0/255.0 green:186.0/255.0 blue:122.0/255.0 alpha:1.0f]
#define kRed          [UIColor colorWithRed:245.0/255.0 green:94.0/255.0 blue:78.0/255.0 alpha:1.0f]
#define kBrown        [UIColor colorWithRed:119.0/255.0 green:107.0/255.0 blue:95.0/255.0 alpha:1.0f]
#define kBlue         [UIColor colorWithRed:82.0/255.0 green:116.0/255.0 blue:188.0/255.0 alpha:1.0f]
#define kStarYellow   [UIColor colorWithRed:252.0/255.0 green:223.0/255.0 blue:101.0/255.0 alpha:1.0f]
@interface XDSChartView()

@property (strong, nonatomic) NSArray * chartDataArray;//存放数据，其中折线为二位数组，柱状图为一位数组
@property (assign, nonatomic) XDSChartStyle chartStyle;//表的类型，默认是线形
@property (strong, nonatomic) NSArray * colorArray;

@end

@implementation XDSChartView

- (instancetype)initWithFrame:(CGRect)frame style:(XDSChartStyle)style chartDataArray:(NSArray *)chartDataArray{
    if (self = [super initWithFrame:frame]) {
        self.colorArray = [[NSArray alloc]initWithObjects:kRed, kGreen, kBrown,nil];
        
        self.chartStyle = style;
        self.chartDataArray = chartDataArray;
        if (style == XDSChartLineStyle) {//线形图
            for (id obj in chartDataArray) {
                NSAssert([obj isKindOfClass:[NSArray class]], @"线形图的数据必须为二维数组");
            }
            [self drawGridViewWithLines:chartDataArray];
        }else if (style == XDSChartBarStyle){//柱状图
            for (id obj in chartDataArray) {
                NSAssert([obj isKindOfClass:[XDSChartModel class]], @"柱状图的数据必须为一维数组，数组元素为XDSChartModel类");
            }
            [self drawGridViewWithBars:chartDataArray];
        }
    }
    return self;
}

#pragma mark 线形图
#pragma mark 画网格及坐标
- (void)drawGridViewWithLines:(NSArray *)lines{
    CGFloat levelHeight = (self.frame.size.height - kXLabelHeight - kTopMargin)/5;
    CGFloat verticalWidth = (self.frame.size.width - kYLabelWidth - kRightMargin)/[lines[0] count];
    CGFloat xMaxValue = [self xMaxValue:lines];
    CGFloat xMinValue = [self xMinValue:lines];
    CGFloat yMaxValue = [self yMaxValue:lines];
    CGFloat yMinValue = [self yMinValue:lines];
    NSLog(@"%f = %f = %f = %f", xMaxValue, xMinValue, yMaxValue, yMinValue);
    for (int i = 0; i < 6; i ++) {//画表格横线
        CGFloat yLabelMaxValue = yMaxValue + kMinPointAndButtomLineMargin(yMaxValue, yMinValue);
        CGFloat yLabelMinValue = yMinValue - kMinPointAndButtomLineMargin(yMaxValue, yMinValue);
        CGFloat yAverageValue = (yLabelMaxValue - yLabelMinValue)/5;
        CGFloat yLabelValue = yLabelMaxValue - yAverageValue*i;
        UILabel * yLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, kTopMargin - kYLabelHeight/2 + levelHeight * i, kYLabelWidth, kYLabelHeight)];
        yLabel.text = [NSString stringWithFormat:@"%.0f-", yLabelValue];
        yLabel.font = kLabelFont;
        yLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:yLabel];
        
        CAShapeLayer * shapeLayer = [CAShapeLayer layer];
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(kYLabelWidth, kTopMargin + levelHeight * i)];
        [path addLineToPoint:CGPointMake(self.frame.size.width - kRightMargin, kTopMargin + levelHeight * i)];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [UIColor blackColor].CGColor;
        shapeLayer.lineWidth = 0.7f;
        [self.layer addSublayer:shapeLayer];
    }
    
    CGFloat xLabelWidth = (self.frame.size.width - kYLabelWidth - kRightMargin)/[lines[0] count];
    for (int i = 0; i < [lines[0] count] + 1; i ++) {//画表格竖线
        if (i) {
            UILabel * yLabel = [[UILabel alloc]initWithFrame:CGRectMake(kYLabelWidth - xLabelWidth/2 + verticalWidth * i, self.frame.size.height - kXLabelHeight, xLabelWidth, kXLabelHeight)];
            yLabel.text = [NSString stringWithFormat:@"%d", i];
            yLabel.font = kLabelFont;
            yLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:yLabel];
        }
        CAShapeLayer * shapeLayer = [CAShapeLayer layer];
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(kYLabelWidth + verticalWidth * i, kTopMargin)];
        [path addLineToPoint:CGPointMake(kYLabelWidth + verticalWidth * i, self.frame.size.height - kXLabelHeight)];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [UIColor blackColor].CGColor;
        shapeLayer.lineWidth = 0.7f;
        [self.layer addSublayer:shapeLayer];
    }
    [self drawLinesWithLines:lines levelHeight:levelHeight verticalWidth:verticalWidth yMaxValue:yMaxValue yMinValue:yMinValue];//画线形图
}
#pragma mark 画线形图
- (void)drawLinesWithLines:(NSArray *)lines levelHeight:(CGFloat)levelHeight verticalWidth:(CGFloat)verticalWidth yMaxValue:(CGFloat)yMaxValue yMinValue:(CGFloat)yMinValue{
    for (int i = 0; i < lines.count; i ++) {
        NSArray * line = lines[i];
        int colorIndex = i%self.colorArray.count;
        CAShapeLayer * shapeLayer = [CAShapeLayer layer];
        UIColor * color = (UIColor *)self.colorArray[colorIndex];
        shapeLayer.strokeColor = color.CGColor;
        shapeLayer.lineWidth = 2.0f;
        [self.layer addSublayer:shapeLayer];

        UIBezierPath * path = [UIBezierPath bezierPath];
        CGPoint moveToPoint = CGPointZero;
        CGPoint addLineToPoint = CGPointZero;
        for (int j = 0; j < line.count; j ++) {//画表格竖线
            XDSChartModel * model = line[j];//画线起点
            CGFloat point_x = kYLabelWidth + verticalWidth/2.0f + j * verticalWidth;
            CGFloat point_y = self.frame.size.height - kXLabelHeight - 10 - (self.frame.size.height - 20.0f - kXLabelHeight - kTopMargin)/(yMaxValue - yMinValue) * (model.point_y - yMinValue);
            if (!j) {
                moveToPoint = CGPointMake(point_x, point_y);
                [self drawCircleViewWithCenterPoint:moveToPoint color:color];//画第一个圆点
            }else{
                addLineToPoint = CGPointMake(point_x, point_y);
                [path moveToPoint:moveToPoint];
                [path addLineToPoint:addLineToPoint];
                moveToPoint = addLineToPoint;
                [self drawCircleViewWithCenterPoint:moveToPoint color:color];
            }
        }
        
        shapeLayer.path = path.CGPath;
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];//动画类型，strokeEnd为先画后显示，strokeStart为先显示后擦除
        pathAnimation.duration = line.count*0.4;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnimation.autoreverses = NO;
        [shapeLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        shapeLayer.strokeEnd = 1.0;//0~1的值，0表示画完以后回到起点，1表示画完以后留在结束的位置
    }
}

- (void)drawCircleViewWithCenterPoint:(CGPoint)center color:(UIColor *)color{
    UIView * circle = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 8.0f, 8.0f)];
    circle.center = center;
    circle.layer.masksToBounds = YES;
    circle.layer.cornerRadius = 4.0f;
    circle.layer.borderWidth = 2.0f;
    circle.layer.borderColor = color.CGColor;
    circle.backgroundColor = [UIColor whiteColor];
    [self addSubview:circle];
}
#pragma mark - 柱状图
#pragma mark  画网格及坐标
- (void)drawGridViewWithBars:(NSArray *)bars{
    
}
#pragma mark 画柱状图
- (void)drawBarWithBars:(NSArray *)bars{
    
}


- (CGFloat)xMaxValue:(NSArray *)xValues{
    CGFloat xmax = ((XDSChartModel *)xValues[0][0]).point_x;
    for (NSArray * values in xValues) {
        for (XDSChartModel * model in values) {
            xmax = (xmax  > model.point_x)?xmax:model.point_x;
        }
    }
    return xmax;
}
- (CGFloat)xMinValue:(NSArray *)xValues{
    CGFloat xmin = ((XDSChartModel *)xValues[0][0]).point_x;
    for (NSArray * values in xValues) {
        for (XDSChartModel * model in values) {
            xmin = (xmin  < model.point_x)?xmin:model.point_x;
        }
    }
    return xmin;
}
- (CGFloat)yMaxValue:(NSArray *)yValues{
    CGFloat ymax = ((XDSChartModel *)yValues[0][0]).point_y;
    for (NSArray * values in yValues) {
        for (XDSChartModel * model in values) {
            ymax = (ymax  > model.point_y)?ymax:model.point_y;
        }
    }
    return ymax;
    
}
- (CGFloat)yMinValue:(NSArray *)yValues{
    CGFloat ymin = ((XDSChartModel *)yValues[0][0]).point_y;;
    for (NSArray * values in yValues) {
        for (XDSChartModel * model in values) {
            ymin = (ymin  < model.point_y)?ymin:model.point_y;
        }
    }
    return ymin;
}
@end
