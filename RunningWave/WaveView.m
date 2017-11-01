//
//  WaveView.m
//  RunningWave
//
//  Created by Justec_Mac on 2017/10/31.
//  Copyright © 2017年 JustecMac. All rights reserved.
//

#import "WaveView.h"
#import "SymbolsValueFormatter.h"
#import "DateValueFormatter.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define GlobalColor [UIColor colorWithRed:(7 / 255.0) green:(102 / 255.0) blue:(255 / 255.0) alpha:1]

#define pointCount 100 ///总共点的个数

@interface WaveView ()<ChartViewDelegate>
{
    ChartYAxis *leftAxis;
    NSInteger index;////空白点的索引
}

@property (nonatomic,strong) LineChartView * lineView;//图表

@property (nonatomic,strong)NSMutableArray *colors;//颜色

@property (nonatomic,strong)NSMutableArray *yVals;//对应Y轴上面需要显示的数据

@property (nonatomic,strong)NSMutableArray *allValues;


@end

@implementation WaveView
- (NSMutableArray *)allValues{
    if (!_allValues) {
        self.allValues = [NSMutableArray array];
    }
    return _allValues;
}
- (NSMutableArray *)colors{
    if (!_colors) {
        self.colors = [NSMutableArray array];
    }
    return _colors;
}
- (NSMutableArray *)yVals{
    if (!_yVals) {
        self.yVals = [NSMutableArray array];
    }
    return _yVals;
}

- (LineChartView *)lineView {
    if (!_lineView) {
        self.lineView = [[LineChartView alloc] init];
        self.lineView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
        self.lineView.delegate = self;//设置代理
        self.lineView.backgroundColor =  [UIColor clearColor];
        self.lineView.noDataText = @"";
        self.lineView.noDataFont = [UIFont systemFontOfSize:15];
        self.lineView.chartDescription.enabled = YES;
        self.lineView.scaleYEnabled = NO;//取消Y轴缩放
        self.lineView.doubleTapToZoomEnabled = YES;//取消双击缩放
        self.lineView.dragEnabled = YES;//启用拖拽图标
        self.lineView.dragDecelerationEnabled = YES;//拖拽后是否有惯性效果
        self.lineView.dragDecelerationFrictionCoef = 0.8;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
        
        self.lineView.rightAxis.enabled = NO;//不绘制右边轴
        leftAxis = self.lineView.leftAxis;//获取左边Y轴
        leftAxis.labelCount = 8;//Y轴label数量，数值不一定，如果forceLabelsEnabled等于YES, 则强制绘制制定数量的label, 但是可能不平均
        leftAxis.forceLabelsEnabled = NO;//不强制绘制指定数量的label
        leftAxis.axisMinValue = 0;//设置Y轴的最小值
        leftAxis.axisMaxValue = 260;//设置Y轴的最大值
        leftAxis.inverted = NO;//是否将Y轴进行上下翻转
        leftAxis.axisLineColor = [UIColor clearColor];//Y轴颜色
        leftAxis.valueFormatter = [[SymbolsValueFormatter alloc]init];
        leftAxis.labelPosition = YAxisLabelPositionOutsideChart;//label位置
        leftAxis.labelTextColor = [UIColor clearColor];//文字颜色
        leftAxis.labelFont = [UIFont systemFontOfSize:13.0f];//文字字体
        
        /////Y轴设为透明
        leftAxis.gridColor = [UIColor clearColor];//网格线颜色
        leftAxis.gridAntialiasEnabled = NO;//开启抗锯齿
        leftAxis.gridLineDashLengths =@[@5.0f, @5.0f];
        
        ChartXAxis *xAxis = self.lineView.xAxis;
        xAxis.granularityEnabled = YES;//设置重复的值不显示
        xAxis.labelPosition= XAxisLabelPositionBottom;//设置x轴数据在底部
        xAxis.gridColor = [UIColor clearColor];/////X轴设为透明
        xAxis.labelCount = 5;
        xAxis.labelTextColor = [UIColor clearColor];//文字颜色
        xAxis.axisLineColor = [UIColor clearColor];
        xAxis.labelFont = [UIFont systemFontOfSize:12.0f];
        //        self.lineView.maxVisibleCount = 1441;
        //描述及图例样式
        [self.lineView setDescriptionText:@""];
        self.lineView.legend.enabled = NO;
        
        NSMutableArray *xVals = [NSMutableArray array];
        for (int i=0; i<pointCount; i++) {
            [xVals addObject:@"10"];
            [self.allValues addObject:[NSNumber numberWithInteger:105]];/////初始化100个的数据
            if (i == 0 || i == 1 || i == 2 || i == 3 ) {
                [self.colors addObject:[UIColor clearColor]];
            }else{
                [self.colors addObject:GlobalColor];
            }
        }
        for (int i = 0; i<pointCount; i++) {
            ChartDataEntry *oentry = [[ChartDataEntry alloc] initWithX:i y:[self.allValues[i] integerValue]];
            [self.yVals addObject:oentry];
        }
        
        _lineView.xAxis.valueFormatter = [[DateValueFormatter alloc]initWithArr:xVals];
        //        [self.lineView animateWithXAxisDuration:1.0f];
        [self.lineView setDescriptionTextColor:[UIColor blackColor]];
        [self.lineView setDescriptionFont:[UIFont systemFontOfSize:13]];
        self.lineView.legend.form = ChartLegendFormCircle;//图例的样式
        self.lineView.legend.formSize = 30;//图例中线条的长度
        self.lineView.legend.textColor = [UIColor darkGrayColor];//图例文字颜色
    }
    return _lineView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.lineView];
        index = 0;///刚开始前四个点为空白点
        self.lineView.data = [self setData];
    }
    return self;
}

//为折线图设置数据
- (LineChartData *)setData{
    
    LineChartDataSet *set1 = nil;
    if (self.lineView.data.dataSetCount > 0) {
        LineChartData *data = (LineChartData *)self.lineView.data;
        set1 = (LineChartDataSet *)data.dataSets[0];
        [set1 setColors:self.colors];
        set1.values = self.yVals;
        return data;
    }else{
        //创建LineChartDataSet对象
        set1 = [[LineChartDataSet alloc]initWithValues:self.yVals label:nil];
        set1.drawValuesEnabled = YES;//是否在拐点处显示数据
        //        set1.valueFormatter = [[SetValueFormatter alloc]initWithArr:yVals];
        //设置折线的样式
        set1.lineWidth = 6/[UIScreen mainScreen].scale;//折线宽度

        set1.drawValuesEnabled = NO;//是否在拐点处显示数据
        set1.valueColors = @[[UIColor brownColor]];//折线拐点处显示数据的颜色
        
#warning Charts框架中传入颜色数组来设置折线图中这线的颜色
        [set1 setColors:self.colors];
        set1.drawSteppedEnabled = NO;//是否开启绘制阶梯样式的折线图
        set1.axisDependency = AxisDependencyLeft;// 表示这个set的数据对应左边的y轴
        //折线拐点样式
        set1.drawCirclesEnabled = NO;//是否绘制拐点
        set1.circleRadius = 2.5f;//拐点半径
        set1.circleColors = @[[UIColor greenColor]];//拐点颜色
        //拐点中间的空心样式
        set1.drawCircleHoleEnabled = YES;//是否绘制中间的空心
        set1.circleHoleRadius = 1.0f;//空心的半径
        set1.circleHoleColor = [UIColor whiteColor];//空心的颜色
        //折线的颜色填充样式
        //第一种填充样式:单色填充
        // set1.drawFilledEnabled = YES;//是否填充颜色
        // set1.fillColor = [UIColor redColor];//填充颜色
        // set1.fillAlpha = 0.3;//填充颜色的透明度
        //第二种填充样式:渐变填充
        set1.drawFilledEnabled = NO;//是否填充颜色
        NSArray *gradientColors = @[(id)[UIColor whiteColor].CGColor,
                                    (id)[UIColor greenColor].CGColor];
        CGGradientRef gradientRef = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
        set1.fillAlpha = 0.5f;//透明度
        set1.fill = [ChartFill fillWithLinearGradient:gradientRef angle:90.0f];//赋值填充颜色对象
        CGGradientRelease(gradientRef);//释放gradientRef
        //点击选中拐点的交互样式
        set1.highlightEnabled = NO;//选中拐点,是否开启高亮效果(显示十字线)
        set1.highlightColor = [UIColor grayColor];//点击选中拐点的十字线的颜色
        set1.highlightLineWidth = 1.0/[UIScreen mainScreen].scale;//十字线宽度
        set1.highlightLineDashLengths = @[@5, @5];//十字线的虚线样式
        
        //将 LineChartDataSet 对象放入数组中
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        //创建 LineChartData 对象, 此对象就是lineChartView需要最终数据对象
        LineChartData *data = [[LineChartData alloc]initWithDataSets:dataSets];
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];//文字字体
        [data setValueTextColor:[UIColor blackColor]];//文字颜色
        
        return data;
    }
}

/**
 运行波形(接受的波形值永远插到白点的后面，然后重新绘制图形)
 @param dataArray 接收到十个波形值
 */
- (void)runWave:(NSArray *)dataArray{
    
    [self.allValues replaceObjectsInRange:NSMakeRange(index, 10) withObjectsFromArray:dataArray];
    
    for (int i = 0; i<4; i++) {//////原来的4个透明点改成和线一样的颜色
        [self.colors replaceObjectAtIndex:index+i withObject:GlobalColor];
    }
    index = index + 10;
    if (index == pointCount) {///////索引移到最后面时重新移到前面
        index = 0;
    }
    for (int i = 0; i<4; i++) {//////透明点往前移动10个单位
        [self.colors replaceObjectAtIndex:index+i withObject:[UIColor clearColor]];
    }
    [self.yVals removeAllObjects];
    for (int i = 0; i<pointCount; i++) {
        ChartDataEntry *oentry = [[ChartDataEntry alloc] initWithX:i y:[self.allValues[i] integerValue]];
        [self.yVals addObject:oentry];
    }
    self.lineView.data = [self setData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
