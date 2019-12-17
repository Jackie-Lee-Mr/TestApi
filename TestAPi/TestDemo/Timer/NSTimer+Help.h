//
//  NSTimer+Help.h
//  TestAPi
//
//  Created by jackie on 2019/2/28.
//  Copyright © 2019 jackie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (Help)

+ (NSTimer *)helper_scheduedTimerWithTimeInterval:(NSTimeInterval)seconds
                                            block:(void(^)(id info))block
                                         userinfo:(id)userinfo
                                          repeats:(BOOL)repeats;

@end

NS_ASSUME_NONNULL_END
