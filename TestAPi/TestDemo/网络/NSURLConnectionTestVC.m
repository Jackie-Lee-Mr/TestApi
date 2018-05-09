//
//  NSURLConnectionTestVC.m
//  TestAPi
//
//  Created by jackie on 2018/4/8.
//  Copyright © 2018年 jackie. All rights reserved.
//
/**
 按照开发中实际需求，如果按下载的文件大小来分类的话，可以分为：小文件下载、大文件下载
 我们可以使用NSData、NSURLConnection（iOS9.0之后舍弃）、NSURLSession（推荐），以及使用第三方框架AFNetworking等方式下载文件。
 
 
 
 
 
 
 */

#import "NSURLConnectionTestVC.h"

@interface NSURLConnectionTestVC ()

@end

@implementation NSURLConnectionTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark **************  小文件下载   ********************


/**
   1.NSDate
 */
- (void)loadFileNSdata{
    
    NSURL *url = [NSURL URLWithString:@"http://pics.sc.chinaz.com/files/pic/pic9/201508/apic14052.jpg"];
    
    // 使用NSData的dataWithContentsOfURL:方法下载
    NSData *data = [NSData dataWithContentsOfURL:url];
    
     NSLog(@"%@",data);
    
}

- (void)loadFileNSURLConnection{
    // 创建下载路径
    NSURL *url = [NSURL URLWithString:@"http://pics.sc.chinaz.com/files/pic/pic9/201508/apic14052.jpg"];
    
    // 使用NSURLConnection发送异步GET请求，该方法在iOS9.0之后就废除了（推荐使用NSURLSession）
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSLog(@"%@",data);
        
        // 可以在这里把下载的文件保存起来
    }];
}


@end
