//
//  FFSubCreditVC.m
//  FFSales
//
//  Created by lin on 2018/6/13.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFSubCreditVC.h"
#import "CreditCell.h"
#import "FFMoneyRequest.h"
#import "MoneyModel.h"
#import "FFCreaditDVC.h"
@interface FFSubCreditVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *_childrenAccountType;
    NSString *_custId;

}
@property (assign, nonatomic) int pageSize;
@property (assign, nonatomic) int currentPage;
@property (strong, nonatomic) NSMutableArray *arrMMm;
@property (weak, nonatomic) IBOutlet UITableView *creaditTable;

@end

@implementation FFSubCreditVC
- (instancetype)initWithNo:(NSString *)type custId:(NSString *)custId{
    self = [super init];
    if (self) {
        _childrenAccountType = type;
        _custId = custId;
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"授信";

    _arrMMm = [[NSMutableArray alloc] init];
    _currentPage = 1;
    _pageSize = 10;
    
    [_creaditTable registerNib:[UINib nibWithNibName:@"CreditCell" bundle:nil] forCellReuseIdentifier:@"cellCredit"];

    //    _orderTable.estimatedRowHeight = 44;
//    _creaditTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addPage)];
    [self dataLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    CreditCell *productCell = [_creaditTable dequeueReusableCellWithIdentifier:@"cellCredit"];
    [productCell setType:1];
    [productCell.moreBtn addTarget:self action:@selector(clickMore:) forControlEvents:UIControlEventTouchUpInside];

    SubCreaditSmallModel *model = _arrMMm[indexPath.row];
    productCell.subTitle.text = [NSString stringWithFormat:@"授信金额:￥%.2f",model.approvedAmount];
    productCell.moneyType.text = [NSString stringWithFormat:@"资金编号:%@",model.accountId];

    productCell.useAmount.text = [NSString stringWithFormat:@"￥%.2f",model.availableBalance];
    productCell.waitAmount.text = [NSString stringWithFormat:@"￥%.2f",model.needPayment];
    productCell.alreadyAmount.text = [NSString stringWithFormat:@"￥%.2f",model.alreadyRepayment];
    NSString *tipsMessage = @"";
    if (model.endDate >0) {
        tipsMessage = [NSString stringWithFormat:@"%ld天后到期",model.endDate];
    }else if (model.overdays > 0){
        tipsMessage = [NSString stringWithFormat:@"超期%ld天",model.endDate];

    }
    if (tipsMessage.length >0) {
        productCell.limitTip.hidden = NO;
        productCell.limitTip.text = tipsMessage;
    }else{
        productCell.limitTip.hidden = YES;

    }
    return productCell;
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SubCreaditSmallModel *model = _arrMMm[indexPath.row];
    FFCreaditDVC *detailVC = [[FFCreaditDVC alloc] initWithNo: model.accountId]  ;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 126;
}

- (void)dataLoad{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FFCreaditSubRequest *request = [FFCreaditSubRequest Request];
    request.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    request.serviceType = @"01";
    request.childrenAccountType = _childrenAccountType;
//    request.childrenAccountType = @"06";
    if (_custId.length > 0) {
        request.custId = _custId;

    }
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_creaditTable.footer endRefreshing];

    
            if (isSuccess) {
                SubCreaditModel *model = [SubCreaditModel objectWithKeyValues:result.allDic];
                [_arrMMm addObjectsFromArray:model.list];

                
                if (model.list.count == 0) {
                    [_creaditTable.footer endRefreshingWithNoMoreData];
                }
                if (_arrMMm.count == result.totalRecord) {
                    [_creaditTable.footer endRefreshingWithNoMoreData];
                    
                }
                if (_currentPage == [[result.allDic objectForKey:@"pages"] intValue]) {
                    [_creaditTable.footer endRefreshingWithNoMoreData];
                }
                [_creaditTable reloadData];
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
    SubCreaditSmallModel *model = _arrMMm[btn.tag];
    FFCreaditDVC *detailVC = [[FFCreaditDVC alloc] initWithNo: model.accountId];
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end
