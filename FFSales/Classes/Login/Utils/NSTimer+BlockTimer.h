//
//  NSTimer+BlockTimer.h
//  BaseFoudation
//
//  Created by lin on 17/4/13.
//  Copyright © 2017年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (BlockTimer)
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti block:(void (^)())block repeats:(BOOL)yesOrNo;
@end
