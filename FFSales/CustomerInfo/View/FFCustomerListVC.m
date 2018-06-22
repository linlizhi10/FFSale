//
//  FFCustomerListVC.m
//  FFSales
//
//  Created by lin on 2018/6/21.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFCustomerListVC.h"
#import "FFCustomerModel.h"
#import "FFCustomerRequest.h"
#import "CustomerCell.h"
#import "FFCustomerDetailVC.h"
@interface FFCustomerListVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *customerTable;
@property (weak, nonatomic) IBOutlet UITextField *contentTF;
@property (assign, nonatomic) int pageSize;
@property (assign, nonatomic) int currentPage;
@property (strong, nonatomic) NSMutableArray *arrCustomer;
@end

@implementation FFCustomerListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户信息";
    _currentPage = 1;
    _pageSize = 10;
    _arrCustomer = [[NSMutableArray alloc] init];
    [_customerTable registerNib:[UINib nibWithNibName:@"CustomerCell" bundle:nil] forCellReuseIdentifier:@"cellCustomer"];
    _customerTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addPage)];
    [self dataLoadCust];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    [_arrCustomer removeAllObjects];
    [_customerTable reloadData];
    [self dataLoadCust];
    return YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _arrCustomer.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     CustomerCell *productCell = [_customerTable dequeueReusableCellWithIdentifier:@"cellCustomer"];
    
    
    FFCustomerItemModel *model = _arrCustomer[indexPath.row];
    productCell.name.text = model.custName;
    productCell.phone.text = model.phone;
    if ([model.reviewStatus isEqualToString:@"HAS_RECORDED"]) {
        productCell.flag.image = Img(@"img-zskh");
    }else if ([model.reviewStatus isEqualToString:@"WAIT_AUDIT"]) {
        productCell.flag.image = Img(@"img-dspkh");
    }else if ([model.reviewStatus isEqualToString:@"HAS_AUDIT"]) {
        productCell.flag.image = Img(@"img-zskh");
    }
    CGFloat btnW = (SCREEN_WIDTH - 50) / 4;
    CGFloat btnH = 20;
    for (int i=0 ;i <model.brandNames.count;i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10 + (10 + btnW)*(i%4), 4+(4+btnH)*(i/4), btnW, btnH);
        btn.backgroundColor = RGBColor(241, 242, 245);
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.tag = i;
        [btn setTitle:model.brandNames[i] forState:UIControlStateNormal];
        [productCell.brandView addSubview:btn];
    }
    
    return productCell;
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FFCustomerItemModel *model = _arrCustomer[indexPath.row];
    if (model.brandNames.count == 0) {
        return 90;
    }else{
        if (model.brandNames.count % 4 == 0) {
            return 94+ (model.brandNames.count % 4) * 24;
        }else{
            return 94+ (model.brandNames.count % 4 + 1) * 24;
        }
    }
    return 90;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FFCustomerItemModel *model = _arrCustomer[indexPath.row];
    FFCustomerDetailVC *detailVC = [[FFCustomerDetailVC alloc] initWithNo:model.custId];
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)dataLoadCust{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FFCustomerRequest *request = [FFCustomerRequest Request];
    request.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    request.keyword = _contentTF.text;
    request.page = _currentPage;
    request.size = _pageSize;
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_customerTable.footer endRefreshing];
        
        
        if (isSuccess) {
            FFCustomerModel *model = [FFCustomerModel objectWithKeyValues:result.allDic];
            [_arrCustomer addObjectsFromArray:model.list];
            
            
            if (model.list.count == 0) {
                [_customerTable.footer endRefreshingWithNoMoreData];
            }
            if (_arrCustomer.count == result.totalRecord) {
                [_customerTable.footer endRefreshingWithNoMoreData];
                
            }
            if (_currentPage == [[result.allDic objectForKey:@"pages"] intValue]) {
                [_customerTable.footer endRefreshingWithNoMoreData];
            }
            [_customerTable reloadData];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [WToast showWithTextCenter:result.message];
        }
    }];
}
- (void)addPage{
    _currentPage++;
    [self dataLoadCust];
}

@end
