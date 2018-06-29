//
//  FFCustomerMVC.m
//  FFSales
//
//  Created by lin on 2018/6/20.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFCustomerMVC.h"
#import "CustomerMCell.h"
#import "MoneyModel.h"
#import "FFMoneyRequest.h"
#import "FFBackMoneyVC.h"
#import "FFUseMoney.h"
#import "FFBackMoneyVC.h"
#import "FFOtherMoneyVC.h"
@interface FFCustomerMVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
}
@property (weak, nonatomic) IBOutlet UITextField *contextTF;
@property (weak, nonatomic) IBOutlet UITableView *moneyTable;
@property (assign, nonatomic) int pageSize;
@property (assign, nonatomic) int currentPage;
@property (strong, nonatomic) NSMutableArray *arrMMm;
@end

@implementation FFCustomerMVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户资金";
    
    _arrMMm = [[NSMutableArray alloc] init];
    _currentPage = 1;
    _pageSize = 10;
    
    [_moneyTable registerNib:[UINib nibWithNibName:@"CustomerMCell" bundle:nil] forCellReuseIdentifier:@"cellCus"];
        _moneyTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addPage)];
    [self dataLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    [_arrMMm removeAllObjects];
    [_moneyTable reloadData];
    _currentPage = 1;
    [self dataLoad];
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _arrMMm.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CustomerMCell *productCell = [_moneyTable dequeueReusableCellWithIdentifier:@"cellCus"];
    [productCell.useBtn addTarget:self action:@selector(clickMore:) forControlEvents:UIControlEventTouchUpInside];
    productCell.useBtn.tag = indexPath.row + 100;
    [productCell.fanliBtn addTarget:self action:@selector(clickFanli:) forControlEvents:UIControlEventTouchUpInside];
    productCell.fanliBtn.tag = indexPath.row + 100;
    [productCell.otherBtn addTarget:self action:@selector(clickOther:) forControlEvents:UIControlEventTouchUpInside];
    productCell.otherBtn.tag = indexPath.row + 100;
    
    CustomerMoneyItemModel *model = _arrMMm[indexPath.row];
    productCell.moneyType.text = [NSString stringWithFormat:@"%@",model.custName];
    
    productCell.useAmount.text = [NSString stringWithFormat:@"￥%.2f",model.accountAvailable];
    productCell.waitAmount.text = [NSString stringWithFormat:@"￥%.2f",model.rebateAvailable];
    productCell.alreadyAmount.text = [NSString stringWithFormat:@"￥%.2f",model.marginAvailable];
    
    
    return productCell;
    
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 126;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
    
}
- (void)dataLoad{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FFCustomerMoneyRequest *request = [FFCustomerMoneyRequest Request];
    request.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    request.keyword = _contextTF.text;
    request.page = _currentPage;
    request.size = _pageSize;
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_moneyTable.footer endRefreshing];
        
        
        if (isSuccess) {
            CustomerMoney *model = [CustomerMoney objectWithKeyValues:result.allDic];
            [_arrMMm addObjectsFromArray:model.list];
            
            
            if (model.list.count == 0) {
                [_moneyTable.footer endRefreshingWithNoMoreData];
            }
            if (_arrMMm.count == result.totalRecord) {
                [_moneyTable.footer endRefreshingWithNoMoreData];
                
            }
            if (_currentPage == [[result.allDic objectForKey:@"pages"] intValue]) {
                [_moneyTable.footer endRefreshingWithNoMoreData];
            }
            [_moneyTable reloadData];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [WToast showWithTextCenter:result.message];
        }
    }];
}
- (void)addPage{
    _currentPage++;
    [self dataLoad];
}

- (void)clickMore:(UIButton *)btn{
    CustomerMoneyItemModel *model = _arrMMm[btn.tag - 100];

    FFUseMoney *customerMVC = [[FFUseMoney alloc] initWithNo:model.custId];
    [self.navigationController pushViewController:customerMVC animated:YES];
}
- (void)clickFanli:(UIButton *)btn{
    CustomerMoneyItemModel *model = _arrMMm[btn.tag - 100];
    
    FFBackMoneyVC *customerMVC = [[FFBackMoneyVC alloc] initWithNo:model.custId];
    [self.navigationController pushViewController:customerMVC animated:YES];
}
- (void)clickOther:(UIButton *)btn{
    CustomerMoneyItemModel *model = _arrMMm[btn.tag - 100];
    
    FFOtherMoneyVC *customerMVC = [[FFOtherMoneyVC alloc] initWithNo:model.custId];
    [self.navigationController pushViewController:customerMVC animated:YES];
}

@end
