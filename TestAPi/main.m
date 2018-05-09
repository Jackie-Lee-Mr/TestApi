//
//  main.m
//  TestAPi
//
//  Created by jackie on 2018/3/18.
//  Copyright © 2018年 jackie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h" // for test Demo
#import "YYAppDelegate.h"
/**
 
 1.用户点击应用程序图标；
 
 2.程序执行main()函数；
 
 3.main函数中直接返回的是UIApplicationMain，所以接下来执行UIApplicationMain；
 
 4.根据UIApplicationMain中的第三、第四个参数分别设置UIApplication对象及其代理；第三个参数是UIApplication的类名或者子类名，如果为nil则默认是UIApplication，第四个参数代表代理的类名，该代理负责处理应用程序状态切换过程中所产生的事件；
 
 5.开启循环监听系统事件（Event Loop）；
 
 6.此处分有storyboard和没有storyboard两种情况，
 
 
 (1)有stroyboard
 
 > 应用程创建一个UIWindow对象(继承自UIView),并设置为AppDelegate的window属性。
 
 > 加载Info.plist文件，读取最主要storyboard文件的名称。
 
 > 加载最主要的storyboard文件，创建白色箭头所指的控制器对象。并且设置控制器为UIWindow的rootViewController属性(根控制器)。
 
 > 展示UIWindow,展示之前会将添加rootViewController的view到UIWindow上面(在这一步才会创建控制器的view),其内部会执行该行代码:[window addSubview: window.rootViewControler.view];
 
 
 
 (2)没有stroyboard
 
 > 首先会调用delegate对象的application:didFinishLaunchingWithOptions:方法。
 
 > 在application:didFinishLaunchingWithOptions:方法中需要主动创建 UIWindow对象。并设置为AppDelegate的window属性。
 
 > 主动创建一个 UIViewController对象，并赋值给window的rootViewController属性。
 
 > 调用 window的makeKeyAndVisible方法显示窗口。
 
 
 [objc] view plain copy
 //创建窗口对象
 self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
 
 //创建主控制器对象（控制器的View是延时加载的，等到用到的时候再用loadView方法加载）
 self.HITViewController = [[UIViewController alloc]initWithNibName:@"HITViewController" bundle:nil];
 
 //设置窗口的根控制器为该主控制器
 self.window.rootViewController = self.HITViewController;
 
 //让窗口成为主窗口并可见
 [self.window makeKeyAndVisible];
 
 程序加载的顺序是先在程序中找storyboard，若果没有找到则找相应的xib，若是都没找到并且代理中没有手动添加代码，则默认用代码创建一个黑色的界面；
 
 
 
 */
int main(int argc, char * argv[]) {
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
