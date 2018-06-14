//
//  FFProductModel.m
//  FFSales
//
//  Created by lin on 2018/6/1.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFProductModel.h"

@implementation FFProductModel

@end
@implementation FFProductListModel
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [FFProductModel class]
             };
}
@end
@implementation FFProductFactoryModel
@end
@implementation FFProductPropertiesModel
@end
@implementation FFProductDetailModel
+ (NSDictionary *)objectClassInArray{
    return @{@"properties" : [FFProductPropertiesModel class],
             @"picUrls" : [NSString class],
             @"detailUrls" : [NSString class],
             @"factorys" : [FFProductFactoryModel class],
             @"policies" : [NSString class]


             };
}
@end
