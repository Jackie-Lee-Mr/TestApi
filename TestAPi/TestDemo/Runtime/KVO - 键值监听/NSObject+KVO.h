//
//  NSObject+KVO.h
//  TestAPi
//
//  Created by jackie on 2018/6/9.
//  Copyright © 2018年 jackie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KVO)

- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;

@end
