//
//  FFMHomeModel.m
//  FFSales
//
//  Created by lin on 2018/6/7.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFMHomeModel.h"

@implementation FFMHomeModel

@end
@implementation FFMidentificationModel

@end
@implementation FFMBaseModel

@end
@implementation FFMInvoiceModel

@end
@implementation FFMBrandModel
+ (NSDictionary *)objectClassInArray{
    return @{@"brandNames" : [NSString class]
             };
}
@end
@implementation FFMUserModel
+ (NSDictionary *)objectClassInArray{
    return @{@"brandAreas" : [FFMBrandModel class]
             };
}
@end
