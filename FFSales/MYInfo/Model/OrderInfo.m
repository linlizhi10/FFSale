//
//  OrderInfo.m
//  DaDong
//
//  Created by lin on 2018/3/2.
//  Copyright © 2018年 WintrueTeam. All rights reserved.
//

#import "OrderInfo.h"



@implementation OrderProduct

@end
@implementation OrderInfo
+ (NSDictionary *)objectClassInArray{
    return @{@"materials" : [OrderProduct class]
             };
}
//- (NSString *)orderStatusName{
//    if ([_orderStatus isEqualToString:@"2"] ) {
//        return @"待收货";
//
//    }else if([_orderStatus isEqualToString:@"1"] ){
//        return @"待支付";
//
//    }else if([_orderStatus isEqualToString:@"3"] ){
//        return @"退货中";
//
//    }else if([_orderStatus isEqualToString:@"4"] ){
//        return @"已退货";
//
//    }else if([_orderStatus isEqualToString:@"5"] ){
//        return @"换货中";
//
//    }else if([_orderStatus isEqualToString:@"6"] ){
//        return @"已完成";
//    }
//    return @"";
//}

@end
@implementation OrderInfoDetail
+ (NSDictionary *)objectClassInArray{
    return @{@"materials" : [OrderProduct class]
             };
}
//- (NSString *)orderStatusName{
//    if ([_status isEqualToString:@"2"] ) {
//        return @"待收货";
//        
//    }else if([_orderStatus isEqualToString:@"1"] ){
//        return @"待支付";
//        
//    }else if([_orderStatus isEqualToString:@"3"] ){
//        return @"退货中";
//        
//    }else if([_orderStatus isEqualToString:@"4"] ){
//        return @"已退货";
//        
//    }else if([_orderStatus isEqualToString:@"5"] ){
//        return @"换货中";
//        
//    }else if([_orderStatus isEqualToString:@"6"] ){
//        return @"已完成";
//    }
//    return @"";
//}
@end
