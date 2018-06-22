//
//  FIChangePasswordViewController.m
//  finance
//
//  Created by lin on 17/5/10.
//  Copyright © 2017年 李传政. All rights reserved.
//

#import "FIChangePasswordViewController.h"
#import "FITextField.h"
#import "Extention.h"
#import "FIUser.h"
#import "CCChangePRequest.h"
#import "Extention.h"
#import "DDStringUtil.h"
@interface FIChangePasswordViewController ()
@property (weak, nonatomic) IBOutlet FITextField *originalPassword;
@property (weak, nonatomic) IBOutlet FITextField *resetPassword;
@property (weak, nonatomic) IBOutlet FITextField *confirmPassword;
- (IBAction)confrimAction:(id)sender;
- (IBAction)forgetPassword:(id)sender;

@end

@implementation FIChangePasswordViewController
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    [self.originalPassword setContains:20];
    [self.resetPassword setContains:20];
    [self.confirmPassword setContains:20];
    _originalPassword.secureTextEntry = YES;
    _confirmPassword.secureTextEntry = YES;
    _resetPassword.secureTextEntry = YES;
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextfieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //判断一下，哪个是不让换键盘的textField
    if (textField == _originalPassword) {
        _originalPassword.secureTextEntry = YES;
    }
    if (textField == _confirmPassword) {
        _confirmPassword.secureTextEntry = YES;
    }
    if (textField == _resetPassword) {
        _resetPassword.secureTextEntry = YES;
    }
}
#pragma mark - event response
- (IBAction)confrimAction:(id)sender {
    //9-13 ******************************
    [self resignAllResponder];
    if ([self infomationComplete]) {

        CCChangePRequest *request = [CCChangePRequest Request];
        request.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
        request.oldPassword = [DDStringUtil md5Endode32: _originalPassword.text];
        NSData *encodeData = [_confirmPassword.text dataUsingEncoding:NSUTF8StringEncoding];
        NSString *base64String = [encodeData base64EncodedStringWithOptions:0];
        request.comPassword = base64String;

        __block FIChangePasswordViewController *ws = self;
        [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
            //LCZ 2017-09-13 00:29 add
            //add 隐藏键盘
            //end
            if (isSuccess) {
                
            }else{
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                [WToast showWithTextCenter:result.message];

            }
        }];

    }
}

- (IBAction)forgetPassword:(id)sender {
    
}
#pragma mark - private method
- (void)enterBackground{
    [self resignAllResponder];
}
- (void)resignAllResponder{
    [self.originalPassword resignFirstResponder];
    [self.resetPassword resignFirstResponder];
    [self.confirmPassword resignFirstResponder];
}
- (BOOL)infomationComplete{
    
    if ([[self pureString:_originalPassword.text] isEqualToString:@""]) {
        [WToast showWithTextCenter:@"请输入原密码"];

        return NO;
    }else{
        if(![Extention judgePassWordLegal:_originalPassword.text]){
            [WToast showWithTextCenter:@"请检查原密码"];

            return NO;
        }
        
    }
    
    if ([[self pureString:_resetPassword.text] isEqualToString:@""]) {
        [WToast showWithTextCenter:@"请输入新密码"];
        return NO;
    }else{
        if(![Extention judgePassWordLegal:_resetPassword.text]){
//            _resetPassword.textColor = [UIColor redColor];
            
            return NO;
        }

    }
    if ([[self pureString:_confirmPassword.text] isEqualToString:@""]) {
        [WToast showWithTextCenter:@"请输入确认密码"];

        return NO;
    }
    if (![_resetPassword.text isEqualToString:_confirmPassword.text]) {
        
        [WToast showWithTextCenter:@"请检查密码是否一致"];

//        _confirmPassword.textColor = [UIColor redColor];
        return NO;
    }
    return YES;
}

- (NSString *)pureString:(NSString *)originalString{
    return [originalString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
@end
