//
//  FFGetGoodsRequest.m
//  FFSales
//
//  Created by lin on 2018/6/20.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFGetGoodsRequest.h"

@implementation FFGetGoodsRequest
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = @"/pickups";
    self.METHOD = @"GET";
    self.params = @{@"accessToken":self.accessToken?:@"",
                    @"note":self.note?:@""
                    
                    
                    };
    
    [super startCallBack:_callBack];
}
@end
@implementation FFGetGoodsHistoryRequest
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = @"/pickups";
    self.METHOD = @"GET";
    self.params = @{@"accessToken":self.accessToken?:@"",
                    @"page":@(self.page),
                    @"size":@(self.size)
                    
                    };
    
    [super startCallBack:_callBack];
}
@end
@implementation FFGetGoodsDRequest
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = [NSString stringWithFormat:@"/pickups/%@",self.pickupId];
    self.METHOD = @"GET";
    self.params = @{
                    @"accessToken":self.accessToken?:@"",
                    
                    };
    [super startCallBack:_callBack];
}
@end
