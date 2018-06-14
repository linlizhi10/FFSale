//
//  FFOrderVC.m
//  FFSales
//
//  Created by lin on 2018/6/11.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFOrderVC.h"
#import "OrderCell.h"
#import "OrderInfo.h"
#import "DDOrderRequest.h"
#import "DDOrderDetailVC.h"
#import "DDTransInfoVC.h"
@interface FFOrderVC ()<UITableViewDelegate,UITableViewDataSource,StateOrderClickDelegate>
{
    int _type;
}

- (IBAction)topBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *tipView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipViewLeftMargin;
@property (weak, nonatomic) IBOutlet UITableView *orderTable;
@property (strong, nonatomic) NSMutableArray *arrMMm;
@property (assign, nonatomic) int pageSize;
@property (assign, nonatomic) int currentPage;

@end
static NSString *refreshNoti = @"refreshOrderData";
@implementation FFOrderVC
- (instancetype)initWithType:(int)type{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    _currentPage = 1;
    _pageSize = 10;
    _arrMMm = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshActionD) name:refreshNoti object:nil];
    [_orderTable registerNib:[UINib nibWithNibName:@"OrderCell" bundle:nil] forCellReuseIdentifier:@"cellO"];
    //    _orderTable.estimatedRowHeight = 44;
    _orderTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addPage)];
    [self dataLoad];

}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:refreshNoti object:nil];
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
    OrderCell *productCell = [_orderTable dequeueReusableCellWithIdentifier:@"cellO"];
    OrderInfo *orderInfo = _arrMMm[indexPath.row];
    productCell.type = _type;
    productCell.delegate = self;
    productCell.TransBtn.tag = indexPath.row;
    [productCell.TransBtn addTarget:self action:@selector(checkTran:) forControlEvents:UIControlEventTouchUpInside];
    [productCell fillCellWith:orderInfo];
    return productCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderInfo *orderInfo = _arrMMm[indexPath.row];
    BOOL audit = YES;
    if (_type == 1) {
        audit = NO;
    }
    DDOrderDetailVC *orderD = [[DDOrderDetailVC alloc] initWithNo:orderInfo.orderId audit:audit];
    [self.navigationController pushViewController:orderD animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 210;
}
- (IBAction)topBtnAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    _type = (int)btn.tag;
    _tipViewLeftMargin.constant = (SCREEN_WIDTH / 5)*(btn.tag);
    [self.view setNeedsLayout];
    [self.view updateConstraints];
    [_arrMMm removeAllObjects];
    [_orderTable reloadData];
    [self dataLoad];
}
- (void)dataLoad{
    

    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DDOrderRequest *request = [DDOrderRequest Request];
    NSString *statusS = @"";
    NSString *auditS = @"";
    switch (_type) {
        case 1:
            auditS = [NSString stringWithFormat:@"WAIT_AUDIT"];
            break;
        case 2:
            statusS = [NSString stringWithFormat:@"02,03"];
            break;
        case 3:
            statusS = [NSString stringWithFormat:@"05"];
            break;
        case 4:
            statusS = [NSString stringWithFormat:@"06,07"];
            break;
        default:
            break;
    }
    request.status = statusS;
    request.auditStatus = auditS;
    request.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    request.page = _currentPage;
    request.size = _pageSize;
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_orderTable.footer endRefreshing];
        
        
        if (isSuccess) {
            NSArray *arrList = result.allDic[@"list"];
                for (id obj in arrList) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        OrderInfo *infoO = [OrderInfo objectWithKeyValues:obj];
                        [_arrMMm addObject:infoO];
                    }
                }
                if (_arrMMm.count == result.totalRecord) {
                    [_orderTable.footer endRefreshingWithNoMoreData];
                    
                }
            
            
            [_orderTable reloadData];
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
- (void)checkTran:(UIButton *)btn{
    OrderInfo *infoO = _arrMMm[btn.tag];
    DDTransInfoVC *trans = [[DDTransInfoVC alloc] initWithNo:infoO.orderId];
    [self.navigationController pushViewController:trans animated:YES];
}
@end
