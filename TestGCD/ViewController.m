//
//  ViewController.m
//  TestGCD
//
//  Created by MarisLin on 2018/2/23.
//  Copyright © 2018年 MarisLin. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "TestViewController.h"
#import "TestViewController2.h"
#import "TestViewController3.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self testGCD];
    
//    [self testGCD2];
    
//    [self testGCD3];
    
//    [self testOperationQueue];
    
    [self testGCD4];
}

#pragma mark - 在不同页面多个操作结束后统一操作
-(void)testGCD {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.group = group;
    
    dispatch_group_async(group, queue, ^{
        //请求1
        NSLog(@"Request_1");
    });
    dispatch_group_async(group, queue, ^{
        sleep(2);
        
        //请求2
        NSLog(@"Request_2");
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //界面刷新
        NSLog(@"任务均完成，刷新界面");
    });
    
    dispatch_group_async(group, queue, ^{
        //请求3
        NSLog(@"Request_3");
    });
    
    TestViewController *vc = [TestViewController new];
    vc.view.alpha = 0;
    [self addChildViewController:vc];
    
    /**
     2018-02-23 20:11:59.261251+0800 TestGCD[691:241335] Request_1
     2018-02-23 20:11:59.261445+0800 TestGCD[691:241341] Request_3
     2018-02-23 20:11:59.262025+0800 TestGCD[691:241341] Request_4
     2018-02-23 20:12:01.266517+0800 TestGCD[691:241335] Request_2
     2018-02-23 20:12:01.267049+0800 TestGCD[691:241312] 任务均完成，刷新界面
     */
}

#pragma mark - 高并发网络请求结束后统一操作(不要求顺序)
-(void)testGCD2 {
    
    TestViewController2 *vc = [TestViewController2 new];
    vc.view.alpha = 0;
    [self addChildViewController:vc];
}

#pragma mark - 多个请求顺序执行 GCD
-(void)testGCD3 {
    // 串行队列
    dispatch_queue_t queue = dispatch_queue_create("cn.itcast.gcddemo", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        NSLog(@"Request_1");
    });
    
    dispatch_sync(queue, ^{
        
        sleep(2);
        NSLog(@"Request_2");
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"Request_3");
    });
    
    /**
     2018-02-23 20:10:12.598001+0800 TestGCD[688:240572] Request_1
     2018-02-23 20:10:14.599604+0800 TestGCD[688:240572] Request_2
     2018-02-23 20:10:14.599821+0800 TestGCD[688:240572] Request_3
     */
}

#pragma mark - 多个请求顺序执行 NSOperationQueue 推荐
-(void)testOperationQueue {
    // 创建任务
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"Request_1");
    }];
    
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        sleep(2);
        NSLog(@"Request_2");
    }];
    
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"Request_3");
    }];
    
    // 设置依赖
    [operation3 addDependency:operation2];
    [operation2 addDependency:operation1];
    
    // 创建队列并加入任务
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperations:@[operation1, operation2,operation3] waitUntilFinished:NO];
}

#pragma mark - GCD死锁
-(void)testGCD4 {
    
    TestViewController3 *vc = [TestViewController3 new];
    vc.view.alpha = 0;
    [self addChildViewController:vc];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
