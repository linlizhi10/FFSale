//
//  MoneyModel.m
//  FFSales
//
//  Created by lin on 2018/6/13.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "MoneyModel.h"
@implementation MoneySmallModel

@end


@implementation moneyTypeModel
+ (NSDictionary *)objectClassInArray{
    return @{@"records" : [MoneySmallModel class]
             };
}
@end
@implementation MoneyModel
+ (NSDictionary *)objectClassInArray{
    return @{@"accountInfos" : [moneyTypeModel class]
             };
}
@end
@implementation creaditSmallModel

@end
@implementation creaditTypeModel
+ (NSDictionary *)objectClassInArray{
    return @{@"accountInfos" : [creaditSmallModel class]
             };
}
@end
@implementation creaditModel
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [creaditTypeModel class]
             };
}
@end
@implementation SubCreaditSmallModel

@end
@implementation SubCreaditModel
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [SubCreaditSmallModel class]
             };
}
@end
@implementation CreaditDetailModel

@end

@implementation SubHistoryModel

@end
@implementation HistoryModel
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [SubHistoryModel class]
             };
}
@end


@implementation OtherMoneySmallModel

@end


@implementation OtherMoneyTypeModel
+ (NSDictionary *)objectClassInArray{
    return @{@"accountInfos" : [OtherMoneySmallModel class]
             };
}
@end
@implementation OtherMoney
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [OtherMoneyTypeModel class]
             };
}
@end


@implementation BackMoneyTypeModel

@end
@implementation BackMoney
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [BackMoneyTypeModel class]
             };
}
@end
@implementation ListSubModel

@end
@implementation ListModel
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [ListSubModel class]
             };
}
@end
