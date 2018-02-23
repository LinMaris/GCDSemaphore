//
//  TestViewController.m
//  TestGCD
//
//  Created by MarisLin on 2018/2/23.
//  Copyright © 2018年 MarisLin. All rights reserved.
//

#import "TestViewController.h"
#import "AppDelegate.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_async(delegate.group,queue, ^{
        //请求4
        NSLog(@"Request_4");
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
