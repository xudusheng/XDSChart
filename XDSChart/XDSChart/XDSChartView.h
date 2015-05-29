//
//  XDSChartView.h
//  XDSChart
//
//  Created by zhengda on 15/5/12.
//  Copyright (c) 2015年 zhengda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDSChartModel.h"

typedef enum {
    XDSChartLineStyle,
    XDSChartBarStyle
} XDSChartStyle;

@interface XDSChartView : UIView


- (instancetype)initWithFrame:(CGRect)frame style:(XDSChartStyle)style chartDataArray:(NSArray *)chartDataArray;

    
@end
