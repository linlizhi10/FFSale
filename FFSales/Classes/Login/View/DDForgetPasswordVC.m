//
//  DDForgetPasswordVC.m
//  DaDong
//
//  Created by 李传政 on 2018/2/26.
//  Copyright © 2018年 WintrueTeam. All rights reserved.
//

#import "DDForgetPasswordVC.h"
#import "FILoginRequst.h"
#import "DDSetNewPassWordVC.h"
#import "FITextField.h"
#import "Extention.h"
#import "NSTimer+BlockTimer.h"
@interface DDForgetPasswordVC ()
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) int count;
@property (weak, nonatomic) IBOutlet FITextField *account;
@property (weak, nonatomic) IBOutlet FITextField *verifyCode;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
- (IBAction)sendAction:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
- (IBAction)sureBtnAction:(id)sender;
@end

@implementation DDForgetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"找回密码";
    
    _sureBtn.layer.cornerRadius = 2;
    [_account setContains:11];
    [_verifyCode setContains:6];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)sureBtnAction:(id)sender {
    [self verifyButtonRecover];
    FIVerifycodeVerifyRequst *request = [FIVerifycodeVerifyRequst Request];
    request.phone = _account.text;
    request.verificationCode = _verifyCode.text;
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        if (isSuccess) {
            DDSetNewPassWordVC *passVC = [[DDSetNewPassWordVC alloc] initWithPhone:_account.text];
            [self.navigationController pushViewController:passVC animated:YES];

            //                [MBProgressHUD showSuccess:@"短信验证码发送成功" toView:self.view];
        }else{
            //                [MBProgressHUD showError:result.message toView:self.view];
            [WToast showWithTextCenter:@"验证码错误"];
        }
    }];

}
- (IBAction)sendAction:(id)sender {
    [self resignAllFirstResponder];
    if ([Extention phoneNumberValid:_account.text]) {
        //倒计时
        [self initTimer];
        FIVerifycodeRequst *request = [FIVerifycodeRequst Request];
        request.phone = _account.text;
        [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
            if (isSuccess) {
                [WToast showWithTextCenter:@"短信验证码发送成功"];
//                [MBProgressHUD showSuccess:@"短信验证码发送成功" toView:self.view];
            }else{
//                [MBProgressHUD showError:result.message toView:self.view];
                [WToast showWithTextCenter:@"短信验证码发送失败"];
                [self verifyButtonRecover];
            }
        }];
    }else{
        //        _phone.textColor = [UIColor redColor];
//        [MBProgressHUD showError:@"请输入正确的手机号" toView:self.view];
        NSLog(@"----error");
    }
}
- (void)initTimer{
    _count = 10;
    _sendBtn.enabled = NO;
    __weak typeof(&*self) weakSelf = self;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^{
        __strong typeof(&*self) strongSelf = weakSelf;
        [strongSelf startCounting];
    } repeats:YES];
}

- (void)verifyButtonRecover{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [_sendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _sendBtn.enabled = YES;
    _count = 10;
}

- (void)startCounting{
    if (_count == 1) {
        [self verifyButtonRecover];
    } else {
        _count--;
        //        _validButton.enabled = NO;
        [_sendBtn setTitle:[NSString stringWithFormat:@"%ds",_count] forState:UIControlStateNormal];
        
    }
}

- (NSString *)pureString:(NSString *)originalString{
    return [originalString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
- (void)resignAllFirstResponder
{
    [self.view endEditing:YES];
    
}
@end
