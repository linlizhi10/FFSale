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
#import "OrderEMPCell.h"
#import "DDStringUtil.h"
@interface FFOrderVC ()<UITableViewDelegate,UITableViewDataSource,StateOrderClickDelegate>
{
    int _type;
    BOOL _newOrder;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIView *typeVIew;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableConstraint;

- (IBAction)topBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *tipView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipViewLeftMargin;
@property (weak, nonatomic) IBOutlet UITableView *orderTable;
@property (strong, nonatomic) NSMutableArray *arrMMm;
@property (assign, nonatomic) int pageSize;
@property (assign, nonatomic) int currentPage;
@property (assign, nonatomic) BOOL cust;
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
- (instancetype)initWithNew:(BOOL)newOrder{
    self = [super init];
    if (self) {
        _newOrder = newOrder;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    if (_newOrder) {
        self.title = @"今日订单";
        _tableConstraint.constant = -40;
        _typeVIew.hidden = YES;
    }
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"sourceChannel"]isEqualToString:@"EMP"]) {
        _topConstraint.constant = 0;
        _tipView.backgroundColor = RGBCOLORV(0x4BAE4F);
        _cust = YES;
    }
    _currentPage = 1;
    _pageSize = 10;
    _arrMMm = [[NSMutableArray alloc] init];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshActionD) name:refreshNoti object:nil];
    [_orderTable registerNib:[UINib nibWithNibName:@"OrderCell" bundle:nil] forCellReuseIdentifier:@"cellO"];
    [_orderTable registerNib:[UINib nibWithNibName:@"OrderEMPCell" bundle:nil] forCellReuseIdentifier:@"cellEMP"];

    //    _orderTable.estimatedRowHeight = 44;
    _orderTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addPage)];
    
    [self dataLoad];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _tipViewLeftMargin.constant = (SCREEN_WIDTH / 5)*(_type);
    [self.view setNeedsLayout];
    [self.view updateConstraints];
}
- (void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:refreshNoti object:nil];
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
    if (_cust) {
        OrderEMPCell *productCell = [_orderTable dequeueReusableCellWithIdentifier:@"cellEMP"];
        OrderInfo *orInfo = _arrMMm[indexPath.row];
        productCell.custName.text = [NSString stringWithFormat:@"%@",orInfo.custName];
        productCell.sapNp.text = [NSString stringWithFormat:@"SAP编号:%@",orInfo.sapCode];
        productCell.createDate.text = [NSString stringWithFormat:@"创建时间:%@",[DDStringUtil toDateTimeString:orInfo.createTime]];
        productCell.pay.text = [NSString stringWithFormat:@"实付款:￥%.2f",orInfo.payAmout];
        productCell.btn.tag = indexPath.row;
        [productCell.btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        if ([orInfo.auditStatus isEqualToString:@"WAIT_AUDIT"] ) {
            productCell.state.text = @"等待后台管理员审核";
            productCell.state.textColor = [UIColor darkGrayColor];
            [productCell.btn setTitle:@"待审核" forState:UIControlStateNormal];

        }else{
            
            if ([orInfo.status isEqualToString:@"02"] || [orInfo.status isEqualToString:@"03"] ) {
                productCell.state.text = [NSString stringWithFormat:@"已发货%.2f/%.2f",orInfo.sendQty,orInfo.qty];
                productCell.state.textColor = [UIColor darkGrayColor];
                [productCell.btn setTitle:@"待发货" forState:UIControlStateNormal];
            }else if([orInfo.status isEqualToString:@"05"] ){
                productCell.state.text = @"货物已全部发完";
                productCell.state.textColor = [UIColor darkGrayColor];
                [productCell.btn setTitle:@"已完成" forState:UIControlStateNormal];

            }else if([orInfo.status isEqualToString:@"06"] || [orInfo.status isEqualToString:@"07"] ){
                productCell.state.text = @"订单已关闭";
                productCell.state.textColor = [UIColor darkGrayColor];
                [productCell.btn setTitle:@"已关闭" forState:UIControlStateNormal];

            }
        }
        return productCell;
    }else{
        OrderCell *productCell = [_orderTable dequeueReusableCellWithIdentifier:@"cellO"];
        OrderInfo *orderInfo = _arrMMm[indexPath.row];
        productCell.type = _type;
        productCell.delegate = self;
        productCell.TransBtn.tag = indexPath.row;
        [productCell.TransBtn addTarget:self action:@selector(checkTran:) forControlEvents:UIControlEventTouchUpInside];
        [productCell fillCellWith:orderInfo];
            return productCell;
        
    }
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
    if (_cust) {
        return 167;
    }
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
    
    if (_newOrder) {
        request.OrderNew = @"true";
    }else{
        request.status = statusS;
        request.auditStatus = auditS;
    }
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
            [MBProgressHUD hideHUDForView:self.view animated:YES];
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
- (void)buttonClick:(UIButton *)btn{
    OrderInfo *orderInfo = _arrMMm[btn.tag];
    BOOL audit = YES;
    if (_type == 1) {
        audit = NO;
    }
    DDOrderDetailVC *orderD = [[DDOrderDetailVC alloc] initWithNo:orderInfo.orderId audit:audit];
    [self.navigationController pushViewController:orderD animated:YES];
}
@end
