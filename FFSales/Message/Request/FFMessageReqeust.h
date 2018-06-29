//
//  FFMessageReqeust.h
//  FFSales
//
//  Created by lin on 2018/6/21.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "Request.h"
@interface FFMessageHomeReqeust : Request
@property (nonatomic, copy) NSString *accessToken; //
@end

@interface FFMessageReqeust : Request
@property (nonatomic, copy) NSString *accessToken; //
@property (nonatomic, copy) NSString *type; //消息类型，ORDER:订单,FUND:资金

@property (assign, nonatomic) int page; //
@property (assign, nonatomic) int size; //
@end

@interface FFMessageSetReadReqeust : Request
@property (nonatomic, copy) NSString *accessToken; //
@property (nonatomic, copy) NSString *type; //

@end
@interface FFMessageDeleteReqeust : Request
@property (nonatomic, copy) NSString *accessToken; //
@property (nonatomic, copy) NSString *messageNo; //

@end

