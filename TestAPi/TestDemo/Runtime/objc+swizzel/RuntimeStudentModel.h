//
//  RuntimeStudentModel.h
//  Runtime-more
//
//  Created by jackie on 2017/7/5.
//  Copyright © 2017年 jackie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RuntimeStudentModel : NSObject<NSCoding>

@property (nonatomic,copy)    NSString* name;
@property (nonatomic,strong)  NSNumber* height;
@property (nonatomic,strong)    NSNumber* number;
@property (nonatomic,strong)    NSNumber* year;
@property (nonatomic,copy) NSString* fatherName;
@property (nonatomic,copy) NSString* matherName;

- (void)eatMethod;
- (void)runMethod;
- (void)workMethod;

- (void)getAllMethods;
- (void)getAllProperties;
- (void)getMemberVariable;

//动态添加属性，主要使用到运行时关联
- (void)setDynamicProperty:(NSString*)propertyName;
- (void)getDynamicProperty;
- (void)dynamicAddMethod;

@end
