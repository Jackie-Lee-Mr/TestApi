//
//  RunLoopVC.m
//  TestAPi
//
//  Created by jackie on 2018/4/4.
//  Copyright © 2018年 jackie. All rights reserved.
//

#import "RunLoopVC.h"

/**
 1. RunLoop实际上是一个对象，这个对象在循环中用来处理程序运行过程中出现的各种事件（比如说触摸事件、UI刷新事件、定时器事件、Selector事件），从而保持程序的持续运行；而且在没有事件处理的时候，会进入睡眠模式，从而节省CPU资源，提高程序性能。
 
     1.2 RunLoop和线程
 
     RunLoop和线程是息息相关的，我们知道线程的作用是用来执行特定的一个或多个任务，但是在默认情况下，线程执行完之后就会退出，就不能再执行任务了。这时我们就需要采用一种方式来让线程能够处理任务，并不退出。所以，我们就有了RunLoop。
 
     *1.一条线程对应一个RunLoop对象，每条线程都有唯一一个与之对应的RunLoop对象。
     *2.我们只能在当前线程中操作当前线程的RunLoop，而不能去操作其他线程的RunLoop。
     *3.RunLoop对象在第一次获取RunLoop时创建，销毁则是在线程结束的时候。
     *4.主线程的RunLoop对象系统自动帮助我们创建好了(原理如下)，而子线程的RunLoop对象需要我们主动创建。
 
     一条线程对应一个RunLoop对象，每条线程都有唯一一个与之对应的RunLoop对象。
     我们只能在当前线程中操作当前线程的RunLoop，而不能去操作其他线程的RunLoop。
     RunLoop对象在第一次获取RunLoop时创建，销毁则是在线程结束的时候。
     主线程的RunLoop对象系统自动帮助我们创建好了(原理如下)，而子线程的RunLoop对象需要我们主动创建。
 
     RunLoop就是线程中的一个循环，RunLoop在循环中会不断检测，
     通过Input sources（输入源）
     Timer sources（定时源）两种来源等待接受事件；
     然后对接受到的事件通知线程进行处理，并在没有事件的时候进行休息。
 
 NSDefaultRunLoopMode
 UITrackingRunLoopMode
 
 NSRunLoopCommonModes
 
  应用：
 
 ***1当界面中含有UITableView，而且每个UITableViewCell里边都有图片。这时候当我们滚动UITableView的时候，如果有一堆的图片需要显示，那么可能会出现卡顿的现象。
 
 有两种方法：
     1. 监听UIScrollView的滚动
 
        因为UITableView继承自UIScrollView，所以我们可以通过监听UIScrollView的滚动，实现UIScrollView相关delegate即可。
 
     2. 利用PerformSelector设置当前线程的RunLoop的运行模式
 
     利用performSelector方法为UIImageView调用setImage:方法，并利用inModes将其设置为RunLoop下NSDefaultRunLoopMode运行模式。代码如下：
 
     [self.imageView performSelector:@selector(setImage:) withObject:[UIImage imageNamed:@"tupian"] afterDelay:4.0 inModes:NSDefaultRunLoopMode];
 
 ***2后台常驻线程（很常用）
 
 [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
 [[NSRunLoop currentRunLoop] run];

 
 
 
 */

@interface RunLoopVC ()

@end

@implementation RunLoopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
