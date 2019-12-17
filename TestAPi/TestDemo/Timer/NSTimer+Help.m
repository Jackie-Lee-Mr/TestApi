//
//  NSTimer+Help.m
//  TestAPi
//
//  Created by jackie on 2019/2/28.
//  Copyright © 2019 jackie. All rights reserved.
//

#import "NSTimer+Help.h"

@implementation NSTimer (Help)

//将nstimer的target指向NSTimer类和类方法
+ (NSTimer *)helper_scheduedTimerWithTimeInterval:(NSTimeInterval)seconds
                                            block:(void (^)(id))block
                                         userinfo:(id)userinfo
                                          repeats:(BOOL)repeats
{
    return [NSTimer scheduledTimerWithTimeInterval:seconds
                                            target:self
                                          selector:@selector(helper_block:)
                                          userInfo:@[[block copy] , userinfo]
                                           repeats:repeats];
}
//在类方法中回调block
+ (void)helper_block:(NSTimer *)timer
{
    NSArray *infoArr = timer.userInfo;
    void (^myblock)(id userinfo) = infoArr[0];
    id info = infoArr[1];
    
    if (myblock) {
        myblock(info);
    }
}
@end
