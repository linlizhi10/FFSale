//
//  MessageModel.h
//  FFSales
//
//  Created by lin on 2018/6/21.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "Model.h"
@interface MessageExtraModel : NSObject
@property (assign, nonatomic) float qty;
@property (assign, nonatomic) float payAmount;

@end

@interface MessageItemModel : NSObject
@property (assign, nonatomic) long createTime; //

@property (copy, nonatomic) NSString *message;//
@property (copy, nonatomic) NSString *custNo;//
@property (copy, nonatomic) NSString *readed;//

@property (copy, nonatomic) NSString *linkedId;//

@property (strong, nonatomic) MessageExtraModel *extra;//

@property (copy, nonatomic) NSString *messageNo;//
@property (copy, nonatomic) NSString *messageType;//消息类型，ORDER_CREATED:订单已创建,ORDER_AUDITED:订单已审核,ORDER_HAS_SEND:订单已发货,ORDER_CLOSED:订单已关闭,FUND_CASH_ADD:现金上账,FUND_DEPOSIT_ADD:保证金/订金上账

@end
@interface MessageModel : Model
@property (strong, nonatomic) NSArray<MessageItemModel *> *list;

@end
