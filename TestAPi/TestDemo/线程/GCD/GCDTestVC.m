//
//  GCDTestVC.m
//  TestAPi
//
//  Created by jackie on 2018/4/3.
//  Copyright © 2018年 jackie. All rights reserved.
//

#import "GCDTestVC.h"
/**
 Grand Central Dispatch(GCD) 是 Apple 开发的一个多核编程的较新的解决方法,它主要用于优化应用程序以支持多核处理器以及其他对称多处理系统,在 Mac OS X 10.6 雪豹中首次推出，也可在 iOS 4 及以上版本使用。
 
 1.  GCD 优势具体如下：
 
         GCD 可用于多核的并行运算
         GCD 会自动利用更多的 CPU 内核（比如双核、四核）
         GCD 会自动管理线程的生命周期（创建线程、调度任务、销毁线程）
         程序员只需要告诉 GCD 想要执行什么任务，不需要编写任何线程管理代码
 
 2. GCD 任务和队列（决定任务执行的方式：一个个执行还是同时执行 ）
 
         2-1：任务：就是执行操作的意思，换句话说就是你在线程中执行的那段代码。在 GCD 中是放在 block 中的。执行任务有两种方式：同步执行（sync）和异步执行（async）。两者的主要区别是：是否等待队列的任务执行结束，以及是否具备开启新线程的能力。
 
             同步执行（sync）：
                 同步添加任务到指定的队列中，在添加的任务执行结束之前，会一直等待，直到队列里面的任务完成之后再继续执行。
                 只能在当前线程中执行任务，不具备开启新线程的能力。一个个的执行。
 
             异步执行（async）：
                 异步添加任务到指定的队列中，它不会做任何等待，可以继续执行任务。
                 可以在新的线程中执行任务，具备开启新线程的能力（但是不一定开启新的线程，跟任务所指定的队列类型有关）。所谓的同时执行
 
         2-2：队列（Dispatch Queue）：这里的队列指执行任务的等待队列，即用来存放任务的队列。队列是一种特殊的线性表，采用 FIFO（先进先出）的原则，即新任务总是被插入到队列的末尾，而读取任务的时候总是从队列的头部开始读取。每读取一个任务，则从队列中释放一个任务。
 
                 在 GCD 中有两种队列：串行队列和并发队列。两者都符合 FIFO（先进先出）的原则。两者的主要区别是：执行顺序不同，以及开启线程数不同。
 
                 串行队列（Serial Dispatch Queue）：
                       每次只有一个任务被执行。让任务一个接着一个地执行。（只开启一个线程，一个任务执行完毕后，再执行下一个任务）
 
                 并发队列（Concurrent Dispatch Queue）：
                       可以让多个任务并发（同时）执行。（可以开启多个线程，并且同时执行任务）
 
                 注意：并发队列 的并发功能只有在异步（dispatch_async）函数下才有效
 3. GCD 的使用步骤
 
         GCD 的使用步骤其实很简单，只有两步。
 
         创建一个队列（串行队列或并发队列）
         将任务追加到任务的等待队列中，然后系统就会根据任务类型执行任务（同步执行或异步执行）
 
         下边来看看 队列的创建方法/获取方法，以及 任务的创建方法。
 
       3.1 队列的创建方法/获取方法
 
             可以使用dispatch_queue_create来创建队列，需要传入两个参数，第一个参数表示队列的唯一标识符，用于 DEBUG，可为空，Dispatch Queue 的名称推荐使用应用程序 ID 这种逆序全程域名；第二个参数用来识别是串行队列还是并发队列。DISPATCH_QUEUE_SERIAL 表示串行队列，DISPATCH_QUEUE_CONCURRENT 表示并发队列。
 
             //3.1.1 串行队列的创建方法
             dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_SERIAL);
 
             //3.1.2 并发队列的创建方法
             dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
 
             对于串行队列，GCD 提供了的一种特殊的串行队列：主队列（Main Dispatch Queue）。
             所有放在主队列中的任务，都会放到主线程中执行。
             可使用dispatch_get_main_queue()获得主队列。
 
             // 主队列的获取方法
             dispatch_queue_t queue = dispatch_get_main_queue();
 
             对于并发队列，GCD 默认提供了全局并发队列（Global Dispatch Queue）。
             可以使用dispatch_get_global_queue来获取。需要传入两个参数。第一个参数表示队列优先级，一般用DISPATCH_QUEUE_PRIORITY_DEFAULT。第二个参数暂时没用，用0即可。
 
             // 全局并发队列的获取方法
             dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
 
            3.1.1 对于串行队列，GCD 提供了的一种特殊的串行队列：主队列（Main Dispatch Queue）。
                     所有放在主队列中的任务，都会放到主线程中执行。
                     可使用dispatch_get_main_queue()获得主队列。
                     // 主队列的获取方法
                     dispatch_queue_t queue = dispatch_get_main_queue();
 
 
            3.1.2 对于并发队列，GCD 默认提供了全局并发队列（Global Dispatch Queue）。
                     可以使用dispatch_get_global_queue来获取。需要传入两个参数。第一个参数表示队列优先级，一般用DISPATCH_QUEUE_PRIORITY_DEFAULT。第二个参数暂时没用，用0即可。
 
                     // 全局并发队列的获取方法
                     dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
 
       3.2 任务的创建方法
 
         GCD 提供了同步执行任务的创建方法dispatch_sync和异步执行任务创建方法dispatch_async。
 
         // 同步执行任务创建方法
         dispatch_sync(queue, ^{
         // 这里放同步执行任务代码
         });
         // 异步执行任务创建方法
         dispatch_async(queue, ^{
         // 这里放异步执行任务代码
         });
 
 组合模式
 
 同步函数还是异步函数：是否具有开启线程的能力 ，并发还是串行决定执行的方式
 
 1.同步执行 + 并发队列:没有开启线程，串行执行任务
 
 2.异步执行 + 并发队列: 有开启线程，并发执行任务

 3.同步执行 + 串行队列:没有开启线程，串行执行任务

 4.异步执行 + 串行队列:有开启线程（只开启一条线程），串行发执行任务

 5.同步执行 + 主队列:没有开启线程，串行执行任务

 6.异步执行 + 主队列:没有开启线程，串行执行任务

                并发队列                     串行队列                     主队列
 
 同步:    没有开启新的线程，串行执行任务    没有开启新的线程，串行执行任务    没有开启新的线程，串行执行任务
 
 异步:    有开启线程，并发执行任务         有开启（一条）线程，并发执行任务    没有开启新的线程，串行执行任务
 
   4. GCD 线程间的通信
 
 
 */


static NSString *cellId = @"cellId";

@interface GCDTestVC ()<UITableViewDelegate,UITableViewDataSource>
{
    
        dispatch_semaphore_t semaphoreLock;
     
}

@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UIImageView *testImageView;
@property (nonatomic, assign) NSInteger  ticketSurplusCount;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *cellArray;

@end

@implementation GCDTestVC

-(NSArray *)cellArray {
    if (!_cellArray) {
        _cellArray = @[@"synchronousConcurrent",
                       @"asynchronousConcurrent",
                       @"asynchronousSerial",
                       @"synchronousMainQueue",
                       @"communication",
                       @"barrier_async",
                       @"dispatch_apply",
                       @"groupNotify",
                       @"dispatch_group_wait",
                       @"semaphoreSync",
                       @"initTicketStatusNotSave"
                       ];
    }
    return _cellArray;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.textLabel.text = self.cellArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *mehtodName = self.cellArray[indexPath.row];
    
    SEL sel = NSSelectorFromString(mehtodName);
    
    [self performSelector:sel];
    
}
 
 
/**
 
 self.edgesForExtendedLayout = UIRectEdgeNone  是会对整个页面的控件的坐标起到作用的，而self.automaticallyAdjustsScrollViewInsets = NO 是只针对于UIScrollView的.
 
 translucent属性默认是YES，也就是具有透明属性。所以我们看到的导航栏背景色与美工给的会有很明显的色差。
 
 一种是全局的：[[UINavigationBar appearance] setTranslucent:NO];
 某个Controller上：self.navigationController.navigationBar.translucent = NO;
 
 
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;//导航栏下面到tabbar 上面
    [self.tableView registerClass:[UITableViewCell class ] forCellReuseIdentifier:cellId];
    [self.tableView reloadData];
}

/**
     1.同步执行 + 并发队列:没有开启线程，串行执行任务,会阻塞UI线程，也就是主线程，此时所有的UI操作包括都会失效。包括设置lable的text，知道最后一个任务结束才会恢复UI的操作，即只有最后一个任务才会对UI 有操作。
 
     2.同步执行 + 串行队列:没有开启线程，串行执行任务
 
     3.同步执行 + 主队列:没有开启线程，串行执行任务，线程卡死
 
     在当前线程中执行任务，不会开启新的线程，一个一个的按照添加的顺序执行，一个结束后执行另一个。
 */
 - (void)synchronousConcurrent{
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"synchronousConcurrent---begin");
     
    //普通串行队列
    dispatch_queue_t concurrentQueue =  dispatch_queue_create("synchronousConcurrent", DISPATCH_QUEUE_SERIAL);
  
    //dispatch_queue_t globalConcurrentQueue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    
    //同步执行( 就一定不会开启新的线程 ),都在当前线程中执行。
    dispatch_sync(concurrentQueue, ^{
 
        [NSThread sleepForTimeInterval:2];
         NSLog(@"1---%@",[NSThread currentThread]);
        
    });
    
    dispatch_sync(concurrentQueue, ^{
        
         [NSThread sleepForTimeInterval:2];
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程

    });
    
    dispatch_sync(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
   
         self.testLabel.text = @"执行任务三";
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程

    });
    
     NSLog(@"synchronousConcurrent---end");
}

/**
    4.异步执行 + 并发队列:有开启线程，并发执行任务,能够开启多个线程 ，不会阻塞主线程,关于UI的刷新必须回到主线程
 
 */

- (void)asynchronousConcurrent{
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asynchronousConcurrent---begin");
    
    //普通并发队列  全局并发队列
    dispatch_queue_t concurrentQueue =  dispatch_queue_create("synchronousConcurrent", DISPATCH_QUEUE_CONCURRENT);
    
    //dispatch_queue_t globalConcurrentQueue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    
    //同步执行( 就一定会开启新的线程 )
    dispatch_async(concurrentQueue, ^{
       
            [NSThread sleepForTimeInterval:5];
            dispatch_async(dispatch_get_main_queue(), ^{
               self.view.backgroundColor = [UIColor redColor];
     
            });
        
        NSLog(@"1---%@",[NSThread currentThread]);
        
    });
    
    dispatch_async(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:3];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.view.backgroundColor = [UIColor yellowColor];
        });
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_async(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
        dispatch_async(dispatch_get_main_queue(), ^{
            self.view.backgroundColor = [UIColor blueColor];
        });
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    NSLog(@"asynchronousConcurrent---end");
    
}


/**
 
  5.异步执行 + 串行队列: 有开启一个线程，串行执行任务，一个接着一个按照顺序执行。
 
  6.异步执行 + 主队列：UI线程阻塞，不会开启新的线程，此时所有的UI操作包括都会失效。包括设置lable的text，知道最后一个任务结束才会恢复UI的操作，即只有最后一个任务才会对UI 有操作
 
 */

- (void)asynchronousSerial{
    
    //串行队列：普通的 和住队列
    dispatch_queue_t synchronousQueue =  dispatch_queue_create("synchronousQueue", DISPATCH_QUEUE_SERIAL);
    
    //并发队列
     dispatch_queue_t synchronousQueue1 =  dispatch_queue_create("synchronousQueue", DISPATCH_QUEUE_CONCURRENT);
    
//    dispatch_queue_t mainQueue = dispatch_get_main_queue();回到主线程，不会开启新的线程。
    
    //同步执行( 就一定不会开启新的线程 )
    dispatch_async(synchronousQueue, ^{
        
        [NSThread sleepForTimeInterval:5];              // 模拟耗时操作
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.view.backgroundColor = [UIColor redColor];
            
            
        });
        
        NSLog(@"1---%@",[NSThread currentThread]);
        
    });
    
    dispatch_async(synchronousQueue, ^{
        
        [NSThread sleepForTimeInterval:3];              // 模拟耗时操作
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.view.backgroundColor = [UIColor yellowColor];
            
            
        });
        
        
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        
    });
    
    dispatch_async(synchronousQueue, ^{
        
        [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
          
        [[[NSURLSession sharedSession]
          dataTaskWithURL:[NSURL URLWithString: @"http://g.hiphotos.baidu.com/image/pic/item/71cf3bc79f3df8dcdfa01202c111728b46102887.jpg"]
          
          completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                         
                 //解析数据
                 UIImage *image = [UIImage imageWithData:data];
                 //回到主线程设置图片
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                      self.testImageView.image = image;
                     
                      self.view.backgroundColor = [UIColor greenColor];

                 });
              
             }] resume];
         
       
        
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        
    });
    
    NSLog(@"synchronousQueue---end");
    
    
    
}


/**
 
在主队列中：  同步执行 + 主队列 : 会卡死 crash
在其他队列中不会卡死 ， 也不会crash
 
 */

- (void)synchronousMainQueue{
    
    NSLog(@"synchronousMainQueue -begin");
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        
         NSLog(@"1");
        
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"1-1");
        
    });
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        
        NSLog(@"2");
          [NSThread sleepForTimeInterval:2];
        NSLog(@"2-2");
        
    });
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        
        NSLog(@"3");
        
          [NSThread sleepForTimeInterval:2];
        
        NSLog(@"3-3");
        
    });
    
    NSLog(@"synchronousMainQueue -end");
}

#pragma mark **************  GCD 线程间的通信   ********************

- (void)communication {
    // 获取全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 获取主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        // 异步追加任务
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
        
        // 回到主线程
        dispatch_async(mainQueue, ^{
            // 追加在主线程中执行的任务
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        });
    });
}

#pragma mark **************   GCD 的其他方法   ********************
/**
 GCD 栅栏方法：dispatch_barrier_async
 需求：
    我们有时需要异步执行两组操作，而且第一组操作执行完之后，才能开始执行第二组操作。这样我们就需要一个相当于 栅栏 一样的一个方法将两组异步执行的操作组给分割起来，当然这里的操作组里可以包含一个或多个任务。
     这就需要用到dispatch_barrier_async方法在两个操作组间形成栅栏。
 
 1.使用GCD：dispatch_barrier_async函数会等待前边追加到并发队列中的任务全部执行完毕之后，再将指定的任务追加到该异步队列中。然后在dispatch_barrier_async函数追加的任务执行完毕之后，异步队列才恢复为一般动作，接着追加任务到该异步队列并开始执行
 
 2.使用NSOperation：添加依赖底层就是此函数大概率
 
 */

- (void)barrier_async {
    
    NSLog(@"begin-%@",[NSThread currentThread]);
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        // 追加任务1
             [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
     });
    dispatch_async(queue, ^{
        // 追加任务2
             [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
     });
    
    dispatch_barrier_async(queue, ^{
        // 追加任务 barrier
             [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"barrier---%@",[NSThread currentThread]);// 打印当前线程
     });
    
    dispatch_async(queue, ^{
        // 追加任务3
             [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
     });
    dispatch_async(queue, ^{
        // 追加任务4
             [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
            NSLog(@"4---%@",[NSThread currentThread]);      // 打印当前线程
 
    });
    
    NSLog(@"end-%@",[NSThread currentThread]);
}

/**
     GCD 快速迭代方法：dispatch_apply
 
     通常我们会用 for 循环遍历，但是 GCD 给我们提供了快速迭代的函数dispatch_apply。dispatch_apply按照指定的次数将指定的任务追加到指定的队列中，并等待全部队列执行结束。
 
 */

- (void)dispatch_apply {
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSLog(@"apply---begin");
    dispatch_apply(6, queue, ^(size_t index) {
        NSLog(@"%zd---%@",index, [NSThread currentThread]);
    });
    NSLog(@"apply---end");
}

/**
 
  GCD 的队列组：dispatch_group
 
 需求：分别异步执行2个耗时任务，然后当2个耗时任务都执行完毕后再回到主线程执行任务。这时候我们可以用到 GCD 的队列组。
 
 调用队列组的 dispatch_group_async 先把任务放到队列中，然后将队列放入队列组中。或者使用队列组的 dispatch_group_enter、dispatch_group_leave 组合 来实现dispatch_group_async。
 
 调用队列组的 dispatch_group_notify 回到指定线程执行任务。或者使用 dispatch_group_wait 回到当前线程继续向下执行（会阻塞当前线程）。
 
 */

- (void)groupNotify {
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步任务1、任务2都执行完毕后，回到主线程执行下边任务
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
        NSLog(@"group---end");
    });
}

/**
     dispatch_group_wait
 
    暂停当前线程（阻塞当前线程），等待指定的 group 中的任务执行完成后，才会往下继续执行
 
 dispatch_group_enter、dispatch_group_leave
 
 dispatch_group_enter 标志着一个任务追加到 group，执行一次，相当于 group 中未执行完毕任务数+1
 dispatch_group_leave 标志着一个任务离开了 group，执行一次，相当于 group 中未执行完毕任务数-1。
 当 group 中未执行完毕任务数为0的时候，才会使dispatch_group_wait解除阻塞，以及执行追加到dispatch_group_notify中的任务。
 
 
 */

- (void)dispatch_group_wait {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    // 等待上面的任务全部完成后，会往下继续执行（会阻塞当前线程）,当group 中未执行完毕的任务为0 时，解除阻塞。
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    NSLog(@"group---end");
}

/**
 
 */

/**
     GCD 信号量：dispatch_semaphore
 
     GCD 中的信号量是指 Dispatch Semaphore，是持有计数的信号。类似于过高速路收费站的栏杆。可以通过时，打开栏杆，不可以通过时，关闭栏杆。在 Dispatch Semaphore 中，使用计数来完成这个功能，计数为0时等待，不可通过。计数为1或大于1时，计数减1且不等待，可通过。Dispatch Semaphore 提供了三个函数。
 
     dispatch_semaphore_create：创建一个Semaphore并初始化信号的总量
     dispatch_semaphore_signal：发送一个信号，让信号总量加1
     dispatch_semaphore_wait：可以使总信号量减1，当信号总量为0时就会一直等待（阻塞所在线程），否则就可以正常执行。
 
     注意：信号量的使用前提是：想清楚你需要处理哪个线程等待（阻塞），又要哪个线程继续执行，然后使用信号量。
 
     Dispatch Semaphore 在实际开发中主要用于：
 
     保持线程同步，将异步执行任务转换为同步执行任务
 
     保证线程安全，为线程加锁
 
 */
/**
 
 利用 Dispatch Semaphore 实现线程同步，将异步执行任务转换为同步执行任务。

 semaphore---end 是在执行完  number = 100; 之后才打印的。而且输出结果 number 为 100。这是因为异步执行不会做任何等待，可以继续执行任务。异步执行将任务1追加到队列之后，不做等待，接着执行dispatch_semaphore_wait方法。此时 semaphore == 0，当前线程进入等待状态。然后，异步任务1开始执行。任务1执行到dispatch_semaphore_signal之后，总信号量，此时 semaphore == 1，dispatch_semaphore_wait方法使总信号量减1，正在被阻塞的线程（主线程）恢复继续执行。最后打印semaphore---end,number = 100。这样就实现了线程同步，将异步执行任务转换为同步执行任务。
 
 
 */
- (void)semaphoreSync {
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    //全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
//    dispatch_queue_t queue1 = dispatch_queue_create("DISPATCH_QUEUE_SERIAL", DISPATCH_QUEUE_SERIAL);
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block int number = 100;
    
    NSString *name1 = @"jackie";
    
    name1 = [name1 stringByAppendingString:@"-rose"];
    
    //ARC
    __block NSString *taskName;
    
    dispatch_async(queue, ^{
        
        //crate的value表示，最多几个资源可访问
        
        //异步请求token ,此时信号量为 0 ，会一直等待，等拿到token ，信号量加1 ，然后继续走代码
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        NSLog(@"task1-start");
        number += 100;
        taskName = [taskName stringByAppendingString:@"task1"];
        [NSThread sleepForTimeInterval:2];
        NSLog(@"task1--finished");
        number += 100;
        
        dispatch_semaphore_signal(semaphore);
       
    });
    
    dispatch_async(queue, ^{
        
        NSLog(@"task2-start");
        dispatch_semaphore_signal(semaphore);
        
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);//直到信号量大于1时，再继续执行

    NSLog(@"semaphore---end,number = %d, name = %@",number,taskName);
    
    
 }

/**
             Dispatch Semaphore 线程安全和线程同步（为线程加锁）
             枷锁的方式：
    1.dispatch_semaphore_t semaphore
    2.NSLock
 
         NSLock
 
         在Cocoa程序中NSLock中实现了一个简单的互斥锁，实现了NSLocking protocol。
         lock，加锁
         unlock，解锁
         tryLock，尝试加锁，如果失败了，并不会阻塞线程，只是立即返回
         NOlockBeforeDate:，在指定的date之前暂时阻塞线程（如果没有获取锁的话），如果到期还没有获取锁，则线程被唤醒，函数立即返回NO
         使用tryLock并不能成功加锁，如果获取锁失败就不会执行加锁代码了。
     3.@synchronized代码块
     - (void)getIamgeName:(int)index{
     NSString *imageName;
     @synchronized(self) {
             if (imageNames.count>0) {
             imageName = [imageNames lastObject];
             [imageNames removeObject:imageName];
           }
     }
 }  
 
 */



/**
 非线程安全（不使用 semaphore）
 */

 - (void)initTicketStatusNotSave {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
     
    self.ticketSurplusCount = 100;
    
    semaphoreLock = dispatch_semaphore_create(1);
    
    // queue1 代表北京火车票售卖窗口
    dispatch_queue_t queue1 = dispatch_queue_create("net.bujige.testQueue1", DISPATCH_QUEUE_SERIAL);
    
    // queue2 代表上海火车票售卖窗口
    dispatch_queue_t queue2 = dispatch_queue_create("net.bujige.testQueue2", DISPATCH_QUEUE_SERIAL);
    
    __block  int a  = 100;
     
    __weak typeof(self) weakSelf = self;
    dispatch_async(queue1, ^{
        
        while (a--) {
            
            if (a >= 0) {
                
                 [weakSelf saleTicketNotSafe];
                
            }
            
           
        }
       
    });
    
    dispatch_async(queue2, ^{
        
        while (a--) {
           
            if (a >= 0) {
                
                [weakSelf saleTicketNotSafe];
                
            }
        }
    });
}

/**
 * 售卖火车票(线程安全)
 */
- (void)saleTicketSafe{
    
    // 相当于加锁 线程安全
    dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);

    if (self.ticketSurplusCount > 0) {  //如果还有票，继续售卖
        
        self.ticketSurplusCount--;
        NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%zi 窗口：%@", self.ticketSurplusCount, [NSThread currentThread]]);
        
        [NSThread sleepForTimeInterval:0.01];
        
    } else { //如果已卖完，关闭售票窗口
        
         // 相当于解锁
         NSLog(@"所有火车票均已售完");
    }
    
    dispatch_semaphore_signal(semaphoreLock);
}

- (void)saleTicketNotSafe{
    
    // 相当于加锁 线程安全
 
    if (self.ticketSurplusCount > 0) {  //如果还有票，继续售卖
        self.ticketSurplusCount--;
        NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%zi 窗口：%@", self.ticketSurplusCount, [NSThread currentThread]]);
        
        [NSThread sleepForTimeInterval:0.001];
        
    } else { //如果已卖完，关闭售票窗口
        
        
        // 相当于解锁
        NSLog(@"所有火车票均已售完");
        
        return;
    }
    
}
 
 

@end
