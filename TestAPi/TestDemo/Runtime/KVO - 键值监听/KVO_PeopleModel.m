//
//  KVO_PeopleModel.m
//  TestAPi
//
//  Created by jackie on 2018/5/9.
//  Copyright © 2018年 jackie. All rights reserved.
//

#import "KVO_PeopleModel.h"

@implementation KVO_PeopleModel

-(void)setName:(NSString *)name{
    
    [self willChangeValueForKey:@"name"];
    
    [self setName:name];
    
    [self didChangeValueForKey:@"name"];
    
}



@end
