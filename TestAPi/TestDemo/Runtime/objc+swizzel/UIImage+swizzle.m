//
//  UIImage+swizzle.m
//  Runtime-more
//
//  Created by jackie on 2017/7/5.
//  Copyright © 2017年 jackie. All rights reserved.
//

#import "UIImage+swizzle.h"
#import <objc/runtime.h>
 

static const char  *IMAGEURLKEY = "imageUrl";

@implementation UIImage (swizzle)

+(void)load{
    [super load];
// image swizzle
    SEL fromSel = @selector(imageNamed:);
    SEL toSel = @selector(JACKIE_objc_ImageName:);
    
    Method fromMethod = class_getInstanceMethod([self class], fromSel);
    Method toMethod = class_getInstanceMethod([self class],toSel);
    
 //***************** 严谨做法 **************************
    BOOL didAddMethod = class_addMethod([self class], fromSel, method_getImplementation(toMethod), method_getTypeEncoding(toMethod));
    
    if (didAddMethod) {
        
        class_replaceMethod([self class], toSel, method_getImplementation(fromMethod), method_getTypeEncoding(toMethod));
        
    }else{
        
        method_exchangeImplementations(fromMethod, toMethod);
    }
    
//*******************简单做法*****************************
    
  /*
    
   method_exchangeImplementations(fromMethod, toMethod);
   
   */
    
}

- (void)setImageUrl:(NSString *)imageUrl{
    
    objc_setAssociatedObject(self, IMAGEURLKEY, imageUrl, OBJC_ASSOCIATION_COPY);
    
}

- (NSString *)imageUrl{
    
   return  objc_getAssociatedObject(self, IMAGEURLKEY);
    
}

- (void)JACKIE_objc_ImageName:(NSString*)imageName{
    
    [self JACKIE_objc_ImageName:imageName];
}


@end
