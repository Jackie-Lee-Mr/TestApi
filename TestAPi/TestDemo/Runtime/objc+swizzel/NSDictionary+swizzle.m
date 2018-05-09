//
//  NSDictionary+swizzle.m
//  Runtime-more
//
//  Created by jackie on 2017/7/5.
//  Copyright © 2017年 jackie. All rights reserved.
//

#import "NSDictionary+swizzle.h"
#import <objc/runtime.h>

@implementation NSDictionary (swizzle)

+ (void)load {
    [super load];
    //setObject:forKey:
    Method fromMethod1 = class_getInstanceMethod(objc_getClass("__NSDictionaryI"), @selector(setObject:forKey:));
    
    Method toMethod1 = class_getInstanceMethod(objc_getClass("__NSDictionaryI"), @selector(JACKIE_objcSetObject:forKey:));
    
    method_exchangeImplementations(fromMethod1, toMethod1);
    
    //dictionaryWithObject:forKey:
    Method fromMethod2 = class_getInstanceMethod(objc_getClass("__NSDictionaryI"), @selector(dictionaryWithObject:forKey:));
    
    Method toMethod2 = class_getInstanceMethod(objc_getClass("__NSDictionaryI"), @selector(JACKIE_objcDictionaryWithObject:forKey:));
    
    method_exchangeImplementations(fromMethod2, toMethod2);
    
}


- (void)JACKIE_objcSetObject:(id)object forKey:(NSString*)key{
    
    if (object == nil) {
        // 这里做一下异常处理，不然都不知道出错了。
        @try {
             [self JACKIE_objcSetObject:object forKey:key];
        }
        @catch (NSException *exception) {
            // 在崩溃后会打印崩溃信息，方便我们调试。
            DLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            DLog(@"%@", [exception callStackSymbols]);
            return;
        }
        @finally {}
    } else {
       
        [self JACKIE_objcSetObject:object forKey:key];
        
    }     
}

- (void)JACKIE_objcDictionaryWithObject:(id)object forKey:(NSString*)key{
    
    if (object == nil) {
        // 这里做一下异常处理，不然都不知道出错了。
        @try {
            [self JACKIE_objcDictionaryWithObject:object forKey:key];
        }
        @catch (NSException *exception) {
            // 在崩溃后会打印崩溃信息，方便我们调试。
            DLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            DLog(@"%@", [exception callStackSymbols]);
            return;
        }
        @finally {}
    } else {
        
        [self JACKIE_objcDictionaryWithObject:object forKey:key];
        
    }
    
}




@end
