//
//  NSObject+KVO.m
//  TestAPi
//
//  Created by jackie on 2018/6/9.
//  Copyright © 2018年 jackie. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/message.h>
/**
 KVO原理：
 Apple 使用了 isa 混写（isa-swizzling）来实现 KVO 。当观察对象A时，KVO机制动态创建一个新的名为： NSKVONotifying_A的新类，该类继承自对象A的本类，且KVO为NSKVONotifying_A重写观察属性的setter 方法，setter 方法会负责在调用原 setter 方法之前和之后，通知所有观察对象属性值的更改情况。（备注： isa 混写（isa-swizzling）isa：is a kind of ； swizzling：混合，搅合；）
 ①NSKVONotifying_A类剖析：在这个过程，被观察对象的 isa 指针从指向原来的A类，被KVO机制修改为指向系统新创建的子类 NSKVONotifying_A类，来实现当前类属性值改变的监听；
 所以当我们从应用层面上看来，完全没有意识到有新的类出现，这是系统“隐瞒”了对KVO的底层实现过程，让我们误以为还是原来的类。但是此时如果我们创建一个新的名为“NSKVONotifying_A”的类()，就会发现系统运行到注册KVO的那段代码时程序就崩溃，因为系统在注册监听的时候动态创建了名为NSKVONotifying_A的中间类，并指向这个中间类了。（isa 指针的作用：每个对象都有isa 指针，指向该对象的类，它告诉 Runtime 系统这个对象的类是什么。所以对象注册为观察者时，isa指针指向新子类，那么这个被观察的对象就神奇地变成新子类的对象（或实例）了。） 因而在该对象上对 setter 的调用就会调用已重写的 setter，从而激活键值通知机制。
 —>我猜，这也是KVO回调机制，为什么都俗称KVO技术为黑魔法的原因之一吧：内部神秘、外观简洁。
 ②子类setter方法剖析：KVO的键值观察通知依赖于 NSObject 的两个方法:willChangeValueForKey:和 didChangevlueForKey:，在存取数值的前后分别调用2个方法：被观察属性发生改变之前，willChangeValueForKey:被调用，通知系统该 keyPath 的属性值即将变更；当改变发生后， didChangeValueForKey: 被调用，通知系统该 keyPath 的属性值已经变更；之后observeValueForKey:ofObject:change:context: 也会被调用。且重写观察属性的setter 方法这种继承方式的注入是在运行时而不是编译时实现的。
 
 总结：当一个对象的属性被观察时，系统会动态的创建一个对象的派生类，继承自该类，
 
 */


@implementation NSObject (KVO)

 
- (void)JJ_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context{
    /**
     1.动态添加一个类
     */
    NSString *oldClassName = NSStringFromClass([self class]);
    NSString *newClassName = [@"JJKVO_" stringByAppendingString:oldClassName];
    const char *newName = [newClassName UTF8String];

    //2.定义一个类
    Class  myClass  = objc_allocateClassPair([self class], newName, 0);

    // 3.重写setAge方法
    class_addMethod(myClass, @selector(setAge:), (IMP)setAge, "");

    //4.注册这个类
    objc_registerClassPair(myClass);

    //5.改变isa指针,内存地址不变，但是类型会变
    object_setClass(self, myClass);


}


/**
  

 @param self :每个函数都有的隐式参数
 @param _cmd ：每个函数都有的隐式参数 方法的编号

 @param age
 */
void setAge(id self , SEL _cmd ,int age){
    id class = [self class];

    object_setClass(self, class_getSuperclass([self class]));

    objc_msgSend(self, @selector(setAge:),age);

    object_setClass(self, class);

}

@end
