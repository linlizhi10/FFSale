//
//  FFBackMoneyVC.m
//  FFSales
//
//  Created by lin on 2018/6/14.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFBackMoneyVC.h"
#import "BackCell.h"
#import "FFMoneyRequest.h"
#import "MoneyModel.h"
#import "FFMoneyListVC.h"
@interface FFBackMoneyVC (){
    
    NSString *_custId;
}
@property (weak, nonatomic) IBOutlet UITableView *moneyTable;
- (IBAction)checkAll:(id)sender;
@property (strong, nonatomic) NSMutableArray *arrMMm;

@end

@implementation FFBackMoneyVC
- (instancetype)initWithNo:(NSString *)custId {
    self = [super init];
    if (self) {
        _custId = custId;
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"返利";
    [_moneyTable registerNib:[UINib nibWithNibName:@"BackCell" bundle:nil] forCellReuseIdentifier:@"cellBack"];
    _arrMMm = [[NSMutableArray alloc] init];

    //    _orderTable.estimatedRowHeight = 44;
//    _moneyTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addPage)];
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
    
    BackCell *productCell = [tableView dequeueReusableCellWithIdentifier:@"cellBack"];
    BackMoneyTypeModel *model = _arrMMm[indexPath.row];
    NSString *operation = @"";
    if ([model.serviceType isEqualToString:@"01"]) {
        operation = @"复肥";
    }else if ([model.serviceType isEqualToString:@"02"]) {
        operation = @"盐";
       
    }else if ([model.serviceType isEqualToString:@"03"]) {
        operation = @"酒";
      
    }else if ([model.serviceType isEqualToString:@"04"]) {
        operation = @"联碱";
        
    }
    productCell.type.text = operation;
    productCell.useAmount.text = [NSString stringWithFormat:@"￥%.2f",model.availableBalance];
    productCell.lockAmount.text = [NSString stringWithFormat:@"￥%.2f",model.lockAmount];
    
    return productCell;
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 126;
}

- (void)dataLoad{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FFBackMoneyCRequest *request = [FFBackMoneyCRequest Request];
    request.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_moneyTable.footer endRefreshing];
        
        if (isSuccess) {
            BackMoney *model = [BackMoney objectWithKeyValues:result.allDic];
            [_arrMMm addObjectsFromArray:model.list];
            if (model.list.count == 0) {
                BackMoneyTypeModel *model1 = [[BackMoneyTypeModel alloc]init];
                model1.serviceType = @"01";
                model1.lockAmount = 0.00;
                model1.availableBalance = 0.00;
                [_arrMMm addObject:model1];
            }
            
//            if (model.list.count == 0) {
//                [_moneyTable.footer endRefreshingWithNoMoreData];
//            }
//            if (_arrMMm.count == result.totalRecord) {
//                [_moneyTable.footer endRefreshingWithNoMoreData];
//
//            }
//            if (_currentPage == [[result.allDic objectForKey:@"pages"] intValue]) {
//                [_moneyTable.footer endRefreshingWithNoMoreData];
//            }
            [_moneyTable reloadData];
            
            
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [WToast showWithTextCenter:result.message];
        }
    }];
}
- (IBAction)checkAll:(id)sender {
    FFMoneyListVC *listVC = [[FFMoneyListVC alloc] initWithType:9];
    [self.navigationController pushViewController:listVC animated:YES];
}
@end
