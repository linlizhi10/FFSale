//
//  FILoginRequst.m
//  finance
//
//  Created by lin on 17/5/8.
//  Copyright © 2017年 李传政. All rights reserved.
//

#import "FILoginRequst.h"

@implementation FILoginRequst
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = @"/users/accessToken";
    self.METHOD = @"POST";
    self.params = @{@"mobile":self.mobile?:@"",
                    @"password":self.password?:@""
                    }
                    ;
    [super startCallBack:_callBack];
}
@end

@implementation FIFastLoginRequst
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = @"api/user/login";
    self.METHOD = @"POST";
    self.params = @{@"phone":self.userName?:@"",
                    @"verifyCode":(self.verifyCode?:@"")};
    [super startCallBack:_callBack];
}
@end

@implementation FIRegisterRequst
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = @"api/user/register";
    self.METHOD = @"POST";
    self.params = @{@"phone":self.phone?:@"",
                    @"password":self.password?:@"",
                    @"verifyCode":self.verifyCode?:@"",
                    @"userType":self.userType?:@"",
                    @"inviteCode":(self.inviteCode?:@"")};
    [super startCallBack:_callBack];
}
@end

@implementation FIResetPasswordRequst
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = @"/shoprs/passwordUpdate";
    self.METHOD = @"POST";
    self.params = @{
                    @"request_data":@{@"phone":self.phone?:@"",
                                      @"newpassword":self.password?:@""
                                      }
                    };
    [super startCallBack:_callBack];
}
@end

@implementation FIVerifycodeRequst
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = @"/shoprs/codeGainUpdate";
    self.METHOD = @"POST";
    self.params = @{
                    @"request_data":@{@"phone":self.phone?:@""
                                     
                                      }
                    };
    [super startCallBack:_callBack];
}
@end
@implementation FIVerifycodeVerifyRequst
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = @"/shoprs/checkverificationcode";
    self.METHOD = @"POST";
    self.params = @{
                    @"request_data":@{@"phone":self.phone?:@"",
                                      @"verificationCode":self.verificationCode
                                      }
                    };
    [super startCallBack:_callBack];
}
@end
