//
//  FFMoneyRequest.h
//  FFSales
//
//  Created by lin on 2018/6/13.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "Request.h"

@interface FFMoneyRequest : Request
@property (nonatomic, copy) NSString *custId; //
@property (nonatomic, copy) NSString *accessToken; //
@end

@interface FFMoneyBRequest : Request
@property (nonatomic, copy) NSString *custId; //
@property (nonatomic, copy) NSString *accessToken; //
@end
@interface FFMoneyCRequest : Request
@property (nonatomic, copy) NSString *custId; //
@property (nonatomic, copy) NSString *accessToken; //
@end
@interface FFOtherMoneyCRequest : Request
@property (nonatomic, copy) NSString *custId; //
@property (nonatomic, copy) NSString *accessToken; //
@end
@interface FFBackMoneyCRequest : Request
@property (nonatomic, copy) NSString *custId; //
@property (nonatomic, copy) NSString *accessToken; //
@end
@interface FFCreaditSubRequest : Request
@property (nonatomic, copy) NSString *custId; //
@property (nonatomic, copy) NSString *accessToken; //
@property (nonatomic, copy) NSString *serviceType; //
@property (nonatomic, copy) NSString *childrenAccountType; //
@end
@interface FFCreaditDRequest : Request
@property (nonatomic, copy) NSString *accountId; //
@property (nonatomic, copy) NSString *accessToken; //
@end

@interface FFHistoryRequest : Request
@property (nonatomic, copy) NSString *custId; //
@property (nonatomic, copy) NSString *accessToken; //
@property (nonatomic, copy) NSString *serviceType; //
@property (nonatomic, copy) NSString *childrenAccountType; //
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int size;

@end

@interface FFListRequest : Request
@property (nonatomic, copy) NSString *custId; //
@property (nonatomic, copy) NSString *accessToken; //
@property (nonatomic, copy) NSString *fundType; //
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int size;

@end
