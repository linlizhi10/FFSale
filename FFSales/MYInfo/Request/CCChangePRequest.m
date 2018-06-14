//
//  CCChangePRequest.m
//  FFSales
//
//  Created by lin on 2018/5/30.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "CCChangePRequest.h"

@implementation CCChangePRequest
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = @"/users/password";
    self.METHOD = @"PUT";
    self.params = @{
                    @"accessToken":self.accessToken?:@"",
                    @"oldPassword":self.oldPassword?:@"",
                    @"newPassword":self.comPassword?:@"",

                    };
    [super startCallBack:_callBack];
}
@end
