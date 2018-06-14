//
//  NSTimer+BlockTimer.m
//  BaseFoudation
//
//  Created by lin on 17/4/13.
//  Copyright © 2017年 lin. All rights reserved.
//

#import "NSTimer+BlockTimer.h"

@implementation NSTimer (BlockTimer)
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti block:(void (^)())block repeats:(BOOL)yesOrNo{
    return [self scheduledTimerWithTimeInterval:ti target:self selector:@selector(q_blockInvoke:) userInfo:[block copy] repeats:yesOrNo];
}

+ (void)q_blockInvoke:(NSTimer *)timer{
    void(^block)() = timer.userInfo;
    if (block) {
        block();
    }
}
@end
