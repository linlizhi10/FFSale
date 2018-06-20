//
//  FFGoodsHistory.m
//  FFSales
//
//  Created by lin on 2018/6/20.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFGoodsHistory.h"
@implementation FFGoodsHistoryItem

@end
@implementation FFGoodsHistory
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [FFGoodsHistoryItem class]
             };
}
@end
