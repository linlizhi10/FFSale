//
//  FFGestureData.m
//  FFSales
//
//  Created by lin on 2018/6/22.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFGestureData.h"

@implementation FFGestureData
+ (void)updateCount:(NSInteger)count key:(NSString *)key{
    
    [[NSUserDefaults standardUserDefaults] setInteger:count  forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
+ (void)insertGestureCode:(NSString *)gestureCode key:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setObject:gestureCode forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)insertGestureState:(NSString *)state key:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setObject:state forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getGetureCode:(NSString *)key{
   return  [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
+ (BOOL)getGetureState:(NSString *)key{
    NSString *str = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    if ([str isEqualToString:@"open"]) {
        return YES;
    }else{
        return NO;
    }
}
+ (NSInteger)getGestureCount:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}
@end
