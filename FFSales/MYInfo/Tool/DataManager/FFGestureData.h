//
//  FFGestureData.h
//  FFSales
//
//  Created by lin on 2018/6/22.
//  Copyright © 2018年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSString * GestureCodeString = @"gestureCode";
static NSString * GestureStateString = @"gestureState";
static NSString * GestureCounteString = @"gestureCount";

@interface FFGestureData : NSObject

+ (void)updateCount:(NSInteger)count key:(NSString *)key;
+ (void)insertGestureCode:(NSString *)gestureCode key:(NSString *)key;
+ (void)insertGestureState:(NSString *)state key:(NSString *)key;
+ (NSString *)getGetureCode:(NSString *)key;
+ (BOOL)getGetureState:(NSString *)key;
+ (NSInteger)getGestureCount:(NSString *)key;

@end
