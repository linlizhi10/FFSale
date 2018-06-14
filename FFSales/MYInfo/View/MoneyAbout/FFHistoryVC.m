//
//  FFHistoryVC.m
//  FFSales
//
//  Created by lin on 2018/6/12.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFHistoryVC.h"
#import "MoneyHistoryCell.h"
#import "FFMoneyRequest.h"
#import "DDStringUtil.h"
#import "MoneyModel.h"
@interface FFHistoryVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *_childrenAccountType;
}
@property (weak, nonatomic) IBOutlet UITableView *historyTable;
@property (assign, nonatomic) int pageSize;
@property (assign, nonatomic) int currentPage;
@property (strong, nonatomic) NSMutableArray *arrMMm;

@end

@implementation FFHistoryVC
- (instancetype)initWithNo:(NSString *)type {
    self = [super init];
    if (self) {
        _childrenAccountType = type;
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史记录";
    _arrMMm = [[NSMutableArray alloc] init];
    _currentPage = 1;
    _pageSize = 10;
    
    
    [_historyTable registerNib:[UINib nibWithNibName:@"MoneyHistoryCell" bundle:nil] forCellReuseIdentifier:@"cellHis"];
    
    //    _orderTable.estimatedRowHeight = 44;
    _historyTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addPage)];
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
    
    MoneyHistoryCell *productCell = [tableView dequeueReusableCellWithIdentifier:@"cellHis"];
    SubHistoryModel *model = _arrMMm[indexPath.row];
    productCell.historyTitle.text = [NSString stringWithFormat:@"%@ 金额:%.2f",[DDStringUtil toSimpleDateString:model.opTime],model.amt];
    NSString *operation = @"";
    NSString *stausS = @"";

    if (model.status == 0) {
        operation = @"打款";
        stausS = @"未使用";
    }else if (model.status == 1) {
        operation = @"锁定";
        stausS = @"已锁定";
        productCell.flag.backgroundColor = RGBCOLORV(0xFBCACA);
        productCell.flag.textColor = RGBCOLORV(0xF23030);
    }else if (model.status == 2) {
        operation = @"使用";
        stausS = @"已使用";
        productCell.flag.backgroundColor = RGBCOLORV(0xE0E0E0);
        productCell.flag.textColor = RGBCOLORV(0x666666);

    }
    productCell.time.text = [NSString stringWithFormat:@"%@时间:%@",operation,[DDStringUtil toDateTimeString:model.opTime]];
    productCell.flag.text = stausS;
    
    return productCell;

    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 64;
}
- (void)dataLoad{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        FFHistoryRequest *request = [FFHistoryRequest Request];
        request.page = _currentPage;
        request.size = _pageSize;
    request.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    request.serviceType = @"01";
    request.childrenAccountType = _childrenAccountType;
//    request.childrenAccountType = @"06";
    
//    request.custId = @"CUST01174";
        [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [_historyTable.footer endRefreshing];
    
            if (isSuccess) {
                HistoryModel *model = [HistoryModel objectWithKeyValues:result.allDic];
                [_arrMMm addObjectsFromArray:model.list];
                
                
                if (model.list.count == 0) {
                    [_historyTable.footer endRefreshingWithNoMoreData];
                }
                if (_arrMMm.count == result.totalRecord) {
                    [_historyTable.footer endRefreshingWithNoMoreData];
                    
                }
                if (_currentPage == [[result.allDic objectForKey:@"pages"] intValue]) {
                    [_historyTable.footer endRefreshingWithNoMoreData];
                }
                [_historyTable reloadData];
    
    
            }else{
                //                [MBProgressHUD showError:result.message toView:self.view];
                [WToast showWithTextCenter:result.message];
            }
        }];
}
- (void)addPage{
    _currentPage++;
    [self dataLoad];
}
@end
