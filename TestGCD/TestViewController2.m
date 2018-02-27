//
//  TestViewController2.m
//  TestGCD
//
//  Created by MarisLin on 2018/2/23.
//  Copyright © 2018年 MarisLin. All rights reserved.
//

#import "TestViewController2.h"

@interface TestViewController2 ()

@end

@implementation TestViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 保证 请求完 再做操作,否则一直线程wait
    
    [self testSema];
    
    [self testSema2];
}

-(void)testSema {
    // 创建一个信号量
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_async(group, queue, ^{
        //请求1
        [self request1:sema];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        // 请求对应信号等待
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);//等待 直到信号量大于0时，即可操作. 同时 信号量 -1
        // 可确保 每次请求完成再执行下一步操作,否则,线程 wait
        
        //界面刷新
        NSLog(@"任务均完成，刷新界面");
    });
}

-(void)request1:(dispatch_semaphore_t)sema {
    BOOL success = true;
    sleep(2);
    if (success) {
        dispatch_semaphore_signal(sema);  // 信号量 +1
    }else{
        dispatch_semaphore_signal(sema);
    }
    NSLog(@"Request_1");
}

-(void)request2:(dispatch_semaphore_t)sema {
    BOOL success = true;
    if (success) {
        dispatch_semaphore_signal(sema);
    }else{
        dispatch_semaphore_signal(sema);
    }
    NSLog(@"Request_2");
}

-(void)testSema2 {
    // 创建一个信号量
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_async(group, queue, ^{
        //请求2
        [self request2:sema];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        // 请求对应信号等待
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        //界面刷新
        NSLog(@"任务2均完成，刷新界面");
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
