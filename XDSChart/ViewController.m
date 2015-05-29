//
//  ViewController.m
//  XDSChart
//
//  Created by zhengda on 15/5/11.
//  Copyright (c) 2015年 zhengda. All rights reserved.
//

#import "ViewController.h"
#import "XDSChartCell.h"
@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray * _chartDataArray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewControllerDataInit];
    NSLog(@"_chartDataArray = %@", _chartDataArray);
}


#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _chartDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XDSChartCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[XDSChartCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSArray * linesData = _chartDataArray[indexPath.row];
    [cell cellWithChartDataArray:linesData style:XDSChartLineStyle];
    return cell;
}
#pragma mark - 初始化数据
- (void)viewControllerDataInit{
    NSInteger cellCount = 10;
    _chartDataArray = [[NSMutableArray alloc]initWithCapacity:cellCount];
    for (int i = 0; i < cellCount; i ++) {
        int lineCount = arc4random()%3 + 1;//1-3的随机数
        int pointCount = arc4random()%10 + 5;//线上的点数  10-20个点
        NSMutableArray * lineArray = [NSMutableArray arrayWithCapacity:lineCount];
        for (int j = 0; j < lineCount; j ++) {
            NSMutableArray * pointArray = [NSMutableArray arrayWithCapacity:pointCount];
            for (int k = 0; k < pointCount; k ++) {
                XDSChartModel * model = [[XDSChartModel alloc]init];
                model.point_x = k; //
                model.point_y = arc4random()%80 + 10; //
                [pointArray addObject:model];
            }
            [lineArray addObject:pointArray];
        }
        [_chartDataArray addObject:lineArray];
    }
}
@end
