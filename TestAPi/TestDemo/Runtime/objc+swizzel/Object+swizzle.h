//
//  Object+swizzle.h
//  Runtime-more
//
//  Created by jackie on 2017/7/5.
//  Copyright © 2017年 jackie. All rights reserved.
//

#ifndef Object_swizzle_h
#define Object_swizzle_h

#ifdef DEBUG
# define DLog(format, ...) NSLog((@"[文件名:%s]" "[函数名:%s]" "[行号:%d]" format), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define DLog(...);
#endif


#import "UIImage+swizzle.h"
#import "NSArray+swizzle.h"
#import "NSMutableArray+swizzle.h"
#import "NSDictionary+swizzle.h"
#import "NSMutableDictionary+swizzle.h"
#import "NSObject+JKDebugDescription.h"



#endif /* Object_swizzle_h */
