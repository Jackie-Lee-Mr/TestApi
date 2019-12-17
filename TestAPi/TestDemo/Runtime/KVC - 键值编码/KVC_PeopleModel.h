//
//  KVC_PeopleModel.h
//  TestAPi
//
//  Created by jackie on 2018/5/9.
//  Copyright © 2018年 jackie. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 KVC（Key-value coding）键值编码 ，会把基本数据类型，int 数值包装成NSNumber,可以访问对象的私有属性
 
 +(BOOL)accessInstanceVariablesDirectly
    return NO ，就不会去查找成员变量
    return YES ，才会去查找成员变量
 
  setValue:value forKey:key
 
 
 属性：setter ，getter ，成员变量(_key)
 
 Getter:
 
 valueForKey:name的调用顺序
 
     1.先查看(getter)方法是否实现，优先查找 getName ,name ,getIsName 是否实现，如果实现就不会走2 ， 如果都没有实现走2
 
     2.+(BOOL)accessInstanceVariablesDirectly，return NO ，return YES ->4 ( 查看变量 )
 
     3.优先查找 _name,_isName,name,isName,上述都没有的话
 
     0. valueForUndefinedKey ,抛出异常。
 
 Setter:
 
 setValue:value forKey:name
 
     1.先查看方法是否实现，优先查找 setName,setIsName 是否实现，如果实现就不会走2 ， 如果都没有实现走2
 
     2.+(BOOL)accessInstanceVariablesDirectly，return NO ，return YES ->4
 
     3.优先查找 _name,_isName,name,isName,上述都没有的话
 
     0. -(void)setValue:value forUndefinedKey: key 抛出异常
 
 
 */

@interface KVC_PeopleModel : NSObject{
    
    NSString *name;
    NSString *_name;
    
    NSString *isName;
    NSString *_isName;
}

@end
