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
    self.PATH = @"/appGestureCiphers/self";
    self.METHOD = @"GET";
    self.params = @{
                    @"accessToken":self.accessToken?:@"",
                    
                    };
    [super startCallBack:_callBack];
}

@end
@implementation FIGestureUpdateRequest
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = @"/appGestureCiphers";
    self.METHOD = @"POST";
    self.params = @{
                    @"accessToken":self.accessToken?:@"",
                    @"code":self.code?:@"",
                    @"state":self.state?:@""

                    };
    [super startCallBack:_callBack];
}

@end
