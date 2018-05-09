//
//  RuntimeStudentModel.m
//  Runtime-more
//
//  Created by jackie on 2017/7/5.
//  Copyright © 2017年 jackie. All rights reserved.
//

#import "RuntimeStudentModel.h"
#import <objc/runtime.h>

static const char *DYNAMICKEY = "dynamicKey";

@implementation RuntimeStudentModel

//-(instancetype)initWithCoder:(NSCoder *)aDecoder{
//    
//    if (self = [super init]) {
//        
//        self.name = [aDecoder decodeObjectForKey:@"name"];
//        self.fatherName = [aDecoder decodeObjectForKey:@"fatherName"];
//        self.matherName = [aDecoder decodeObjectForKey:@"matherName"];
//        self.height = [aDecoder decodeObjectForKey:@"height"];
//        self.year = [aDecoder decodeObjectForKey:@"year"];
//    }
//    
//    return self;
//}
//
//-(void)encodeWithCoder:(NSCoder *)aCoder{
//    
//    [aCoder encodeObject:self.name forKey:@"name"];
//    [aCoder encodeObject:self.fatherName forKey:@"fatherName"];
//    [aCoder encodeObject:self.matherName forKey:@"motherName"];
//    [aCoder encodeObject:self.height forKey:@"height"];
//    [aCoder encodeObject:self.year forKey:@"year"];
//    
//}

//********************************** 运行时原生动态遍历所有属性 *************************************

//程序运行时，就会把所有的类加载到内存，
+(void)load{
    
    
}
//第一次使用泪时，会调用这个方法
+(void)initialize{
    
    
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{

    if (self = [super init]) {

        unsigned int count = 0 ;
        
        objc_property_t *properties = class_copyPropertyList([self class], &count);
        
        for (int i = 0 ; i < count; i++) {
            
            const char *propertyName = property_getName(properties[i]);
            
            NSString *name = [NSString stringWithUTF8String:propertyName];
            
            id value = [aDecoder decodeObjectForKey:name];
            
            [self setValue:value forKey:name];
        }         
    }

    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{

    unsigned int count = 0;
    
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i<count; i++) {
        
        const char *charName = property_getName(properties[i]);
        
        NSString *name = [NSString stringWithUTF8String:charName];
        
        id value = [aCoder valueForKey:name];
        
        [aCoder encodeObject:value forKey:name];
    }

}

//********************************** MJ实现归档和解档 *************************************
//  遵守MJCoding

//- (void)encode:(NSCoder *)encoder
//{
//    [self enumerateIvarsWithBlock:^(MJIvar *ivar, BOOL *stop) {
//        if (ivar.isSrcClassFromFoundation) return;
//        [encoder encodeObject:ivar.value forKey:ivar.name];
//    }];
//}
//
///**
// *  解码（从文件中解析对象）
// */
//- (void)decode:(NSCoder *)decoder
//{
//    [self enumerateIvarsWithBlock:^(MJIvar *ivar, BOOL *stop) {
//        if (ivar.isSrcClassFromFoundation) return;
//        ivar.value = [decoder decodeObjectForKey:ivar.name];
//    }];
//}

// 我只想归档name和age属性，不想归档gay属性
//[Person setupIgnoredCodingPropertyNames:^NSArray *{
//    return @[@"gay"];
//}];

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    }

- (void)eatMethod{
  
    DLog(@"%s",__FUNCTION__);
    
}

- (void)runMethod{
    
    DLog(@"%s",__FUNCTION__);
    
}

- (void)workMethod{
    
   DLog(@"%s",__FUNCTION__);
    
}

- (void)getAllMethods{
    
    unsigned int count = 0;
    
    Method *methods = class_copyMethodList([self class],  &count);
    
    for (int i = 0; i<count; i++) {
        
        SEL m = method_getName(methods[i]);
        
        NSString *methodName = NSStringFromSelector(m);
        
        DLog(@"%@",methodName);
        
    }
    
}

// 所有的属性
- (void)getAllProperties{
    
    unsigned int count = 0;
    
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count;  i++) {
        
        const char *charName = property_getName(properties[i]);
        
        NSString* propertyName = [NSString stringWithUTF8String:charName];
        
        DLog(@"%@",propertyName);
    }
    
}
// 所有成员变量
- (void)getMemberVariable{
    
    unsigned int count = 0;
    
    Ivar *var = class_copyIvarList([self class], &count);
    
    for (int i = 0; i < count; i++) {
       
        const char *varName = ivar_getName(var[i]);
        
        NSString *name = [NSString stringWithUTF8String:varName];
        
        DLog(@"%@", name);
    }
    
}
//动态添加属性，主要使用到运行时关联
- (void)setDynamicProperty:(NSString*)propertyName{
    
    objc_setAssociatedObject(self, DYNAMICKEY, propertyName, OBJC_ASSOCIATION_COPY);
    
}

- (void)getDynamicProperty{
    
    objc_getAssociatedObject(self, DYNAMICKEY);
    
}

- (void)dynamicAddMethod{
    
    
}


@end
