//
//  FFSetVC.m
//  FFSales
//
//  Created by lin on 2018/6/8.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFSetVC.h"
#import "CacheViewModel.h"
#import "GestureViewController.h"
#import "GestureVerifyViewController.h"
#import "FIChangePasswordViewController.h"
#import "MainTab.h"
#import "DataManager.h"
@interface FFSetVC ()<UIAlertViewDelegate>
- (IBAction)changePassA:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *gestureSwitch;
- (IBAction)cleanDiskA:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *cacheSize;
@property (weak, nonatomic) IBOutlet UILabel *versionNumber;
- (IBAction)gestureClick:(id)sender;
- (IBAction)logOut:(id)sender;

@end

@implementation FFSetVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UserGesture *gesture = [[DataManager shareDataManager] fetchGestureByUserId:[[NSUserDefaults standardUserDefaults]stringForKey:@"phone"]];
    _gestureSwitch.on = gesture.gestureOn;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title= @"设置";
    self.view.backgroundColor = RGBColor(236, 239, 243);
    CacheViewModel *cacheModel = [[CacheViewModel alloc] init];
    self.cacheSize.text = [NSString stringWithFormat:@"%.2fMB",[cacheModel readCacheSize]];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    self.versionNumber.text = [NSString stringWithFormat:@"%@(%@)",version,build];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verifySuccess) name:@"verifySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSuccess) name:@"setSuccess" object:nil];
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"verifySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setSuccess" object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)changePassA:(id)sender {
    [self.navigationController pushViewController:[FIChangePasswordViewController new] animated:YES];
}
- (IBAction)cleanDiskA:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"清除缓存？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag = 102;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 102) {
        if (buttonIndex == 1) {
            CacheViewModel *cacheModel = [[CacheViewModel alloc] init];
            self.cacheSize.text = [NSString stringWithFormat:@"%.2fMB",[cacheModel clearFile]];
        }
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:NO forKey:@"loginStatus"];
        [self.navigationController popToRootViewControllerAnimated:NO];
        [MainTab shareInstance].selectedIndex = 0;
        [[MainTab shareInstance] showLoginViewWithBlock:nil];
    }
}
- (IBAction)gestureClick:(id)sender {
    if (_gestureSwitch.on == NO) {
        GestureVerifyViewController *verifyVC = [[GestureVerifyViewController alloc] initIsToSetNewGesture:NO needCountLimit:NO];
        [self.navigationController pushViewController:verifyVC animated:YES];
    }else{
        GestureViewController *gestureVc = [[GestureViewController alloc] initWithRegister:2];
        gestureVc.type = GestureViewControllerTypeSetting;
        [self.navigationController pushViewController:gestureVc animated:YES];
    }
}

- (IBAction)logOut:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"退出该账号？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag = 101;
    [alert show];
}
- (void)verifySuccess{
    _gestureSwitch.on = NO;
    [[DataManager shareDataManager] updateGestureOn:_gestureSwitch.on closeFlag:YES userId:[[NSUserDefaults standardUserDefaults]stringForKey:@"phone"]];
    [[DataManager shareDataManager] cleanGestureWithCloseUserId:[[NSUserDefaults standardUserDefaults]stringForKey:@"phone"]];
}
- (void)setSuccess{
    _gestureSwitch.on = YES;
    [[DataManager shareDataManager] updateGestureOn:_gestureSwitch.on closeFlag:NO userId:[[NSUserDefaults standardUserDefaults]stringForKey:@"phone"]];
    
}
@end
