//
//  FIUser.h
//  finance
//
//  Created by 汤军 on 17/5/8.
//  Copyright © 2017年 李传政. All rights reserved.
//

#import "Model.h"

@interface FIUser : Model

typedef NS_OPTIONS(NSUInteger, UserType) {
    UserTypeVisiter = 0,//游客
    UserTypeCustom = 1,//用户
    UserTypeShopOwer = 2,//店主
};

@property (assign, nonatomic) BOOL loginStatus; //登录状态 yes登录，no 未登录
@property (assign, nonatomic)UserType userType; //用户类型 customer：客户，shop：商家
@property (copy, nonatomic) NSString *salesName;
@property (copy, nonatomic) NSString *phone; //手机号
@property (copy, nonatomic) NSString *salesNo;
@property (copy, nonatomic) NSString *rateType;


@property (copy, nonatomic) NSString *shopName; //
@property (copy, nonatomic) NSString *serviceLvL; //
@property (copy, nonatomic) NSString *exclusiveMemberNum; //专属会员个数
@property (copy, nonatomic) NSString *imgUrl; //
@property (copy, nonatomic) NSString *qrCode; //
@property (copy, nonatomic) NSString *shopAddress; //
@property (copy, nonatomic) NSString *role; //

@property (copy, nonatomic) NSString *longitude; //
@property (copy, nonatomic) NSString *latitude; //
/*
@property (copy, nonatomic) NSString *provinceName; //
@property (copy, nonatomic) NSString *provinceCode; //

@property (copy, nonatomic) NSString *cityName; //
@property (copy, nonatomic) NSString *cityCode; //
@property (copy, nonatomic) NSString *areaName; //
@property (copy, nonatomic) NSString *areaCode; //

@property (copy, nonatomic) NSString *shopID; //
@property (copy, nonatomic) NSString *salesID; //
*/

//lcz add 4.23
@property (copy, nonatomic) NSString *shopID; //
@property (copy, nonatomic) NSString *shopNo; //
@property (copy, nonatomic) NSString *provinceCode; //
@property (copy, nonatomic) NSString *salesID; //
@property (copy, nonatomic) NSString *cityCode; //
@property (copy, nonatomic) NSString *areaCode; //
@property (copy, nonatomic) NSString *accessToken; //

+ (instancetype)shareUser;
+ (void)clearUerInfo;
- (void)dataSet:(FIUser *)user;
@end
