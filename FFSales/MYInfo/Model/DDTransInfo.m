//
//  DDTransInfo.m
//  DaDong
//
//  Created by lin on 2018/6/7.
//  Copyright © 2018年 WintrueTeam. All rights reserved.
//

#import "DDTransInfo.h"
@implementation DDSubInfo

@end

@implementation DDTransInfo

+ (NSDictionary *)objectClassInArray{
    return @{@"deliveryInfos" : [DDSubInfo class]
             };
}
@end
