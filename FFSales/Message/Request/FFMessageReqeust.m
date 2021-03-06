//
//  FFMessageReqeust.m
//  FFSales
//
//  Created by lin on 2018/6/21.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFMessageReqeust.h"
@implementation FFMessageHomeReqeust
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = @"/appMessages/home";
    self.METHOD = @"GET";
    self.params = @{@"accessToken":self.accessToken?:@""
                    };
    
    [super startCallBack:_callBack];
}
@end

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

@implementation FFMessageSetReadReqeust
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = @"/appMessages/readed";
    self.METHOD = @"POST";
    self.params = @{@"accessToken":self.accessToken?:@"",
                    @"type":self.type?:@""
                    };
    
    [super startCallBack:_callBack];
}
@end

@implementation FFMessageDeleteReqeust
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = [NSString stringWithFormat:@"/appMessages/%@",_messageNo];
    self.METHOD = @"DELETE";
    self.params = @{@"accessToken":self.accessToken?:@""
                    };
    
    [super startCallBack:_callBack];
}
@end
