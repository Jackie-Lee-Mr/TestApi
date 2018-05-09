//
//  UIImage+swizzle.h
//  Runtime-more
//
//  Created by jackie on 2017/7/5.
//  Copyright © 2017年 jackie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (swizzle)

//运行时给分类添加属性
@property (nonatomic,copy) NSString* imageUrl;

@end

