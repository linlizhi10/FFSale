//
//  DDSetNewPassWordVC.m
//  DaDong
//
//  Created by 李传政 on 2018/2/26.
//  Copyright © 2018年 WintrueTeam. All rights reserved.
//

#import "DDSetNewPassWordVC.h"
#import "FITextField.h"
#import "FILoginRequst.h"
@interface DDSetNewPassWordVC (){
    NSString *_phone;
}
@property (weak, nonatomic) IBOutlet FITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
- (IBAction)sureBtnAction:(id)sender;
- (IBAction)securityAction:(id)sender;

@end

@implementation DDSetNewPassWordVC
- (instancetype)initWithPhone:(NSString *)phone{
    self = [super init];
    if (self) {
        _phone = phone;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置新密码";
    _sureBtn.layer.cornerRadius = 2;
    [_password setContains:16];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)sureBtnAction:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    FIResetPasswordRequst *request = [FIResetPasswordRequst Request];
    request.phone = _phone;
    request.password = _password.text;
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if (isSuccess) {
            [WToast showWithTextCenter:@"设置成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            //                [MBProgressHUD showError:result.message toView:self.view];
            [WToast showWithTextCenter:result.message];
        }
    }];
    
}

- (IBAction)securityAction:(id)sender {
    _password.secureTextEntry = !_password.secureTextEntry;
    UIButton *btn = (UIButton *)sender;
    NSString *imageName = _password.secureTextEntry?@"pic-yj-off":@"pic-yj";
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}
@end
