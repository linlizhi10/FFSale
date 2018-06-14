//
//  OrderInfo.h
//  DaDong
//
//  Created by lin on 2018/3/2.
//  Copyright © 2018年 WintrueTeam. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OrderProduct : NSObject
@property (copy, nonatomic) NSString *materialId;
@property (copy, nonatomic) NSString *picUrl;
@property (copy, nonatomic) NSString *materialNum;
@property (assign, nonatomic) float qty;
@property (copy, nonatomic) NSString *price;
@property (copy, nonatomic) NSString *transportPrice;
@property (copy, nonatomic) NSString *handlingPrice;
@property (copy, nonatomic) NSString *materialName;
@property (copy, nonatomic) NSString *category;
@property (copy, nonatomic) NSString *payPrice;
@end

@interface OrderInfo : NSObject
@property (copy, nonatomic) NSString *orderId;
@property (copy, nonatomic) NSString *sapCode;
@property (copy, nonatomic) NSString *payAmout;
@property (assign, nonatomic) float actualAmout;

@property (assign, nonatomic) float qty;
@property (copy, nonatomic) NSString *status;
@property (copy, nonatomic) NSString *auditStatus;
@property (copy, nonatomic) NSString *createTime;
@property (copy, nonatomic) NSString *custName;
@property (assign, nonatomic) float sendQty;

@property (strong, nonatomic) NSArray<OrderProduct *> *materials;

@end

@interface OrderInfoDetail : NSObject
@property (copy, nonatomic) NSString *orderId;
@property (copy, nonatomic) NSString *sapCode;
@property (copy, nonatomic) NSString *sendFactory;
@property (copy, nonatomic) NSString *transport;
@property (copy, nonatomic) NSString *destination;
@property (copy, nonatomic) NSString *transportLine;
@property (copy, nonatomic) NSString *payType;
@property (copy, nonatomic) NSString *rebate;

@property (assign, nonatomic) float payAmout;
@property (assign, nonatomic) float actualAmout;
@property (assign, nonatomic) float discountAmount;
@property (assign, nonatomic) float qty;

@property (assign, nonatomic) float transportAmout;

@property (copy, nonatomic) NSString *handlingCharges    ;//
@property (copy, nonatomic) NSString *policyAmount;//
@property (copy, nonatomic) NSString *cash;
@property (copy, nonatomic) NSString *status; //
@property (assign, nonatomic) long createTime;//
@property (assign, nonatomic) long payTime;//
@property (assign, nonatomic) long finishTime;//
@property (copy, nonatomic) NSString *custName    ;
@property (copy, nonatomic) NSString *receiveName    ;//
@property (copy, nonatomic) NSString *receiverPhone;//
@property (copy, nonatomic) NSString *receiveAdd;
@property (copy, nonatomic) NSString *smallpackageFee; //

@property (copy, nonatomic) NSString *sendQty    ;
@property (copy, nonatomic) NSString *priceBatch    ;//
@property (assign, nonatomic) long postTime;//
@property (assign, nonatomic) float transportPrice;

@property (copy, nonatomic) NSString *handlingPrice; //
@property (strong, nonatomic) NSArray<OrderProduct *> *materials;

@end
