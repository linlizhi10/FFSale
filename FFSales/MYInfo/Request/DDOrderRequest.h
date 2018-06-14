//
//  DDOrderRequest.h
//  DaDong
//
//  Created by lin on 2018/3/19.
//  Copyright © 2018年 WintrueTeam. All rights reserved.
//

#import "Request.h"

@interface DDOrderRequest : Request
@property (nonatomic, copy) NSString *accessToken; //
@property (nonatomic, copy) NSString *status; //
@property (nonatomic, copy) NSString *auditStatus; //
@property (nonatomic, copy) NSString *OrderNew; //
@property (assign, nonatomic) int page; //
@property (assign, nonatomic) int size; //

@end
@interface DDOrderDetailRequest : Request
@property (nonatomic, copy) NSString *orderId; //
@property (nonatomic, copy) NSString *accessToken; //

@end
@interface DDCancelRequest : Request
@property (nonatomic, copy) NSString *orderNo; //

@end
@interface DDTransRequest : Request
@property (nonatomic, copy) NSString *orderId; //
@property (nonatomic, copy) NSString *accessToken; //
@end
