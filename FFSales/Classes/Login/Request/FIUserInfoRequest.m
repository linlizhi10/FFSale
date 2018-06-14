//
//  FIUserInfoRequest.m
//  finance
//
//  Created by lin on 17/5/22.
//  Copyright © 2017年 李传政. All rights reserved.
//

#import "FIUserInfoRequest.h"

@implementation FIUserInfoRequest
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = @"api/user/info";
    self.METHOD = @"GET";
    [super startCallBack:_callBack];
}

@end
