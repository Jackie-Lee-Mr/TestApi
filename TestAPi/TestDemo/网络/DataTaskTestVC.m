//
//  DataTaskTestVC.m
//  TestAPi
//
//  Created by jackie on 2018/3/27.
//  Copyright © 2018年 jackie. All rights reserved.
//

#import "DataTaskTestVC.h"

/**
 1.NSURLSessionTask
     NSURLSessionTask 是一个抽象类，如果要使用那么只能使用它的子类
     NSURLSessionTask 有两个子类:
         1.NSURLSessionDataTask,可以用来处理一般的网络请求，如 GET | POST 请求等
             有一个子类为 NSURLSessionUploadTask,用于处理上传请求
        2.NSURLSessionDownloadTask,主要用于处理下载请求，有很大的优势
 
 http://cc.cocimg.com/api/uploads/20161017/1476705225200087.png
 NSURLSessionTask:
     1.NSURLSessionDataTask:(可以用来处理一般的网络请求，如 GET | POST 请求等)--->NSURLSessionUploadTask:(用于处理上传请求)
     2.NSURLSessionDownloadTask:(主要用于处理下载请求，有很大的优势)
 
 
 */
@interface DataTaskTestVC ()<NSURLSessionDelegate>

@property (nonatomic,strong) NSMutableData *dataM;

@end

@implementation DataTaskTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
 }


 /****************************  block   *********************************/

- (void)sessionDataTaskGetReturnBlock{
    //确定请求路径
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login?username=520&pwd=520&type=JSON"];
    //创建 NSURLSession 对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    /**
     根据对象创建 Task 请求
     
     url  方法内部会自动将 URL 包装成一个请求对象（默认是 GET 请求）
     completionHandler  完成之后的回调（成功或失败）
     
     param data     返回的数据（响应体）
     param response 响应头
     param error    错误信息
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:
                                      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                          
              //解析服务器返回的数据
              NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
              //默认在子线程中解析数据
              NSLog(@"%@", [NSThread currentThread]);
              // 回到主线程刷新UI
              //1.NSThread
//              [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
              //2.NSOperationQueue
//              [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                  [self updateUI];
//
//              }];
              //3.GCD
//              dispatch_async(dispatch_get_main_queue(), ^{
//                  [self updateUI];
//              });
               
              
                                      }];
    //发送请求（执行Task）
    [dataTask resume];
    
    
}

- (void)sessionDataPostReturnBlock{
    //确定请求路径
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login"];
    //创建可变请求对象
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:url];
    //修改请求方法
    requestM.HTTPMethod = @"POST";
    //设置请求体
    requestM.HTTPBody = [@"username=520&pwd=520&type=JSON" dataUsingEncoding:NSUTF8StringEncoding];
    //创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    //创建请求 Task
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:requestM completionHandler:
                                      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {//在子线程
                                          
                                          //解析返回的数据
                                          NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                      }];
    //发送请求
    [dataTask resume];
    
}

- (void)sessionDownLoadTaskBlock{
   
    //确定请求路径
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/images/minion_02.png"];
    //创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    //创建会话请求
    //优点：该方法内部已经完成了边接收数据边写沙盒的操作，解决了内存飙升的问题
    NSURLSessionDownloadTask *downTask = [session downloadTaskWithRequest:request
                                                        completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                            
                //默认存储到临时文件夹 tmp 中，需要剪切文件到 cache
                NSLog(@"%@", location);//目标位置
                NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
                                      stringByAppendingPathComponent:response.suggestedFilename];
                
                /**
                 fileURLWithPath:有协议头
                 URLWithString:无协议头
                 */
                [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:fullPath] error:nil];
                                                            
                                                        }];
    //发送请求
    [downTask resume];
    
}

/**************************** 设置代理 *********************************/
/**
     NSURLSessionDataTask 设置代理发送请求
 
 设置代理之后的强引用问题
 NSURLSession 对象在使用的时候，如果设置了代理，那么 session 会对代理对象保持一个强引用，在合适的时候应该主动进行释放
 可以在控制器调用 viewDidDisappear 方法的时候来进行处理，可以通过调用 invalidateAndCancel 方法或者是 finishTasksAndInvalidate 方法来释放对代理对象的强引用
 invalidateAndCancel 方法直接取消请求然后释放代理对象
 finishTasksAndInvalidate 方法等请求完成之后释放代理对象。
 [self.session finishTasksAndInvalidate];
 
 
 */

- (void)sessionDataTaskDelegate{
    
    //确定请求路径
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login"];
    //创建可变请求对象
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:url];
    //设置请求方法
    requestM.HTTPMethod = @"POST";
    //设置请求体
    requestM.HTTPBody = [@"username=520&pwd=520&type=JSON" dataUsingEncoding:NSUTF8StringEncoding];
    //创建会话对象，设置代理
    /**
     第一个参数：配置信息
     第二个参数：设置代理
     第三个参数：队列，如果该参数传递nil 那么默认在子线程中执行
     */
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:self delegateQueue:nil];
    //创建请求 Task
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:requestM];
    //发送请求
    [dataTask resume];
    
}

-(void)URLSession:(NSURLSession *)session dataTask:(nonnull NSURLSessionDataTask *)dataTask
didReceiveResponse:(nonnull NSURLResponse *)response
completionHandler:(nonnull void (^)(NSURLSessionResponseDisposition))completionHandler {
    //子线程中执行
    NSLog(@"接收到服务器响应的时候调用 -- %@", [NSThread currentThread]);
    
    self.dataM = [NSMutableData data];
    //默认情况下不接收数据
    //必须告诉系统是否接收服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);
}
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    NSLog(@"接受到服务器返回数据的时候调用,可能被调用多次");
    //拼接服务器返回的数据
    [self.dataM appendData:data];
}
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    NSLog(@"请求完成或者是失败的时候调用");
    //解析服务器返回数据
    NSLog(@"%@", [[NSString alloc] initWithData:self.dataM encoding:NSUTF8StringEncoding]);
}

/**
 
 NSURLSessionDataTask 简单下载
 */

- (void)sessionDataSampleDownload{
    
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:
                                                    @"http://120.25.226.186:32812/resources/images/minion_01.png"]
                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                     
                 //解析数据
                 UIImage *image = [UIImage imageWithData:data];
                 //回到主线程设置图片
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     [self updateUI];
                     
                 });
                                     
                                 }] resume];
    
    
}

- (void)updateUI {
    // UI更新代码
    
}
 




@end
