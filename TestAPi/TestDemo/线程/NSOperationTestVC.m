//
//  NSOperationTestVC.m
//  TestAPi
//
//  Created by jackie on 2018/4/3.
//  Copyright © 2018年 jackie. All rights reserved.
//

#import "NSOperationTestVC.h"
/**
 多线程实现方案:
         1.Pthread
         2.NSThread
         3.NSOperation
         4.GCD
 
 NSOperation、NSOperationQueue 操作和操作队列
 
  实际上 NSOperation、NSOperationQueue 是基于 GCD 更高一层的封装，完全面向对象。但是比 GCD 更简单易用、代码可读性也更高
 
 操作（Operation）：
         执行操作的意思，换句话说就是你在线程中执行的那段代码。
         在 GCD 中是放在 block 中的。在 NSOperation 中，我们使用 NSOperation 子类 NSInvocationOperation、NSBlockOperation，或者自定义子类来封装操作。
 操作队列（Operation Queues）：
         这里的队列指操作队列，即用来存放操作的队列。不同于 GCD 中的调度队列 FIFO（先进先出）的原则。NSOperationQueue 对于添加到队列中的操作，首先进入准备就绪的状态（就绪状态取决于操作之间的依赖关系），然后进入就绪状态的操作的开始执行顺序（非结束执行顺序）由操作之间相对的优先级决定（优先级是操作对象自身的属性）。
         操作队列通过设置最大并发操作数（maxConcurrentOperationCount）来控制并发、串行。
         NSOperationQueue 为我们提供了两种不同类型的队列：主队列和自定义队列。主队列运行在主线程之上，而自定义队列在后台执行。
 
     NSOperation 实现多线程的使用步骤分为三步：
 
     1.创建操作：先将需要执行的操作封装到一个 NSOperation 对象中。
     2.创建队列：创建 NSOperationQueue 对象。
     3.将操作加入到队列中：将 NSOperation 对象添加到 NSOperationQueue 对象中。
     之后呢，系统就会自动将 NSOperationQueue 中的 NSOperation 取出来，在新线程中执行操作。
 
     NSOperation 是个抽象类，不能用来封装操作。我们只有使用它的子类来封装操作。我们有三种方式来封装操作。
 
     使用子类 NSInvocationOperation
     使用子类 NSBlockOperation
     自定义继承自 NSOperation 的子类，通过实现内部相应的方法来封装操作。
 
     NSOperationQueue的暂停恢复和取消
 
     NSOperation有一个cancel方法可以取消单个操作
     NSOperationQueue的cancelAllOperations相当于队列中的每个operation调用了cancel方法,会取消队列里面全部的操作.
     但是,不能取消正在进行中的任务,队列调用了cancelAllOperations后会等当前正在进行的任务执行完闭后取消后面的操作
 
     因此, 我们在自定义NSOperation的时候需要注意,最好可以经常通过判断isCancelled方法检测操作是否被取消，以响应外部可能进行的取消操作.如:
 // 自定义NSOperation类.m文件的main方法实现
 
     - (void)main {
         for (NSInteger i = 0; i < 1000; i++) {
         NSLog(@"SubTask---0---%zd",i);
         }
         // 判断当前任务是否被取消,如果已经取消,及时返回
         if (self.cancelled) {
         return;
         }
     }
     创建队列
     // 主队列获取方法
     NSOperationQueue *queue = [NSOperationQueue mainQueue];
 
     // 自定义队列创建方法
     NSOperationQueue *queue = [[NSOperationQueue alloc] init];
 
    使用 NSOperation 子类创建操作，并使用 addOperation: 将操作加入到操作队列后能够开启新线程，进行并发执行
     - (void)addOperationWithBlock:(void (^)(void))block;
     无需先创建操作，在 block 中添加操作，直接将包含操作的 block 加入到队列中。
 
 NSOperationQueue 控制串行执行、并发执行
 
 这里有个关键属性 maxConcurrentOperationCount，叫做最大并发操作数。用来控制一个特定队列中可以有多少个操作同时参与并发执行。
 
     最大并发操作数：maxConcurrentOperationCount
     maxConcurrentOperationCount 默认情况下为-1，表示不进行限制，可进行并发执行。
     maxConcurrentOperationCount 为1时，队列为串行队列，按顺序串行执行。只能串行执行。
     maxConcurrentOperationCount 大于1时，队列为并发队列。操作并发执行，当然这个值不应超过系统限制，即使自己设置一个很大的值，系统也会自动调整为 min{自己设定的值，系统设定的默认最大值}。
 
 
 NSOperation 优先级
 
 queuePriority属性适用于同一操作队列中的操作，不适用于不同操作队列中的操作。默认情况下，所有新创建的操作对象优先级都是NSOperationQueuePriorityNormal。但是我们可以通过setQueuePriority:方法来改变当前操作在同一队列中的执行优先级。
 // 优先级的取值
 typedef NS_ENUM(NSInteger, NSOperationQueuePriority) {
         NSOperationQueuePriorityVeryLow = -8L,
         NSOperationQueuePriorityLow = -4L,
         NSOperationQueuePriorityNormal = 0,
         NSOperationQueuePriorityHigh = 4,
         NSOperationQueuePriorityVeryHigh = 8
 };
 
 
 
 */

@interface NSOperationTestVC ()


@end

@implementation NSOperationTestVC

- (void)viewDidLoad {
    [super viewDidLoad]; 
    
    
 
}


/**
    在不使用 NSOperationQueue，单独使用 NSOperation 的情况下系统同步执行操作，

    可以看到：在没有使用 NSOperationQueue、在主线程中单独使用使用子类 NSInvocationOperation 执行一个操作的情况下，操作是在当前线程执行的，并没有开启新线程。
    如果在其他线程中执行操作，则打印结果为其他线程。
 */

- (void)useInvocationOperation{
    // 1.创建 NSInvocationOperation 对象
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    
    // 2.调用 start 方法开始执行操作
    [op start];
    
}

- (void)task1 {
    
    for (int i = 0; i < 2; i++) {
        
        [NSThread sleepForTimeInterval:1]; // 模拟耗时操作
        
        NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
    }
}

/**
 NSBlockOperation 还提供了一个方法 addExecutionBlock:，通过 addExecutionBlock: 就可以为 NSBlockOperation 添加额外的操作。这些操作（包括 blockOperationWithBlock 中的操作）可以在不同的线程中同时（并发）执行。只有当所有相关的操作已经完成执行时，才视为完成。
 
 如果添加的操作多的话，blockOperationWithBlock: 中的操作也可能会在其他线程（非当前线程）中执行，这是由系统决定的，并不是说添加到 blockOperationWithBlock: 中的操作一定会在当前线程中执行。（可以使用 addExecutionBlock: 多添加几个操作试试）
 
 */

- (void)useBlockOperation {
    
    // 1.创建 NSBlockOperation 对象
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    // 2.调用 start 方法开始执行操作
    [op start];
}

/**
 * 使用子类 NSBlockOperation
 * 调用方法 AddExecutionBlock:
 */

- (void)useBlockOperationAddExecutionBlock {
    
    [NSThread mainThread].name = @"主线程";
    
    // 1.创建 NSBlockOperation 对象 ,在主线程
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
             [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
        
            NSLog(@"1---%i", [[NSThread currentThread] isMainThread]); // 打印当前线程
     }];
    
    
    // 2.添加额外的操作 可能在主线程也可能在其他线程
    [op addExecutionBlock:^{
             [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
     }];
    [op addExecutionBlock:^{
             [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
 
     }];
    [op addExecutionBlock:^{
             [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"4---%@", [NSThread currentThread]); // 打印当前线程
     }];
    [op addExecutionBlock:^{
             [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"5---%@", [NSThread currentThread]); // 打印当前线程
     }];
    [op addExecutionBlock:^{
             [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"6---%@", [NSThread currentThread]); // 打印当前线程
    }] ;
    
    // 3.调用 start 方法开始执行操作
    [op start];
    
 
}
#pragma mark **************  线程间通信   ********************


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self testConnection];
}


- (void)testConnection {
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 子线程下载图片
    [queue addOperationWithBlock:^{
        NSURL *url = [NSURL URLWithString:@"http://img.pconline.com.cn/images/photoblog/9/9/8/1/9981681/200910/11/1255259355826.jpg"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:data];
        // 回到主线程进行显示
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            //update UI
        }];
    }];
    
}

@end
