//
//  DateValueFormatter.h
//  RunningWave
//
//  Created by Justec_Mac on 2017/10/31.
//  Copyright © 2017年 JustecMac. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Charts;
@interface DateValueFormatter : NSObject<IChartAxisValueFormatter>
-(id)initWithArr:(NSArray *)arr;
@end
