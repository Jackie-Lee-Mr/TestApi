//
//  NSObject+JKDebugDescription.m
//  TestAPi
//
//  Created by jackie on 2018/5/9.
//  Copyright © 2018年 jackie. All rights reserved.
//

#import "NSObject+JKDebugDescription.h"
#import <objc/runtime.h>

@implementation NSObject (JKDebugDescription)

+ (void)load {
    
    Method fromMethod = class_getInstanceMethod([self class], @selector(debugDescription));
    
    Method toMethod = class_getInstanceMethod([self class], @selector(JACKIE_debugDescription));
    
    method_exchangeImplementations(fromMethod, toMethod);
}

- (NSString *)JACKIE_debugDescription{
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
     unsigned int count = 0;
    
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count;  i++) {
        
        const char *charName = property_getName(properties[i]);
        
        NSString* propertyName = [NSString stringWithUTF8String:charName];
        
        id value = [self valueForKey:propertyName];
        
        [dictionary setValue: value forKey:propertyName];
    }
    
    free(properties);
    
    return  dictionary.jsonStringEncoded;
}


@end
