//
//  ViewController.m
//  RunningWave
//
//  Created by Justec_Mac on 2017/10/31.
//  Copyright © 2017年 JustecMac. All rights reserved.
//

#import "ViewController.h"
#import "WaveView.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

@interface ViewController ()
{
    WaveView *waveView;
    NSTimer *timer;
}
@property (nonatomic,strong)NSMutableArray *array;
- (IBAction)buttonclick:(id)sender;
@end

@implementation ViewController

-(NSMutableArray *)array{
    if (_array == nil) {
        self.array = [NSMutableArray array];
    }
    return _array;
}

- (IBAction)buttonclick:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if (button.selected) {
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(runWave) userInfo:nil repeats:YES];
    }else{
        [timer invalidate];
        timer = nil;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    WaveView *waveV = [[WaveView alloc]init];
    waveV.frame = CGRectMake(0, 200, SCREEN_WIDTH, 200);
    [self.view addSubview:waveV];
    waveView = waveV;
    
}

- (void)runWave{
    [self.array removeAllObjects];
    for (int i = 0; i<10; i++) {
        [self.array addObject:[NSNumber numberWithInteger:arc4random_uniform(80)]];
    }
    [waveView runWave:self.array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
