//
//  FFCustomerModel.m
//  FFSales
//
//  Created by lin on 2018/6/21.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFCustomerModel.h"
@implementation FFCustomerItemModel
+ (NSDictionary *)objectClassInArray{
    return @{@"brandNames" : [NSString class]
             };
}
@end
@implementation FFCustomerModel
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [FFCustomerItemModel class]
             };
}
@end
