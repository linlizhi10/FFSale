//
//  FFMessageReqeust.m
//  FFSales
//
//  Created by lin on 2018/6/21.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFMessageReqeust.h"

@implementation FFMessageReqeust
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = @"/appMessages";
    self.METHOD = @"GET";
    self.params = @{@"accessToken":self.accessToken?:@"",
                    @"type":self.type?:@"",
                    @"page":@(self.page),
                    @"size":@(self.size)
                    
                    };
    
    [super startCallBack:_callBack];
}
@end
