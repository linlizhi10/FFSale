//
//  FFEmpHomeVC.m
//  FFSales
//
//  Created by lin on 2018/6/20.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFEmpHomeVC.h"
#import "FFOrderVC.h"
#import "FFHomeRequest.h"
#import "FFHomeBModel.h"
#import "FFAllCategoryVC.h"
#import "FFCustomerMVC.h"
#import "FFCustomerListVC.h"
#import "FFSetVC.h"
#import <UINavigationController+FDFullscreenPopGesture.h>
@interface FFEmpHomeVC ()
@property (weak, nonatomic) IBOutlet UILabel *customerNumber;
@property (weak, nonatomic) IBOutlet UILabel *addCustomerNO;
@property (weak, nonatomic) IBOutlet UILabel *orderNO;
@property (strong, nonatomic) NSMutableArray *brandA;
@property (strong, nonatomic) NSMutableArray *strainA;
- (IBAction)noCheckA:(id)sender;

- (IBAction)readySend:(id)sender;

- (IBAction)completeAction:(id)sender;

- (IBAction)myOrderAction:(id)sender;

- (IBAction)customerAction:(id)sender;

- (IBAction)addCustomerAction:(id)sender;

- (IBAction)todayOrderAction:(id)sender;


@end

@implementation FFEmpHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideBackBtn];
    self.navigationController.navigationBar.backgroundColor= RGBCOLORV(0x4bae4f);
    UIButton *but1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    but1.frame =CGRectMake(0,0, 60, 44);
    
    [but1 setImage:Img(@"icon-sz") forState:UIControlStateNormal];
    
    [but1 addTarget:self action:@selector(setAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem  *barBut1 = [[UIBarButtonItem alloc] initWithCustomView:but1];
    
    self.navigationItem.rightBarButtonItem = barBut1;
//    [self homeData];
    [self brandRequestType:@"1"];
    [self brandRequestType:@"2"];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.fd_interactivePopDisabled = YES;
    [self homeData];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.fd_interactivePopDisabled = NO;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)noCheckA:(id)sender {
    FFOrderVC *orderVC= [[FFOrderVC alloc] initWithType:1];
    orderVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (IBAction)readySend:(id)sender {
    FFOrderVC *orderVC= [[FFOrderVC alloc] initWithType:2];
    orderVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (IBAction)completeAction:(id)sender {
    FFOrderVC *orderVC= [[FFOrderVC alloc] initWithType:3];
    orderVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (IBAction)myOrderAction:(id)sender {
    FFOrderVC *orderVC= [[FFOrderVC alloc] initWithType:0];
//    orderVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (IBAction)addCustomerAction:(id)sender {
    FFCustomerListVC *customerMVC = [[FFCustomerListVC alloc] initWithNew:YES];
    [self.navigationController pushViewController:customerMVC animated:YES];
}

- (IBAction)todayOrderAction:(id)sender {
    FFOrderVC *orderVC= [[FFOrderVC alloc] initWithNew:YES];
//    orderVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (IBAction)priductAction:(id)sender {
    FFAllCategoryVC *inventoryVC = [[FFAllCategoryVC alloc] initWithId:_brandA strain:_strainA];
//    inventoryVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:inventoryVC animated:YES];
}

- (IBAction)customerAction:(id)sender {
    FFCustomerListVC *customerMVC = [[FFCustomerListVC alloc] init];
    [self.navigationController pushViewController:customerMVC animated:YES];
}

- (IBAction)customerMoneyAction:(id)sender {
    FFCustomerMVC *customerMVC = [[FFCustomerMVC alloc] init];
    [self.navigationController pushViewController:customerMVC animated:YES];
}
- (IBAction)customerBuildAction:(id)sender {
    
}



- (void)homeData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    WS(ws);
    FFEMPHomeRequest *request = [FFEMPHomeRequest Request];
    request.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    //    request.password = @"168e969d48e2fe1c7a1f84f41f2cc2cd";
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSuccess) {
            
            NSLog(@"success");
            FFHomeEMP *model = [FFHomeEMP objectWithKeyValues:result.allDic];
            ws.title = model.empName;
            ws.customerNumber.text = [NSString stringWithFormat:@"%ld",model.custNum];
            ws.addCustomerNO.text = [NSString stringWithFormat:@"今日新增客户:%ld",model.newCustNum];
            ws.orderNO.text = [NSString stringWithFormat:@"今日订单:%ld",model.newOrderNum];

        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [WToast showWithTextCenter:result.message];
        }
    }];
    
}

- (void)brandRequestType:(NSString *)type{
    if ([type isEqualToString:@"2"]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    }
    FFHomeBrandRequest *request = [FFHomeBrandRequest Request];
    request.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    request.levels = type;
    //    request.password = @"168e969d48e2fe1c7a1f84f41f2cc2cd";
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSuccess) {
            
            NSLog(@"success");
            FFHomeBrandA *model = [FFHomeBrandA objectWithKeyValues:result.allDic];
            
            if ([type isEqualToString:@"1"]) {
                _brandA = [NSMutableArray arrayWithArray:model.list];
                
                
            }else if ([type isEqualToString:@"2"]){
                _strainA = [NSMutableArray arrayWithArray:model.list];
                
                
                
            }
            
            
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [WToast showWithTextCenter:result.message];
        }
    }];
}
- (void)setAction{
    [self.navigationController pushViewController:[FFSetVC new] animated:YES];
}
@end
