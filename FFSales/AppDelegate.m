//
//  AppDelegate.m
//  FFSales
//
//  Created by lin on 2018/5/30.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "AppDelegate.h"
#import "DDLoginVC.h"
#import <IQKeyboardManager.h>
#import "DataManager.h"
#import "MainTab.h"
#import "GestureVerifyViewController.h"
#import "FFEmpHomeVC.h"
@interface AppDelegate ()
@property (nonatomic, strong) GestureVerifyViewController *gestureVerifyVc;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UINavigationController *nav = nil;
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    DataManager *dbM = [DataManager shareDataManager];
//        [dbM dropTable];
    [dbM createTable];
    
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"loginStatus"];
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"loginStatus"] boolValue] == YES) {

        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"sourceChannel"]isEqualToString:@"EMP"]) {
            FFEmpHomeVC *empHome = [[FFEmpHomeVC alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:empHome];
            [nav.navigationBar setBarTintColor:RGBCOLORV(0x4BAE4F)];
            nav.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
//            [nav.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//            [nav.navigationBar setShadowImage:[UIImage new]];
            nav.navigationBar.translucent = NO;
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            [self.window setRootViewController:nav];
            
        }else{
            [self.window setRootViewController:[MainTab shareInstance]];
            
        }

    }else{
//        nav = [[UINavigationController alloc]initWithRootViewController:[DDLoginVC new]];
        [self.window setRootViewController:[DDLoginVC new]];

    }
    
    
//    [nav.navigationBar setBarTintColor:[UIColor whiteColor]];
//    nav.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor darkTextColor] forKey:NSForegroundColorAttributeName];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self gestureVerify];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [self gestureVerify];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)gestureVerify{
    BOOL loginStatus = [[NSUserDefaults standardUserDefaults] boolForKey:@"loginStatus"];
    if (loginStatus) {
        UserGesture *gesture = [[DataManager shareDataManager] fetchGestureByUserId:[[NSUserDefaults standardUserDefaults]stringForKey:@"phone"]];
        if (gesture && gesture.gestureOn && gesture.gestureWord.length > 0) {
            if (!_gestureVerifyVc) {
                _gestureVerifyVc = [[GestureVerifyViewController alloc] initIsToSetNewGesture:NO needCountLimit:YES];
                
            }
            //            FIGestureNavViewController * nav = [[FIGestureNavViewController alloc]initWithRootViewController:gestureVerifyVc];
            _gestureVerifyVc.view.tag = 10000;
            [[UIApplication sharedApplication].keyWindow addSubview:_gestureVerifyVc.view];
            
            //            [[MainTab shareInstance] presentViewController:nav animated:NO completion:nil];
        }
    }
    
}

@end
