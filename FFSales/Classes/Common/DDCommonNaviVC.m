//
//  DDCommonNaviVC.m
//  DaDong
//
//  Created by 李传政 on 2018/2/28.
//  Copyright © 2018年 WintrueTeam. All rights reserved.
//

#import "DDCommonNaviVC.h"

@interface DDCommonNaviVC ()

@end

@implementation DDCommonNaviVC

- (instancetype)init{
    if (self = [super init]) {
        
        if ([[self.navigationController viewControllers] indexOfObject:self] == 0) {
//            self.hidesBottomBarWhenPushed = YES;
        }
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.view.backgroundColor = RGBColor(234, 234, 234);
    
    if ([self isShowBackButton]) {
    
        UIButton *btn= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        [btn setImage:Img(@"icon-bank") forState:UIControlStateNormal];
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"sourceChannel"]isEqualToString:@"EMP"]) {
            [btn setImage:Img(@"icon-bank-1") forState:UIControlStateNormal];

            
        }
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 5)];
        [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = barBtnItem;
        
    }else{
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)isShowBackButton{
    if ([[self.navigationController viewControllers] indexOfObject:self] == 0) {
        return NO;
    }
    return YES;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
