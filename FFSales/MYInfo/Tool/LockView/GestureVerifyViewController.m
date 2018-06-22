
#import "GestureVerifyViewController.h"
#import "PCCircleViewConst.h"
#import "PCCircleView.h"
#import "PCLockLabel.h"
#import "GestureViewController.h"
#import <UIImageView+WebCache.h>
#import "FIUser.h"
#import "Extention.h"
#import "MainTab.h"
#import "DataManager.h"
#import "DDLoginVC.h"
#import "FFGestureData.h"
#import "FIUserInfoRequest.h"
//#import <CloudPushSDK/CloudPushSDK.h>
#import <UINavigationController+FDFullscreenPopGesture.h>

typedef void (^completeBlock)(void);

@interface GestureVerifyViewController ()<CircleViewDelegate>

/**
 *  文字提示Label
 */
@property (nonatomic, strong) PCLockLabel *msgLabel;
@property (nonatomic, assign) BOOL countLimit;
@end

@implementation GestureVerifyViewController
- (instancetype)initIsToSetNewGesture:(BOOL)isToSetNewGesture needCountLimit:(BOOL)countLimit{
    self = [super init];
    if (self) {
        _isToSetNewGesture = isToSetNewGesture;
        _countLimit = countLimit;
        [self.view setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}
- (instancetype)initIsToSetNewGesture:(BOOL)isToSetNewGesture{
    self = [super init];
    if (self) {
        _isToSetNewGesture = isToSetNewGesture;
        _countLimit = NO;
        [self.view setBackgroundColor:[UIColor whiteColor]];
    }
    return self;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"验证手势解锁";
    PCCircleView *lockView = [[PCCircleView alloc] init];
    lockView.tag = 100;
    lockView.delegate = self;
    [lockView setType:CircleViewTypeVerify];
    [self.view addSubview:lockView];
    
    PCLockLabel *msgLabel = [[PCLockLabel alloc] init];
    msgLabel.frame = CGRectMake(0, 0, kScreenW, 14);
    msgLabel.center = CGPointMake(kScreenW/2, CGRectGetMinY(lockView.frame) - 10);
    [msgLabel showNormalMsg:gestureTextOldGesture];
    self.msgLabel = msgLabel;
    [self.view addSubview:msgLabel];
    
    [self setBackButton];
    
    
    [self clietInfoViewHeight:msgLabel.top];
    
    if (_countLimit == YES) {
        UIButton *_forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgetButton.frame = CGRectMake(40, lockView.bottom + 10, 80, 30);
        _forgetButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_forgetButton setTitle:@"忘记手势密码" forState:UIControlStateNormal];
        [_forgetButton setTitleColor:RGBCOLORV(0x666666) forState:UIControlStateNormal];
        [_forgetButton addTarget:self action:@selector(forgetAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_forgetButton];
        
        UIButton *exchanegBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        exchanegBtn.frame = CGRectMake(SCREEN_WIDTH - 40 - 80, lockView.bottom + 10, 80, 30);
        exchanegBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [exchanegBtn setTitle:@"切换其他账户" forState:UIControlStateNormal];
        [exchanegBtn setTitleColor:RGBCOLORV(0x666666) forState:UIControlStateNormal];
        [exchanegBtn addTarget:self action:@selector(exchangeUser) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:exchanegBtn];

    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.fd_interactivePopDisabled = YES;

    id obj = [self.view viewWithTag:10011];
    if ([obj isKindOfClass:[UILabel class]]) {
        UILabel *phone = (UILabel *)obj;
//         FIUser *userTemp = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"user"]];
        NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"phone"];
        phone.text = [uid stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    
    id obj2 = [self.view viewWithTag:10022];
    if ([obj2 isKindOfClass:[UIImageView class]]) {
        UIImageView *header = (UIImageView *)obj2;
//        [header sd_setImageWithURL:[NSURL URLWithString:[FIUser shareUser].icon] placeholderImage:[UIImage imageNamed:@"icon-touxiang"]];
        header.image = Img(@"img-grxx-tx");
    }
    
    if (_countLimit == YES) {
        NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"phone"];

        UserGesture *gesture = [[UserGesture alloc] init];
        gesture.count = (int)[FFGestureData getGestureCount:GestureCounteString];
        if (gesture.count <= 0) {
            [self.msgLabel showWarnMsgAndShake:@"密码错误,还可以输入0次"];
            PCCircleView *lockView = [self.view viewWithTag:100];
            lockView.userInteractionEnabled = NO;
            
        }else{
            
            [self.msgLabel showNormalMsg:gestureTextOldGesture];
            PCCircleView *lockView = [self.view viewWithTag:100];
            lockView.userInteractionEnabled = YES;

        }

    }
    
    if (self.navigationController) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.fd_interactivePopDisabled = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)clietInfoViewHeight:(CGFloat)height{
    NSString *phone = @"";
    if ([FIUser shareUser].phone.length >= 11) {
        phone = [[FIUser shareUser].phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    UILabel *phoneL = [Extention labelWithTextColor:RGBCOLORV(0x999999) numberOfLines:1 text:phone fontSize:16];
    phoneL.textAlignment = NSTextAlignmentCenter;
    
    phoneL.frame = CGRectMake((SCREEN_WIDTH - 100) / 2, height - 30, 100, 20);
    phoneL.tag = 10011;
    [self.view addSubview:phoneL];
    UIImageView *imageV = [[UIImageView alloc] init];
//    [imageV sd_setImageWithURL:[NSURL URLWithString:[FIUser shareUser].icon] placeholderImage:[UIImage imageNamed:@"icon-touxiang"]];
    imageV.frame = CGRectMake((SCREEN_WIDTH - 46) / 2, phoneL.top - 56, 46, 46);
    imageV.layer.cornerRadius = 23;
    imageV.clipsToBounds = YES;
    imageV.tag = 10022;
    [self.view addSubview:imageV];
    
   

}
- (void)setBackButton{
        UIButton *btn= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        [btn setImage:Img(@"icon-bank-h") forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 5)];
        [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        [btn setTitleColor:RGBColor(51, 51, 51) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0,-12, 0 , 0)];
        btn.titleLabel.font = Font(16);
        
        UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = barBtnItem;
    
    
}
- (void)setIsToSetNewGesture:(BOOL)isToSetNewGesture{
    _isToSetNewGesture = isToSetNewGesture;
    if (isToSetNewGesture == NO) {
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.leftBarButtonItem = nil;
    }
}
#pragma mark - login or verify gesture
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal
{
    if (type == CircleViewTypeVerify) {
        
        if (equal) {
            NSLog(@"验证成功");
//            NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"phone"];

//            [[DataManager shareDataManager] updateCount:5 userId:uid];
            [FFGestureData updateCount:5 key:GestureCounteString];
            
            [self.msgLabel showNormalMsg:gestureTextOldGesture];
            
            if (self.isToSetNewGesture) {
                GestureViewController *gestureVc = [[GestureViewController alloc] init];
                [gestureVc setType:GestureViewControllerTypeSetting];
                [self.navigationController pushViewController:gestureVc animated:YES];
            } else {
                
//                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                if (self.navigationController) {
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"verifySuccess" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [self.view removeFromSuperview];
                }
            }
            
        } else {
            NSLog(@"密码错误！");
            [self.msgLabel showWarnMsgAndShake:gestureTextGestureVerifyError];
            
            if (_countLimit == YES) {
//                NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"phone"];

                UserGesture *gesture = [[UserGesture alloc] init];
                gesture.count = (int)[FFGestureData getGestureCount:GestureCounteString];
                
                
                if (gesture.count >= 1) {
                    gesture.count -= 1;
                }
                if (gesture.count >=0) {
                    [self.msgLabel showWarnMsgAndShake:[NSString stringWithFormat:@"密码错误,还可以输入%d次",gesture.count]];
                }else{
                    [self.msgLabel showWarnMsgAndShake:@"密码错误,还可以输入0次"];
                }
//                NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];

//                [[DataManager shareDataManager] updateCount:gesture.count userId:uid];
                [FFGestureData updateCount:gesture.count key:GestureCounteString];
                
                if (gesture.count == 0) {
                    UIView *view = [self.view viewWithTag:100];
                    view.userInteractionEnabled = NO;
                }
            }
          
        }
    }
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)forgetAction{
    //忘记手势密码
    [self pushSDKBindAccount];

    [FFGestureData insertGestureState:@"close" key:GestureStateString];
    [FFGestureData insertGestureCode:@"" key:GestureCodeString];
    [FFGestureData updateCount:5 key:GestureCounteString];
    __block GestureVerifyViewController *ws = self;
    [self gestureUpdateCode:@"" status:@"close" comleteBlock:^{
        [FIUser clearUerInfo];
        [ws.view removeFromSuperview];
        NSInteger selectIndex = [MainTab shareInstance].selectedIndex;
        UINavigationController *nav = [MainTab shareInstance].viewControllers[selectIndex];
//        UINavigationController *nav = [MainTab shareInstance].viewControllers[0];
        [nav popToRootViewControllerAnimated:YES];
        [MainTab shareInstance].selectedIndex = 0;

        [[MainTab shareInstance] showLoginViewWithBlock:nil];
    }];
    
}

#pragma mark -
#pragma mark -- ali push --
- (void)pushSDKBindAccount{
//    [CloudPushSDK unbindAccount:^(CloudPushCallbackResult *res) {
//        //
//    }];
    
}

- (void)exchangeUser{
    //切换用户
    [self pushSDKBindAccount];
//    [FFGestureData insertGestureState:@"close" key:GestureStateString];
//    [FFGestureData insertGestureCode:@"" key:GestureCodeString];
//    [FFGestureData updateCount:5 key:GestureCounteString];
//    __block GestureVerifyViewController *ws = self;
    [FIUser clearUerInfo];
    [self.view removeFromSuperview];
    NSInteger selectIndex = [MainTab shareInstance].selectedIndex;
    UINavigationController *nav = [MainTab shareInstance].viewControllers[selectIndex];
    [nav popToRootViewControllerAnimated:YES];
    [MainTab shareInstance].selectedIndex = 0;
    [[MainTab shareInstance] showLoginViewWithBlock:nil];
    //    [self gestureUpdateCode:@"" status:@"close" comleteBlock:^{
//        [FIUser clearUerInfo];
//        [ws.view removeFromSuperview];
//        NSInteger selectIndex = [MainTab shareInstance].selectedIndex;
//        UINavigationController *nav = [MainTab shareInstance].viewControllers[selectIndex];
//        [nav popToRootViewControllerAnimated:YES];
//        [[MainTab shareInstance] showLoginViewWithBlock:nil];
//    }];
    
   

//    [self presentLogin];
}
- (void)presentLogin{
//    WeakSelf(ws) = self;
//    FILoginViewController *login = [[FILoginViewController alloc] initWithLoginBlock:^(BOOL isLoginSuccess) {
//        [ws.navigationController dismissViewControllerAnimated:NO completion:nil];
//        
//    }];
//    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:login];
//    [nav.navigationBar setBarTintColor:[UIColor whiteColor]];
//    nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor darkTextColor],NSFontAttributeName:Font(18)};
//    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
- (void)gestureUpdateCode:(NSString *)code status:(NSString *)state comleteBlock:(completeBlock)_block{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    FIGestureUpdateRequest *request = [FIGestureUpdateRequest Request];
    request.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    request.code = code;
    request.state = state;
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSuccess) {
            if (_block) {
                _block();
            }
            
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [WToast showWithTextCenter:result.message];
        }
    }];
    
}
@end
