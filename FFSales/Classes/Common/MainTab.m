//
//  MainTab.m
//  b2bManager
//
//  Created by 李传政 on 17/5/5.
//  Copyright © 2017年 李传政. All rights reserved.
//

#import "MainTab.h"
//登录界面
#import "DDLoginVC.h"
#import "DDHomeVC.h"
#import "DDMessageVC.h"
#import "DDMyHome.h"
#import "FIGestureNavViewController.h"
#import "FIUser.h"


@interface MainTab ()<UITabBarDelegate,UITabBarControllerDelegate>{
    NSInteger _kLastSelectIndex;//上一次点击tab的数字，除5以外
}

@end

@implementation MainTab

+ (MainTab*)shareInstance{
    static MainTab *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[MainTab alloc] init];
    });
    return sharedManager;
}

- (UINavigationController * )rootVc:(UIViewController *)_vc{
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:_vc];
    [nav.navigationBar setBarTintColor:[UIColor whiteColor]];
    nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor darkTextColor],NSFontAttributeName:Font(18)};
    return nav;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _kLastSelectIndex = 0;
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    self.tabBar.translucent = NO;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor darkGrayColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor redColor] , NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    
    
    DDHomeVC *sub1 = [[DDHomeVC alloc] init];
    sub1.title = @"首页";
    
    DDMessageVC *sub2 = [[  DDMessageVC alloc] init];
    sub2.title = @"消息";
//    UIViewController *sub3 = [[UIViewController alloc] init];
//    sub3.title = @"商城";
    DDMyHome *sub4 = [[DDMyHome alloc] init];
    sub4.title = @"我的";
    
    
    
    [self setViewControlerTarbar:sub1 andNormalImage:Img(@"icon-home-wdj") andSelectImage:Img(@"icon-home-dj")];
    [self setViewControlerTarbar:sub2 andNormalImage:Img(@"icon-xx-wdj") andSelectImage:Img(@"icon-xx-dj")];
//    [self setViewControlerTarbar:sub3 andNormalImage:Img(@"icon-shanjia-wdj") andSelectImage:Img(@"icon-shanjia-dj")];
    [self setViewControlerTarbar:sub4 andNormalImage:Img(@"icon-wd-wdj") andSelectImage:Img(@"icon-wd-dj")];

    
    NSArray *array = @[[self rootVc:sub1],
                       [self rootVc:sub2],
//                       [self rootVc:sub3],
                       [self rootVc:sub4]];
    [self setViewControllers:array];
    self.delegate = self;
    
    //加载基础数据

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setViewControlerTarbar:(UIViewController *)_vc andNormalImage:(UIImage *)_normalImage andSelectImage:(UIImage *)_selectImage{
    [_vc.tabBarItem setImage:[_normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [_vc.tabBarItem setSelectedImage:[_selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

#pragma mark

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    NSInteger index = [tabBarController.viewControllers indexOfObject:viewController];
    if (index == 0 || index == 3) {
        
        if ([FIUser shareUser].loginStatus){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            });
        }        
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

#pragma mark --public--
- (void)showLoginViewWithBlock:(LoginCallBackBlock)_callBack{ 
    DDLoginVC *sub1 = [[DDLoginVC alloc] initWithSource:1];
    sub1.title = @"登录";
    FIGestureNavViewController * nav = [[FIGestureNavViewController alloc]initWithRootViewController:sub1];
    [self presentViewController:nav animated:YES completion:^{
        //
    }];
}

- (void)showForgetViewWithBlock:(LoginCallBackBlock)_callBack{
//    DDLoginVC *sub1 = [[DDLoginVC alloc] initWithLoginBlock:_callBack];
//    sub1.title = @"登录";
//    FIGestureNavViewController * nav = [[FIGestureNavViewController alloc]initWithRootViewController:sub1];
//    [self presentViewController:nav animated:NO completion:^{
//        //
//    }];
//    [sub1 pushToForgetVC];
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if ([tabBar.items indexOfObject:tabBar.selectedItem] != (self.viewControllers.count-1)) {
        _kLastSelectIndex = [tabBar.items indexOfObject:tabBar.selectedItem];
    }
}
- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    [super setSelectedIndex:selectedIndex];
    if ([self.tabBar.items indexOfObject:self.tabBar.selectedItem] != (self.viewControllers.count-1)) {
        _kLastSelectIndex = [self.tabBar.items indexOfObject:self.tabBar.selectedItem];
    }
}
- (NSInteger)getLastIndexViewController{
    return _kLastSelectIndex;
}
@end
