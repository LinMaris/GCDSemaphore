//
//  AppDelegate.h
//  TestGCD
//
//  Created by MarisLin on 2018/2/23.
//  Copyright © 2018年 MarisLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,assign) dispatch_group_t group;
@end

