//
//  FFGoodsHistory.h
//  FFSales
//
//  Created by lin on 2018/6/20.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "Model.h"
@interface FFGoodsHistoryItem : Model
@property (nonatomic, copy) NSString *pickupId;
@property (nonatomic, copy) NSString *custName;
@property (nonatomic, copy) NSString *sapNo;
@property (nonatomic, copy) NSString *contacts;
@property (nonatomic, copy) NSString *custTel;
@property (nonatomic, copy) NSString *salesman;
@property (nonatomic, copy) NSString *salesmanTel;
@property (nonatomic, assign) int status;//状态，1：开票，0：待处理，-1：驳回
@property (nonatomic, copy) NSString *note;
@property (assign, nonatomic) long createdTime;
@property (assign, nonatomic) long invoiceTime;
@property (nonatomic, copy) NSString *sysUserId;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *reason;
@end

@interface FFGoodsHistory : Model
@property (strong, nonatomic) NSArray<FFGoodsHistoryItem *> *list;

@end




