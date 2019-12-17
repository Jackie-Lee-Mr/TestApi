//
//  NSObject+JKKVC.m
//  TestAPi
//
//  Created by jackie on 2018/5/9.
//  Copyright © 2018年 jackie. All rights reserved.
//

#import "NSObject+JKKVC.h"
#import <objc/runtime.h>

@implementation NSObject (JKKVC)

-(void)JK_setValue:(id)value forKey:(NSString *)key{
    
    if (value == nil || key.length == 0) {
        
        NSException *exception = [NSException exceptionWithName:@"JK_KVO_Exception" reason:@"Value must not be nil" userInfo:nil];
        
        @throw exception;
        
        return;
        
    }
    
    //如果value基本数据类型，包装成对象
    NSString *setKey = [NSString stringWithFormat:@"%@:",key.capitalizedString];
    
    if ([self respondsToSelector:NSSelectorFromString(setKey)]) {
        
        [self performSelector:NSSelectorFromString(setKey) withObject:value];
        
        return;
    }
    
    
    NSString *setIsKey = [NSString stringWithFormat:@"setIs%@:",key.capitalizedString];
    
    if ([self respondsToSelector:NSSelectorFromString(setIsKey)]) {
        
        [self performSelector:NSSelectorFromString(setIsKey) withObject:value];
        
        return;
    }
    
    if (![self.class accessInstanceVariablesDirectly]) {
        
        NSException *exception = [NSException exceptionWithName:@"JK_KVO_Exception" reason:@"accessInstanceVariablesDirectly return NO, can‘t access variables" userInfo:nil];
        
        @throw exception;
        
        return;
        
    }
    
    unsigned int  count =  0;
    
    Ivar *ivars = class_copyIvarList(self.class,&count);
    
//    for (NSInteger i = 0; i < count; i++) {
//
//
//
//
//    }
    
    
}

+(BOOL)accessInstanceVariablesDirectly{
    
    return  YES;
}

@end
