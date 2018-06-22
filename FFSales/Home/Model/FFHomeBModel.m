//
//  FFHomeBModel.m
//  FFSales
//
//  Created by lin on 2018/6/1.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFHomeBModel.h"

@implementation FFHomeBModel

@end
@implementation FFHomeBAModel
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [FFHomeBModel class]
             };
}
@end
@implementation FFHomeBrand
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"brandId" : @"id"
             };
}
+ (NSString *)propertyKey:(NSString *)propertyName{
    NSString *key;
    if ([self respondsToSelector:@selector(replacedKeyFromPropertyName)]) {
        key = [self replacedKeyFromPropertyName][propertyName];
    }
    return key?:propertyName;
}
@end
@implementation FFHomeBrandA
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [FFHomeBrand class]
             };
}
@end
@implementation FFHomeEMP

@end
