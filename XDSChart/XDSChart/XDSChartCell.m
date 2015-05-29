//
//  XDSChartCell.m
//  XDSChart
//
//  Created by zhengda on 15/5/11.
//  Copyright (c) 2015年 zhengda. All rights reserved.
//

#import "XDSChartCell.h"
#import "XDSChartView.h"
@implementation XDSChartCell

- (void)cellWithChartDataArray:(NSArray *)chartDataArray style:(XDSChartStyle)style{
    self.contentView.backgroundColor = [UIColor clearColor];
    NSArray * subView = self.contentView.subviews;
    for (UIView * view in subView) {
        [view removeFromSuperview];
    }
    XDSChartView * chart = [[XDSChartView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 150.0f) style:style chartDataArray:chartDataArray];
    [self.contentView addSubview:chart];
}

@end
