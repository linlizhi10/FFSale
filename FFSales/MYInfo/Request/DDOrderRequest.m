//
//  DDOrderRequest.m
//  DaDong
//
//  Created by lin on 2018/3/19.
//  Copyright © 2018年 WintrueTeam. All rights reserved.
//

#import "DDOrderRequest.h"

@implementation DDOrderRequest
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = @"/ordOrders";
    self.METHOD = @"GET";
    self.params = @{@"accessToken":self.accessToken?:@"",
                                      @"status":self.status?:@"",
                                      @"auditStatus":self.auditStatus?:@"",
                                      @"newOrder":self.OrderNew?:@"",
                                      @"page":@(self.page),
                                      @"size":@(self.size)
                    
    };
    
    [super startCallBack:_callBack];
}
@end
@implementation DDOrderDetailRequest
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = [NSString stringWithFormat:@"/ordOrders/%@",self.orderId];
    self.METHOD = @"GET";
    self.params = @{
                    @"accessToken":self.accessToken?:@"",
                    
                    };
    [super startCallBack:_callBack];
}
@end
@implementation DDCancelRequest
- (void)startCallBack:(RequestCallBackBlock)_callBack{
#pragma mark -----修改---
    self.PATH = @"/orderRs/cancelOrderByOrderNo";
    self.METHOD = @"POST";
    self.params = @{
                    @"request_data":@{@"orderNo":self.orderNo?:@"",
                                      
                                      }
                    };
    [super startCallBack:_callBack];
}

@end
@implementation DDTransRequest
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = [NSString stringWithFormat:@"/ordOrders/%@/deliveryInfo",self.orderId];
    self.METHOD = @"GET";
    self.params = @{
                    @"accessToken":self.accessToken?:@""
                    };
    [super startCallBack:_callBack];
}
@end
