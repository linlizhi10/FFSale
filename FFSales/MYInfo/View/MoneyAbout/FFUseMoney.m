//
//  FFUseMoney.m
//  FFSales
//
//  Created by lin on 2018/6/12.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFUseMoney.h"
#import "CashCell.h"
#import "CreditCell.h"
#import "FFHistoryVC.h"
#import "FFMoneyRequest.h"
#import "MoneyModel.h"
#import "FFSubCreditVC.h"
@interface FFUseMoney ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *cashBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UIButton *creaditBtn;
@property (assign, nonatomic)  int moneyType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipViewLeftMargin;
@property (strong, nonatomic) NSMutableArray *arrMMm;
@property (assign, nonatomic) int pageSize;
@property (assign, nonatomic) int currentPage;

@property (weak, nonatomic) IBOutlet UITableView *cashTable;
@property (weak, nonatomic) IBOutlet UITableView *creaditTable;
@property (weak, nonatomic) IBOutlet UIView *creaditView;
@property (weak, nonatomic) IBOutlet UIView *cashView;
@property (strong, nonatomic) moneyTypeModel *money;
@end

@implementation FFUseMoney

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"可用资金";
    _arrMMm = [[NSMutableArray alloc] init];
    _currentPage = 1;
    _pageSize = 10;
    _arrMMm = [[NSMutableArray alloc] init];
    _cashBtn.selected = YES;

   
    [_cashTable registerNib:[UINib nibWithNibName:@"CashCell" bundle:nil] forCellReuseIdentifier:@"cellCash"];
    [_creaditTable registerNib:[UINib nibWithNibName:@"CreditCell" bundle:nil] forCellReuseIdentifier:@"cellCredit"];

    //    _orderTable.estimatedRowHeight = 44;
//    _creaditTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addPage)];
    [self dataLoad];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _tipViewLeftMargin.constant = (SCREEN_WIDTH / 3 - 40)/2;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)topBtnAction:(id)sender {
    UIButton *btn = (UIButton *)sender;

    _moneyType = (int)btn.tag;
    if (_moneyType == 0) {
        _cashBtn.selected = YES;
        _checkBtn.selected = NO;
        _creaditBtn.selected = NO;
    }else if (_moneyType == 1){
        _cashBtn.selected = NO;
        _checkBtn.selected = YES;
        _creaditBtn.selected = NO;

    }else if (_moneyType == 2){
        _cashBtn.selected = NO;
        _checkBtn.selected = NO;
        _creaditBtn.selected = YES;

    }
    btn.backgroundColor = [UIColor whiteColor];
    _tipViewLeftMargin.constant = (SCREEN_WIDTH / 3 - 40)/2 + (SCREEN_WIDTH / 3)*(btn.tag);
    [self.view setNeedsLayout];
    [self.view updateConstraints];
//    [_arrMMm removeAllObjects];
//    [_orderTable reloadData];
    if (_moneyType == 2) {
        _creaditView.hidden = NO;
        _cashView.hidden = YES;
    }else{
        _creaditView.hidden = YES;
        _cashView.hidden = NO;
    }
    [self dataLoad];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView != _creaditTable) {
        return _money.records.count;
    }
    return _arrMMm.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _cashTable) {
        CashCell *productCell = [_cashTable dequeueReusableCellWithIdentifier:@"cellCash"];
        MoneySmallModel *smallm = _money.records[indexPath.row];
        productCell.contentLabel.text = [NSString stringWithFormat:@"%@ 金额:%.2f",[self toDateString:smallm.opTime],smallm.amt];
        return productCell;

    }else{
        CreditCell *productCell = [_creaditTable dequeueReusableCellWithIdentifier:@"cellCredit"];
        creaditSmallModel *model = _arrMMm[indexPath.row];
        NSString *type = @"";
        if ([model.childrenAccountType isEqualToString:@"07"]) {
            type = @"垫底";
        }else if ([model.childrenAccountType isEqualToString:@"08"]) {
            type = @"理财授信";
        }else if ([model.childrenAccountType isEqualToString:@"06"]) {
            type = @"临时授信";
        }
        productCell.moreBtn.tag = indexPath.row;
        [productCell.moreBtn addTarget:self action:@selector(clickMore:) forControlEvents:UIControlEventTouchUpInside];
        productCell.moneyType.text = type;
        productCell.useAmount.text = [NSString stringWithFormat:@"￥%.2f",model.availableBalance];
        productCell.waitAmount.text = [NSString stringWithFormat:@"￥%.2f",model.needPayment];
        productCell.alreadyAmount.text = [NSString stringWithFormat:@"￥%.2f",model.alreadyRepayment];

        return productCell;

    }
  
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _creaditTable) {
        creaditSmallModel *model = _arrMMm[indexPath.row];
        FFSubCreditVC *subVC = [[FFSubCreditVC alloc] initWithNo:model.childrenAccountType];
        [self.navigationController pushViewController:subVC animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _creaditTable) {
        return 126;
    }
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _creaditTable) {
        return 1;
    }
    return 76;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView != _creaditTable) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 76)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60) /2, 6, 60, 20)];
        label1.textColor = RGBCOLORV(0xFEA406);
        label1.font = [UIFont systemFontOfSize:11];
        label1.text = @"可用金额";
        [view addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 26, SCREEN_WIDTH - 20, 40)];
        label2.textColor = RGBCOLORV(0x333333);
        label2.font = [UIFont systemFontOfSize:20];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.text = [NSString stringWithFormat:@"￥%.2f",_money.availableBalance];
        [view addSubview:label2];
        return view;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView != _creaditTable) {
        return 40;
    }
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView != _creaditTable) {

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but setTitle:@"查看所有资金" forState:UIControlStateNormal];
    [but setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    but.frame = CGRectMake(0, 0, SCREEN_WIDTH -20, 40);
    but.titleLabel.font = [UIFont systemFontOfSize:14];
    but.backgroundColor = [UIColor whiteColor];
    [but addTarget:self action:@selector(checkAllAction) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:but];;
        return view;}
    return nil;
}
- (void)dataLoad{
    if (_moneyType == 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        FFMoneyRequest *request = [FFMoneyRequest Request];
        request.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
        [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (isSuccess) {
                
                MoneyModel *model = [MoneyModel objectWithKeyValues:result.allDic];
                for (moneyTypeModel *type in model.accountInfos) {
                    if ([type.serviceType isEqualToString:@"01"]) {
                        _money = type;
                        [_cashTable reloadData];

                        return ;
                    }
                }

            }else{
                [WToast showWithTextCenter:result.message];
            }
        }];
    }else if (_moneyType == 1){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        FFMoneyBRequest *request = [FFMoneyBRequest Request];
        request.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
        [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
            if (isSuccess) {
                MoneyModel *model = [MoneyModel objectWithKeyValues:result.allDic];
                for (moneyTypeModel *type in model.accountInfos) {
                    if ([type.serviceType isEqualToString:@"01"]) {
                        _money = type;
                        [_cashTable reloadData];

                        return ;
                    }
                }
            }else{
                [WToast showWithTextCenter:result.message];
            }
        }];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        FFMoneyCRequest *request = [FFMoneyCRequest Request];
        request.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
        [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [_creaditTable.footer endRefreshing];
            
            if (isSuccess) {
                creaditModel *model = [creaditModel objectWithKeyValues:result.allDic];
                for (creaditTypeModel *type in model.list) {
                    if ([type.serviceType isEqualToString:@"01"]) {
                        [_arrMMm addObjectsFromArray:type.accountInfos];
                        if (type.accountInfos.count == 0) {
                            [_creaditTable.footer endRefreshingWithNoMoreData];
                        }
                        if (_arrMMm.count >= result.totalRecord) {
                            [_creaditTable.footer endRefreshingWithNoMoreData];

                        }
                        if (_currentPage == [[result.allDic objectForKey:@"pages"] intValue]) {
                            [_creaditTable.footer endRefreshingWithNoMoreData];
                        }
                        [_creaditTable reloadData];
                        return ;
                    }
                }
                
            }else{
                [WToast showWithTextCenter:result.message];
            }
        }];
    }
    
    
   
}
- (void)addPage{
    _currentPage++;
    [self dataLoad];
}
- (void)checkAllAction{
    if (_moneyType == 0) {
        FFHistoryVC *orderD = [[FFHistoryVC alloc] initWithNo:@"01"];
        [self.navigationController pushViewController:orderD animated:YES];
    }else if (_moneyType == 1){
        FFHistoryVC *orderD = [[FFHistoryVC alloc] initWithNo:@"04,05"];
        [self.navigationController pushViewController:orderD animated:YES];
    }
   
}
- (NSString *)toDateString:(long)longDate{
    NSDate*timeDate = [[NSDate alloc]initWithTimeIntervalSince1970:longDate/1000.0];
    
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    
    dateFormatter.dateFormat=@"yyyyMMdd";
    
    return [dateFormatter stringFromDate:timeDate];
}
- (void)clickMore:(UIButton *)btn{
    creaditSmallModel *model = _arrMMm[btn.tag];
    FFSubCreditVC *subVC = [[FFSubCreditVC alloc] initWithNo:model.childrenAccountType];
    [self.navigationController pushViewController:subVC animated:YES];
}
@end
