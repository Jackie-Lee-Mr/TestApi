//
//  NSObject+JKKVC.h
//  TestAPi
//
//  Created by jackie on 2018/5/9.
//  Copyright © 2018年 jackie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JKKVC)

//-(id)JK_valueForKey:(NSString *)key;
-(void)JK_setValue:(id)value forKey:(NSString *)key;

@end
