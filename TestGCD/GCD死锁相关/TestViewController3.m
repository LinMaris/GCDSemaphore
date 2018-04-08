//
//  TestViewController3.m
//  TestGCD
//
//  Created by MarisLin on 2018/4/8.
//  Copyright © 2018年 MarisLin. All rights reserved.
//

#import "TestViewController3.h"

@interface TestViewController3 ()

@end

@implementation TestViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self testGCD];
    
//    [self testGCD2];
    
//    [self testGCD3];
    
//    [self testGCD4];
    
    [self testGCD5];
}

#pragma mark - 死锁1
-(void)testGCD {
    
    NSLog(@"1==>%@", [NSThread currentThread]);   // 任务1
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"2==>%@", [NSThread currentThread]);   // 任务2
    });
    
    NSLog(@"3==>%@", [NSThread currentThread]);  // 任务3
    
    // 输出结果: 1  并且编译器报错
    
    // 死锁的原因
    /**
     全部在Main线程中完成, 首先执行任务1, 接下来, 程序遇到了同步线程, 他会进入到等待, 等待任务2执行完, 再执行任务3, 但是实际上,遵循FIFO原则执行任务, 任务2被加到任务3后面, 任务2需要等待任务3执行完再执行, 所以进入互相等待的局面, 也叫做死锁
     Main队列
     任务1
     |
     同步线程
     |
     任务3
     |
     任务2
     */
}

#pragma mark - 解决死锁1
-(void)testGCD2 {
    
    NSLog(@"1==>%@", [NSThread currentThread]);   // 任务1
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSLog(@"2==>%@", [NSThread currentThread]);   // 任务2
    });
    
    NSLog(@"3==>%@", [NSThread currentThread]);  // 任务3
    
    // 输出结果:
    // 1
    // 2
    // 3
    
    /**
     全部在Main线程中完成, 首先执行任务1，接下来会遇到一个同步线程，程序会进入等待。等待任务2执行完成以后，才能继续执行任务3。从dispatch_get_global_queue可以看出，任务2被加入到了全局的并行队列中, 当并行队列执行完任务2以后，返回到主队列，继续执行任务3。
     Main队列      Global队列
     任务1             |
       |              |
     同步线程           |
       |              |
     _______         任务2
       |
     任务3
     */
}

#pragma mark - 死锁2
-(void)testGCD3 {
    
    dispatch_queue_t queue = dispatch_queue_create("com.demo.serialQueue", DISPATCH_QUEUE_SERIAL);
    
    NSLog(@"1==>%@", [NSThread currentThread]);  // 任务1
    dispatch_async(queue, ^{
        
        NSLog(@"2==>%@", [NSThread currentThread]);  // 任务2
        
        dispatch_sync(queue, ^{
            NSLog(@"3==>%@", [NSThread currentThread]);  // 任务3
        });
        
        NSLog(@"4==>%@", [NSThread currentThread]);  // 任务4
    });
    
    NSLog(@"5==>%@", [NSThread currentThread]);  // 任务5
    
    // 输出结果:
    // 1
    // 5
    // 2    (5和2顺序不一定)
    // 报错
}

#pragma mark - 解决死锁2
-(void)testGCD4 {
    
    NSLog(@"1==>%@", [NSThread currentThread]);  // 任务1
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSLog(@"2==>%@", [NSThread currentThread]);  // 任务2
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"3==>%@", [NSThread currentThread]);  // 任务3
        });
        
        NSLog(@"4==>%@", [NSThread currentThread]);  // 任务4
    });
    
    NSLog(@"5==>%@", [NSThread currentThread]);  // 任务5
    
    // 输出结果:
    // 1
    // 5
    // 2
    // 3
    // 4   (5和2顺序不一定)
    // 报错
}

-(void)testGCD5 {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSLog(@"1==>%@", [NSThread currentThread]);  // 任务1
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"2==>%@", [NSThread currentThread]);  // 任务2
        });
        
        NSLog(@"3==>%@", [NSThread currentThread]);  // 任务3
    });
    
    NSLog(@"4==>%@", [NSThread currentThread]);  // 任务4
    
    while(1) {}
    
    NSLog(@"5==>%@", [NSThread currentThread]);  // 任务5
    
    // 输出结果:
    // 1
    // 4
    // 1 和 4的顺序不一定
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
