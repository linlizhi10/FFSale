//
//  FILoginRequst.h
//  finance
//
//  Created by lin on 17/5/8.
//  Copyright © 2017年 李传政. All rights reserved.
//

#import "Request.h"
#pragma mark - login
@interface FILoginRequst : Request
@property (nonatomic, copy) NSString *mobile; //用户名
@property (nonatomic, copy) NSString *password; //用户密码
@property (nonatomic, copy) NSString *verifyCode; //验证码 非必传参数
@end

#pragma mark - fast login
@interface FIInfoCheckRequst : Request
@property (nonatomic, copy) NSString *mobile; //

@end

#pragma mark - register
@interface FINoLoginRequst : Request
@property (nonatomic, copy) NSString *agentNumber; //用户名
@property (nonatomic, copy) NSString *password; //用户密码

@end

#pragma mark - reset password
@interface FIResetPasswordRequst : Request
@property (nonatomic, copy) NSString *phone; //用户名
@property (nonatomic, copy) NSString *password; //用户密码

@end

#pragma mark - get verfifycode
@interface FIVerifycodeRequst : Request
@property (nonatomic, copy) NSString *phone; //手机号
////用途 PASSWORD：重置登陆密码，PAY：重置支付密码，PHONE：更改手机号，REGISTER：注册
//@property (nonatomic, copy) NSString *use;
@end

@interface FIVerifycodeVerifyRequst : Request
@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *verificationCode;
@end
