//
//  DDLoginVC.m
//  DaDong
//
//  Created by 李传政 on 2018/2/26.
//  Copyright © 2018年 WintrueTeam. All rights reserved.
//

#import "DDLoginVC.h"
#import "FFInfo.h"
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
#import "FilterCell.h"
#import "FFEmpHomeVC.h"
@interface DDLoginVC ()<UITableViewDelegate,UITableViewDataSource>{
    int _source;
}
@property (weak, nonatomic) IBOutlet FITextField *account;
@property (weak, nonatomic) IBOutlet FITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginBtnAction:(id)sender;
- (IBAction)forgetPassWordBtnAction:(id)sender;
- (IBAction)securityFlagAction:(id)sender;
@property (nonatomic, strong) DataManager *dataM;
@property (copy, nonatomic) LoginCallBackBlock _callBack;
@property (strong, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UITableView *listTable;
@property (strong, nonatomic) FFInfo *info;

@end

@implementation DDLoginVC
- (instancetype)initWithSource:(int)source block:(LoginCallBackBlock)block{
    self = [super init];
    if (self) {
        _source = source;
        __callBack = block;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    _coverView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _info = [[FFInfo alloc] init];
    [_listTable registerNib:[UINib nibWithNibName:@"FilterCell" bundle:nil] forCellReuseIdentifier:@"filter"];

    self.title = @"登录";
    _dataM = [DataManager shareDataManager];

#if DEBUG
        _password.text = @"1234";
        _account.text = @"18583261790";
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
    [self infoCheck];
    

}
- (void)normalLogin{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    WS(ws);
    FILoginRequst *request = [FILoginRequst Request];
    request.mobile = _account.text;
    NSString *strTemp = [NSString stringWithFormat:@"%@%@",_password.text,_account.text];
    request.password = [DDStringUtil md5Endode32:strTemp];
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [ws dealData:result sucess:isSuccess];
    }];

}
- (void)dealData:(NetworkModel *)result sucess:(BOOL)isSuccess{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (isSuccess) {
        [[NSUserDefaults standardUserDefaults] setObject:result.allDic[@"accessToken"] forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] setObject:_account.text forKey:@"phone"];
        
        FIUser *userInfo = [FIUser objectWithKeyValues:result.data[@"salesInfo"]];
        userInfo.loginStatus = YES;
        [[FIUser shareUser] dataSet:userInfo];
        NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
        [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"user"];
        [[NSUserDefaults standardUserDefaults] setObject:result.allDic[@"sourceChannel"] forKey:@"sourceChannel"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loginStatus"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if ([result.allDic[@"sourceChannel"] isEqualToString:@"EMP"]) {
            FFEmpHomeVC *empHome = [[FFEmpHomeVC alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:empHome];
            [nav.navigationBar setBarTintColor:RGBCOLORV(0x4BAE4F)];
            nav.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor darkTextColor] forKey:NSForegroundColorAttributeName];
            [nav.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            [nav.navigationBar setShadowImage:[UIImage new]];
            nav.navigationBar.translucent = YES;
            [self presentViewController:nav animated:NO completion:nil];
        }else{
        [self dataSavePhone:_account.text userId:_account.text fastLogin:NO];
        
        if (__callBack) {
            self._callBack(YES);
        }
        
        [self presentViewController:[MainTab shareInstance] animated:NO completion:nil];
        }
    }else{
        [WToast showWithTextCenter:result.message];
    }

}
- (void)infoCheck{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    FIInfoCheckRequst *request = [FIInfoCheckRequst Request];
    request.mobile = _account.text;
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (isSuccess) {
            FFInfo *info = [FFInfo objectWithKeyValues:result.allDic];
            _info = info;
            if (info.list.count > 1) {
                [self addViewAction];
            }else{
                [self normalLogin];
            }
        }else{
            [WToast showWithTextCenter:result.message];
        }
    }];
    
}
- (void)noLogin:(NSString *)agentNumber{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    WS(ws);
    FINoLoginRequst *request = [FINoLoginRequst Request];
    request.agentNumber = agentNumber;
    request.password = [DDStringUtil md5Endode32:_password.text];
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        
        [ws dealData:result sucess:isSuccess];
    }];}

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _info.list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FilterCell *productCell = [tableView dequeueReusableCellWithIdentifier:@"filter"];
    FFInfoItem *item = _info.list[indexPath.row];
    productCell.contentLabel.text = item.name;
    productCell.contentLabel.textColor = [UIColor darkGrayColor];
    productCell.contentLabel.textAlignment = NSTextAlignmentCenter;
    return productCell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self closeAction];
    FFInfoItem *item = _info.list[indexPath.row];
    [self noLogin:item.agentNumber];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return 40;
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

- (void)addViewAction {
    [[UIApplication sharedApplication].keyWindow addSubview:_coverView];
    
}

- (void)closeAction {
    [_coverView removeFromSuperview];
    
}
@end
