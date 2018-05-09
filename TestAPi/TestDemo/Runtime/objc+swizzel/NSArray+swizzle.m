//
//  NSArray+swizzle.m
//  Runtime-more
//
//  Created by jackie on 2017/7/5.
//  Copyright © 2017年 jackie. All rights reserved.
//

#import "NSArray+swizzle.h"
#import <objc/runtime.h>

@implementation NSArray (swizzle)

+ (void)load {
    [super load];
    
    Method fromMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:));
    Method toMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(JACKIE_objectAtIndex:));
    method_exchangeImplementations(fromMethod, toMethod);
}

- (id)JACKIE_objectAtIndex:(NSUInteger)index {
    
    if (self.count-1 < index) {
        // 这里做一下异常处理，不然都不知道出错了。
        @try {
            return [self JACKIE_objectAtIndex:index];
        }
        @catch (NSException *exception) {
            // 在崩溃后会打印崩溃信息，方便我们调试。
            DLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            DLog(@"%@", [exception callStackSymbols]);
            return nil;
        }
        @finally {}
    } else {
        return [self JACKIE_objectAtIndex:index];
    }
}
@end
