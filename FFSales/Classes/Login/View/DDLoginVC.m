//
//  DDLoginVC.m
//  DaDong
//
//  Created by 李传政 on 2018/2/26.
//  Copyright © 2018年 WintrueTeam. All rights reserved.
//

#import "DDLoginVC.h"
#import "DDForgetPasswordVC.h"
#import "FITextField.h"
#import "Extention.h"
#import "FILoginRequst.h"
#import "FIUser.h"
#import "MainTab.h"
#import "DataManager.h"
#import "DDStringUtil.h"
#import "PCCircleViewConst.h"
#import "GestureViewController.h"
@interface DDLoginVC (){
    int _source;
}
@property (weak, nonatomic) IBOutlet FITextField *account;
@property (weak, nonatomic) IBOutlet FITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginBtnAction:(id)sender;
- (IBAction)forgetPassWordBtnAction:(id)sender;
- (IBAction)securityFlagAction:(id)sender;
@property (nonatomic, strong) DataManager *dataM;


@end

@implementation DDLoginVC
- (instancetype)initWithSource:(int)source{
    self = [super init];
    if (self) {
        _source = source;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;

    self.title = @"登录";
    _dataM = [DataManager shareDataManager];

#if DEBUG
        _password.text = @"1234";
        _account.text = @"13932485784";
#endif
    
    _loginBtn.layer.cornerRadius = 2;
    [_account setContains:11];
    [_password setContains:20];
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"phone"]) {
//        _account.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
//    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - CustomDelegate
#pragma mark - keybord Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self loginBtnAction:nil];
    return YES;
}
- (IBAction)loginBtnAction:(id)sender {
    


    [self.view endEditing:YES];
    
//    if (![Extention phoneNumberValid:_account.text]) {
//        [MBProgressHUD showError:@"请输入合法手机号" toView:self.view];
//        return;
//    }

    if ([[self pureString: _password.text] isEqualToString:@""]) {
//        [MBProgressHUD showError:@"请输入正确的密码" toView:self.view];
        return;
    }


    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FILoginRequst *request = [FILoginRequst Request];
    request.mobile = _account.text;
    NSString *strTemp = [NSString stringWithFormat:@"%@%@",_password.text,_account.text];
    request.password = [DDStringUtil md5Endode32:strTemp];
//    request.password = @"168e969d48e2fe1c7a1f84f41f2cc2cd";
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSuccess) {
            [[NSUserDefaults standardUserDefaults] setObject:result.allDic[@"accessToken"] forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] setObject:_account.text forKey:@"phone"];

            FIUser *userInfo = [FIUser objectWithKeyValues:result.data[@"salesInfo"]];
            userInfo.loginStatus = YES;
            [[FIUser shareUser] dataSet:userInfo];
            NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
            [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"user"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loginStatus"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            [self dataSavePhone:_account.text userId:_account.text fastLogin:NO];

            
            if ([PCCircleViewConst getGestureCloseFlag] == YES) {
                if (_source == 1) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }else{
                    [self presentViewController:[MainTab shareInstance] animated:NO completion:nil];
                    
                }
            }else{
                if ([[PCCircleViewConst getGestureWithKey:gestureFinalSaveKey] length]){
                    if (_source == 1) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }else{
                        [self presentViewController:[MainTab shareInstance] animated:NO completion:nil];
                        
                    }
                }else{
                    
                    GestureViewController *gestureVc = [[GestureViewController alloc] initWithRegister:1];
                    gestureVc.type = GestureViewControllerTypeSetting;
                    WS(ws);
                    gestureVc.finishBlock = ^{
                        [ws presentViewController:[MainTab shareInstance] animated:YES completion:nil];
                    };
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:gestureVc];
                    [nav.navigationBar setBarTintColor:[UIColor whiteColor]];
                    nav.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor darkTextColor] forKey:NSForegroundColorAttributeName];
//                    [self.navigationController pushViewController:gestureVc animated:YES];
                    if (_source == 1) {
                        [self.navigationController pushViewController:gestureVc animated:YES];
                    }else{
                        [self presentViewController:nav animated:YES completion:nil];

                    }
//                    [self presentViewController:nav animated:YES completion:nil];
                }
            }
            
//            [self presentViewController:[MainTab shareInstance] animated:NO completion:nil];

        }else{
            [WToast showWithTextCenter:result.message];
        }
    }];

}
- (void)dataSavePhone:(NSString *)phone userId:(NSString *)userId fastLogin:(BOOL)fastLogin{
    NSDate *dateC = [NSDate date];
    NSInteger timeStamp = [dateC timeIntervalSince1970];
    UserGesture *gesture = [[UserGesture alloc] init];
    gesture.timeStamp = timeStamp;
    gesture.userId = userId;
    gesture.phone = phone;
    gesture.trackOn = YES;
    gesture.gestureOn = YES;
    gesture.fastLogin = fastLogin;
    gesture.closeBySelf = NO;
    if (![_dataM fetchUserInfoByUserId:userId]) {
        [_dataM insertObject:gesture];
    }else{
        [_dataM updateBaseInfo:gesture];
    }
    
}
- (IBAction)forgetPassWordBtnAction:(id)sender {
    [self.navigationController pushViewController:[DDForgetPasswordVC new] animated:YES];
}

- (IBAction)securityFlagAction:(id)sender {
    _password.secureTextEntry = !_password.secureTextEntry;
    UIButton *btn = (UIButton *)sender;
    NSString *imageName = _password.secureTextEntry?@"pic-yj-off":@"pic-yj";
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (NSString *)pureString:(NSString *)originalString{
    return [originalString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
@end
