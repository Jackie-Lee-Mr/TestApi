//
//  MessageSendVC.m
//  TestAPi
//
//  Created by jackie on 2018/4/10.
//  Copyright © 2018年 jackie. All rights reserved.
//

/**
 
 原因是我们调用了一个不存在的方法。用OC消息机制来说就是：消息的接收者不过到对应的selector，这样就启动了消息转发机制，我们可以通过代码在消息转发的过程中告诉对象应该如何处理未知的消息，默认实现是抛出下面的异常
 
 下面我们通过实例来看一下在抛出异常之前也就是消息转发过程中都经过了哪些步骤：
 
 
 */

#import "MessageSendVC.h"
#import "MessagePeopleModel.h"

@interface MessageSendVC ()


@end

@implementation MessageSendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performSelector:@selector(oneMoreTestMessage)];
    /*
     第一步：对象在收到无法解读的消息后，首先会调用+(BOOL)resolveInstanceMethod:(SEL)sel或者+ (BOOL)resolveClassMethod:(SEL)sel, 询问是否有动态添加方法来进行处理，如果有，就提前结束消息转发，如果没有
     
     第二步：既然第一步已经问过了，没有新增方法，那就问问有没有别人能够帮忙处理一下啊，调用的是- (id)forwardingTargetForSelector:(SEL)aSelector这个方法，如果还没有
     
     第三步：调用- (void)forwardInvocation:(NSInvocation *)anInvocation，在调用forwardInvocation:之前会调用- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector方法来获取这个选择子的方法签名，然后在-(void)forwardInvocation:(NSInvocation *)anInvocation方法中你就可以通过anInvocation拿到相应信息做处理
     
     */ 
}

//-(void)test{
//    
//    NSLog(@"test");
//}

#pragma mark **************  Runtime消息转发    ********************

/**
 https://user-gold-cdn.xitu.io/2018/4/1/1628088a3e48a485?imageView2/0/w/1280/h/960/ignore-error/1
 动态方法解析:此消息没有实现，是否有动态添加的方法，如果没有，就发消息问有没有其他对象可以接收此消息，如果没有就签名
 备用接收者
 完整消息转发
 
 */

/**
 
   动态方法解析
 
 */
/**
   第一步：动态方法解析
 
 */
void testMessage(id self, SEL _cmd){

    NSLog(@"testMessage");
}

+ (BOOL)resolveInstanceMethod:(SEL)sel{

//    NSException *exception = [NSException exceptionWithName:@"Message Send" reason:@"No selector " userInfo:@{
//                                                                                                              @"VC_Name":NSStringFromClass([self class])
//
//                                                                                                              } ];
//    @throw exception;

    if (sel == @selector(test)) {
        
         /**
         *  i(类型为int)
         *  v(类型为void)
         *  @(类型为id)
         *  :(类型为SEL)
          
          V@:(V-返回值 ，@-id ，：sel ) 对应于 void testMessage(id self, SEL _cmd)的参数
         */
      
        class_addMethod([self class], sel, (IMP)testMessage, "v@:@:");

        /**
         如果是实例方法会首选调用上文的resolveInstanceMethod:方法，方法内通过判断选择子然后通过class_addMethod方法动态添加了一个testMessage的实现方法来解决掉这条未知的消息，此时消息转发过程提前结束。
         但是当self 收到oneMoreTestMessage这条未知消息的时候，第一步返回的是No，也就是没有动态新增实现方法的时候就会调用第二步

         */

        return YES;
    }

    return [super resolveClassMethod:sel];
}
/**
 第二步：备援接受者
 既然第一步已经问过了，没有新增方法，那就问问有没有别人能够帮忙处理一下啊，调用的是- (id)forwardingTargetForSelector:(SEL)aSelector这个方法
 我们说到MessagePeopleModel接收到了一条选择子为oneMoreTestMessage的未知消息，我们可以看到控制台已经打印了resolveInstanceMethod: oneMoreTestMessage，代表第一步已经问过了，那么第二步问一下是否有别的类能帮忙处理吗？代码如下：
 
 
 */

- (id)forwardingTargetForSelector:(SEL)aSelector{
    
    MessagePeopleModel *people = [MessagePeopleModel new];
    
    if ([people respondsToSelector:aSelector]) {
        
        return people;
    }
    
    return [super forwardingTargetForSelector:aSelector];
}

/**
 第三步：完整的消息转发
 
 但是如果- (id)forwardingTargetForSelector:(SEL)aSelector也找不到能够帮忙处理这条未知消息，那就会走到最后一步，这步也是代价最大的一步
 
 调用- (void)forwardInvocation:(NSInvocation *)anInvocation，在调用forwardInvocation:之前会调用- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector方法来获取这个选择子的方法签名，然后在-(void)forwardInvocation:(NSInvocation *)anInvocation方法中你就可以通过anInvocation拿到相应信息做处理，实例代码如下
 
 */
//获取方法签名，然后再调用
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    
    NSLog(@"%s",__func__);
    
    NSString *method = NSStringFromSelector(aSelector);
    
    if ([@"oneMoreTestMessage" isEqualToString:method]) {
        
        NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:"v@:@:"];
        
        return signature;
        
    }
    
//    @synchronized;
//    @dynamic：属性的setter与getter方法由用户自己实现，不自动生成
//    @synthesize:如果没有收到实现setter 和 getter 方法 ，那么在编译的会自动加上这两个方法。（ 那么默认的就是@syntheszie var = _var; ） 
    
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    
    MessageOtherPeopleModel *otherPeople = [[MessageOtherPeopleModel  alloc] init];
    
    if ([otherPeople respondsToSelector:[anInvocation selector]]) {
        
        [anInvocation invokeWithTarget:otherPeople];
        
    }else{
        
        [super forwardInvocation:anInvocation];
    }
    
    NSLog(@"forwardInvocation: %@", NSStringFromSelector([anInvocation selector]));
    
    NSLog(@"%s",__func__);
    
}

- (void)doesNotRecognizeSelector:(SEL)aSelector{
    
    NSString *selStr = [NSString stringWithFormat:@"不存在 %@ 方法",NSStringFromSelector(aSelector)];
    
    UIAlertController *messageVC  = [UIAlertController alertControllerWithTitle:@"提示" message:selStr preferredStyle:UIAlertControllerStyleAlert];
    
    [messageVC addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
    } ]];
    
    [self presentViewController:messageVC animated:YES completion:nil];
    
    
}

@end
