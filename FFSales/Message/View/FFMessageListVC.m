//
//  FFMessageListVC.m
//  FFSales
//
//  Created by lin on 2018/6/21.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFMessageListVC.h"
#import "FFMessageReqeust.h"
#import "MessageModel.h"
#import "MessageCell.h"
#import "DDStringUtil.h"
#import "MessageOtherCell.h"
#import "MessageOrderCell.h"
#import "DDOrderDetailVC.h"
#import "FFUseMoney.h"
#import "FFOtherMoneyVC.h"
@interface FFMessageListVC (){
    NSString *_type;
}
@property (weak, nonatomic) IBOutlet UITableView *messageTalbe;
@property (strong, nonatomic) NSMutableArray *arrMeesage;

@property (assign, nonatomic) int pageSize;
@property (assign, nonatomic) int currentPage;
@end

@implementation FFMessageListVC
- (instancetype)initWithNo:(NSString * )type {
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([_type isEqualToString:@"FUND"]) {
        self.title = @"资金消息";
        _messageTalbe.estimatedRowHeight = 126;
    }else if ([_type isEqualToString:@"ORDER"]){
        self.title = @"订单消息";
        _messageTalbe.estimatedRowHeight = 165;

    }
    
    _arrMeesage = [[NSMutableArray alloc] init];
    _currentPage = 1;
    _pageSize = 10;
    [_messageTalbe registerNib:[UINib nibWithNibName:@"MessageOtherCell" bundle:nil] forCellReuseIdentifier:@"cellMessOther"];
    [_messageTalbe registerNib:[UINib nibWithNibName:@"MessageOrderCell" bundle:nil] forCellReuseIdentifier:@"cellMessOrder"];
    
    _messageTalbe.estimatedSectionFooterHeight = 1;
    _messageTalbe.estimatedSectionHeaderHeight = 1;
    _messageTalbe.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addPage)];
    [self dataLoadCust];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _arrMeesage.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageItemModel *itemModel = _arrMeesage[indexPath.row];
    if ([_type isEqualToString:@"FUND"]) {
        MessageOtherCell *productCell = [tableView dequeueReusableCellWithIdentifier:@"cellMessOther"];
        productCell.titleContent.text = itemModel.message;
        productCell.time.text = [DDStringUtil toDateTimeString:itemModel.createTime];
        return productCell;

    }else if ([_type isEqualToString:@"ORDER"]){
        MessageOrderCell *productCell = [tableView dequeueReusableCellWithIdentifier:@"cellMessOrder"];
        productCell.message.text = itemModel.message;
        productCell.time.text = [DDStringUtil toDateTimeString:itemModel.createTime];
//        productCell.name.text = [NSString stringWithFormat:@"商品名称:%@",itemModel.message];
        productCell.totalCount.text = [NSString stringWithFormat:@"总吨数:%.2f吨",itemModel.extra.qty];
        productCell.payAmount.text = [NSString stringWithFormat:@"结算金额:￥%.2f",itemModel.extra.payAmount];
        return productCell;
    }
    
    
    return nil;
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageItemModel *itemModel = _arrMeesage[indexPath.row];

    if ([_type isEqualToString:@"FUND"]) {
        if ([itemModel.messageType isEqualToString:@"FUND_CASH_ADD" ]) {
            FFUseMoney *useVC = [[FFUseMoney alloc] initWithNo:itemModel.custNo];
            [self.navigationController pushViewController:useVC animated:YES];
        }else if ([itemModel.messageType isEqualToString:@"FUND_DEPOSIT_ADD" ]){
            FFOtherMoneyVC *useVC = [[FFOtherMoneyVC alloc] initWithNo:itemModel.custNo];
            [self.navigationController pushViewController:useVC animated:YES];
            
        }
        
    }else if ([_type isEqualToString:@"ORDER"]){
        DDOrderDetailVC *orderDetialVC = [[DDOrderDetailVC alloc] initWithNo:itemModel.linkedId audit:YES];
        [self.navigationController pushViewController:orderDetialVC animated:YES];
        
    }
}
- (void)dataLoadCust{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FFMessageReqeust *request = [FFMessageReqeust Request];
    request.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    request.type = _type;
    request.page = _currentPage;
    request.size = _pageSize;
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_messageTalbe.footer endRefreshing];
        
        
        if (isSuccess) {
            MessageModel *model = [MessageModel objectWithKeyValues:result.allDic];
            [_arrMeesage addObjectsFromArray:model.list];
            
            
            if (model.list.count == 0) {
                [_messageTalbe.footer endRefreshingWithNoMoreData];
            }
            if (_arrMeesage.count == result.totalRecord) {
                [_messageTalbe.footer endRefreshingWithNoMoreData];
                
            }
            if (_currentPage == [[result.allDic objectForKey:@"pages"] intValue]) {
                [_messageTalbe.footer endRefreshingWithNoMoreData];
            }
            [_messageTalbe reloadData];
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
