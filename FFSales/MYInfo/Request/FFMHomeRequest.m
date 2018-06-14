//
//  FFMHomeRequest.m
//  FFSales
//
//  Created by lin on 2018/6/7.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFMHomeRequest.h"

@implementation FFMHomeRequest
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = @"/custInfos/self";
    self.METHOD = @"GET";
    self.params = @{@"accessToken":self.accessToken?:@""
                   
                    }
    ;
    [super startCallBack:_callBack];
}
@end
