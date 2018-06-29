//
//  FFCustomerRequest.m
//  FFSales
//
//  Created by lin on 2018/6/21.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFCustomerRequest.h"

@implementation FFCustomerRequest
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = @"/custInfos";
    self.METHOD = @"GET";
    self.params = @{@"accessToken":self.accessToken?:@"",
                    @"keyword":self.keyword?:@"",
                    @"newCust":_newCust?@"true":@"false",
                    @"page":@(_page),
                    @"size":@(_size)
                    }
    ;
    [super startCallBack:_callBack];
}

@end
