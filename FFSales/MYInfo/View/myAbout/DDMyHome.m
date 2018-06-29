//
//  DDMyHome.m
//  FFSales
//
//  Created by lin on 2018/5/30.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "DDMyHome.h"
#import "FFRankClassVC.h"
#import "FFMoneyListVC.h"
#import "FIMyInfoCell.h"
#import "FIMyIfoViewModel.h"
#import "FIContentModel.h"
#import "FFMHomeRequest.h"
#import "FFMHomeModel.h"
#import "FFSetVC.h"
#import "FFOrderVC.h"
#import "FFOtherMoneyVC.h"
#import "FFHistoryVC.h"
#import "FFUseMoney.h"
#import "FFMyinfoDetailVC.h"
#import "FFBackMoneyVC.h"
#import "FFInvoiceVC.h"
#import "FFGetGoodsVC.h"
@interface DDMyHome ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic, strong) NSMutableArray *arrData;
@property (weak, nonatomic) IBOutlet UITableView *contentTable;
@property (strong, nonatomic) IBOutlet UITableViewCell *contentCell;
@property (weak, nonatomic) IBOutlet UILabel *useAmount;
@property (weak, nonatomic) IBOutlet UILabel *preAmount;
@property (weak, nonatomic) IBOutlet UILabel *usableAmount;
- (IBAction)noCheckA:(id)sender;
- (IBAction)readySend:(id)sender;
- (IBAction)completeAction:(id)sender;
- (IBAction)myOrderAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *noCheckNo;
@property (weak, nonatomic) IBOutlet UILabel *readySendNo;
@property (weak, nonatomic) IBOutlet UILabel *completeNo;
@property (weak, nonatomic) IBOutlet UILabel *myOrderNo;
@property (strong, nonatomic)  FFMHomeModel *model;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *role;
@property (nonatomic, strong) UIAlertView *alert;
@property (copy, nonatomic) NSString *customerTel;
- (IBAction)useAmountAction:(id)sender;
- (IBAction)preAction:(id)sender;
- (IBAction)backAmountAction:(id)sender;
- (IBAction)personInfo:(id)sender;

@end

@implementation DDMyHome
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self myHomeRequest];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    _customerTel = @"400-110-3898";
    _model= [[FFMHomeModel alloc] init];
    _arrData = [[NSMutableArray alloc] initWithArray:[FIMyIfoViewModel infoContentArray]];
    [_contentTable registerNib:[UINib nibWithNibName:@"FIMyInfoCell" bundle:nil] forCellReuseIdentifier:@"FIMyInfoCell"];
    [self setNavi];
//    [self myHomeRequest];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        _contentCell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 278);
        _name.text = _model.custName;
        _role.text = _model.customerType;
        return _contentCell;
    }else{
        FIMyInfoCell *productCell = [tableView dequeueReusableCellWithIdentifier:@"FIMyInfoCell"];
        FIContentModel *content = _arrData[indexPath.row-1];
        productCell.flagImage.image = [UIImage imageNamed:content.imageName];
        productCell.contentTitle.text = content.contentTitle;
        productCell.subtitle.text = content.contentSubtitle;
//        if(indexPath.row == 2){
//            NSString *str = _model.needCheckAccount?@"本月已对账":@"本月未对账";
//            productCell.subtitle.text = str;
//        }
    //    _rightArrow.hidden = content.hideArrow;
        return productCell;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 278;
    }else{
        return 60;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 1:
        {
            FFRankClassVC *orderVC= [[FFRankClassVC alloc] init];
            orderVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:orderVC animated:YES];
        }
            break;
        case 2:
        {
            
            [self callAction:nil];
        }
            break;
        case 3:
            {
                FFInvoiceVC *orderVC= [[FFInvoiceVC alloc] init];
                orderVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:orderVC animated:YES];
            }
            break;
        case 4:
        {
            FFGetGoodsVC *orderVC= [[FFGetGoodsVC alloc] init];
            orderVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:orderVC animated:YES];
        }
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setNavi{
    UIButton *but1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    but1.frame =CGRectMake(0,0, 60, 44);
    
    [but1 setImage:Img(@"icon-sz-h") forState:UIControlStateNormal];
    
    [but1 addTarget:self action:@selector(setAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem  *barBut1 = [[UIBarButtonItem alloc] initWithCustomView:but1];
    
    self.navigationItem.rightBarButtonItem = barBut1;
    
    //定制左按钮
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    
    but.frame =CGRectMake(0,0, 60, 44);
    
    [but setTitle:@"资金明细"forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont systemFontOfSize:14];
    [but setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(moneyHistoryA) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem  *barBut = [[UIBarButtonItem alloc]initWithCustomView:but];
    
    self.navigationItem.leftBarButtonItem = barBut;
}
- (void)myHomeRequest{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    FFMHomeRequest *request = [FFMHomeRequest Request];
    request.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
   
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSuccess) {
            
            FFMHomeModel *model = [FFMHomeModel objectWithKeyValues:result.allDic];
            _model = model;
            [_contentTable reloadData];
            _preAmount.text = [NSString stringWithFormat:@"￥%.2f",model.marginAvailable];
            _usableAmount.text = [NSString stringWithFormat:@"￥%.2f",model.rebateAvailable];
            _useAmount.text = [NSString stringWithFormat:@"￥%.2f",model.accountAvailable];
            _noCheckNo.text = [NSString stringWithFormat:@"%d",model.waitAuditOrderNum];
            _readySendNo.text = [NSString stringWithFormat:@"%d",model.deliveryOrderNum];
            if(model.waitAuditOrderNum > 0){
                _noCheckNo.hidden = NO;
//                _noCheckNo.layer.masksToBounds = YES;
            }
            if(model.deliveryOrderNum > 0){
                _readySendNo.hidden = NO;
            }
            [_contentTable reloadData];
        }else{
            [WToast showWithTextCenter:result.message];
        }
    }];
    
}
- (void)setAction{
    FFSetVC *setVC = [[FFSetVC alloc] init];
    setVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setVC animated:YES];
}
- (void)moneyHistoryA{
    FFMoneyListVC *orderVC= [[FFMoneyListVC alloc] init];
    orderVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderVC animated:YES];
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
    orderVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderVC animated:YES];
}
- (IBAction)useAmountAction:(id)sender {
    FFUseMoney *orderVC= [[FFUseMoney alloc] init];
    orderVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderVC animated:YES];
}
- (IBAction)preAction:(id)sender {
    FFOtherMoneyVC *orderVC= [[FFOtherMoneyVC alloc] init];
    orderVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (IBAction)backAmountAction:(id)sender {
    FFBackMoneyVC *orderVC= [[FFBackMoneyVC alloc] init];
    orderVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (IBAction)personInfo:(id)sender {
    FFMyinfoDetailVC *detail= [[FFMyinfoDetailVC alloc] initWithNo:_model.custId];
    detail.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:detail animated:YES];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSLog(@"phone");
        NSString *telphoneStr = [NSString stringWithFormat:@"tel:%@",_customerTel];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telphoneStr]];
        
    }
}
- (IBAction)callAction:(id)sender {
    NSLog(@"call action");
    NSString *str2 = [[UIDevice currentDevice] systemVersion];
    if ([str2 compare:@"10.2" options:NSNumericSearch] == NSOrderedDescending || [str2 compare:@"10.2" options:NSNumericSearch] == NSOrderedSame)
    {
        NSString* PhoneStr = [NSString stringWithFormat:@"telprompt://%@",_customerTel];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PhoneStr] options:@{} completionHandler:^(BOOL success) {
            NSLog(@"phone success");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        //        [MBProgressHUD hideHUDForView:self.view];
        
    }else{
        if (!_alert) {
            _alert = [[UIAlertView alloc] initWithTitle:nil message:_customerTel delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
        }
        
        [_alert show];
    }
}
@end
