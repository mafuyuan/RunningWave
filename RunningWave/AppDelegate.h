//
//  AppDelegate.h
//  RunningWave
//
//  Created by Justec_Mac on 2017/11/1.
//  Copyright © 2017年 JustecMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

