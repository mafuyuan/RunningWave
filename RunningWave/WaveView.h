//
//  WaveView.h
//  RunningWave
//
//  Created by Justec_Mac on 2017/10/31.
//  Copyright © 2017年 JustecMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaveView : UIView

/**
 运行波形
 @param dataArray 接收到的十个波形值
 */
- (void)runWave:(NSArray *)dataArray;

@end
