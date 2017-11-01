//
//  SymbolsValueFormatter.m
//  RunningWave
//
//  Created by Justec_Mac on 2017/10/31.
//  Copyright © 2017年 JustecMac. All rights reserved.
//

#import "SymbolsValueFormatter.h"

@implementation SymbolsValueFormatter
-(id)init{
    if (self = [super init]) {
        
    }
    return self;
}
//返回y轴的数据
- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    NSString *valueString = [NSString stringWithFormat:@"%ld",(NSInteger)value];
    
    return valueString;
}
@end
