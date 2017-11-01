//
//  DateValueFormatter.m
//  RunningWave
//
//  Created by Justec_Mac on 2017/10/31.
//  Copyright © 2017年 JustecMac. All rights reserved.
//

#import "DateValueFormatter.h"

@interface DateValueFormatter()
{
    NSArray * _arr;
}
@end
@implementation DateValueFormatter
-(id)initWithArr:(NSArray *)arr{
    self = [super init];
    if (self)
    {
        _arr = arr;
        
    }
    return self;
}
- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    return _arr[(NSInteger)value];
}


@end
