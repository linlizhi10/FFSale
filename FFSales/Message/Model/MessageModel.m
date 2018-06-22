//
//  MessageModel.m
//  FFSales
//
//  Created by lin on 2018/6/21.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "MessageModel.h"
@implementation MessageExtraModel

@end
@implementation MessageItemModel

@end
@implementation MessageModel
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [MessageItemModel class]
             };
}
@end
