//
//  XDSChartCell.h
//  XDSChart
//
//  Created by zhengda on 15/5/11.
//  Copyright (c) 2015年 zhengda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XDSChartView.h"
@interface XDSChartCell : UITableViewCell

- (void)cellWithChartDataArray:(NSArray *)chartDataArray style:(XDSChartStyle)style;

@end
