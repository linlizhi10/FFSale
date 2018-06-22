//
//  FFMoneyListVC.m
//  FFSales
//
//  Created by lin on 2018/6/14.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFMoneyListVC.h"
#import "MoneyListCell.h"
#import "MoneyModel.h"
#import "FFMoneyRequest.h"
#import "DDStringUtil.h"
@interface FFMoneyListVC ()<UITableViewDelegate,UITableViewDataSource>{
    int _index;
}
@property (weak, nonatomic) IBOutlet UITableView *listTable;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
- (IBAction)typeAction:(id)sender;
@property (strong, nonatomic) NSMutableArray *arrMMm;
@property (assign, nonatomic) int pageSize;
@property (assign, nonatomic) int currentPage;
@property (strong, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScroll;
@property (copy, nonatomic) NSString *fundType;
@property (assign, nonatomic) BOOL show;
@end

@implementation FFMoneyListVC
- (instancetype)initWithType:(int )index {
    self = [super init];
    if (self) {
        _index = index;
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"返利";
    _currentPage = 1;
    _pageSize = 10;
    [_listTable registerNib:[UINib nibWithNibName:@"MoneyListCell" bundle:nil] forCellReuseIdentifier:@"cellMoney"];
    _arrMMm = [[NSMutableArray alloc] init];
    NSMutableArray *arrB = [NSMutableArray arrayWithObjects:@"所有",@"现金",@"保证金",@"定金",@"大承兑",@"小承兑",@"临时授信",@"垫底",@"理财",@"政策返利",@"其他返利", nil];
    CGFloat btnW = (SCREEN_WIDTH - 40) / 3;
    CGFloat btnH = 33;

    for (int i = 0; i<arrB.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10 + (10 + btnW)*(i%3), 4+(4+btnH)*(i/3), btnW, btnH);
        btn.backgroundColor = RGBCOLORV(0xF2F2F2);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:RGBCOLORV(0x333333) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.tag = i;
        [btn setTitle:arrB[i] forState:UIControlStateNormal];
        [btn addTarget:self
                action:@selector(orderClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == _index) {
            btn.backgroundColor = [UIColor redColor];
            btn.selected = YES;
            if (i > 0) {
                _fundType = [NSString stringWithFormat:@"0%d",_index];

            }
            [_typeBtn setTitle:btn.currentTitle forState:UIControlStateNormal];
        }
        
        
        [_contentScroll addSubview:btn];
    }
    _coverView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-300);
    
    _listTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addPage)];
    [self dataLoad];}

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
    
    MoneyListCell *productCell = [tableView dequeueReusableCellWithIdentifier:@"cellMoney"];
    ListSubModel *model = _arrMMm[indexPath.row];
    NSString *operation = @"";
    if ([model.fundType isEqualToString:@"01"]) {
        operation = @"现金";
    }else if ([model.fundType isEqualToString:@"02"]) {
        operation = @"保证金";
        
    }else if ([model.fundType isEqualToString:@"03"]) {
        operation = @"定金";
        
    }else if ([model.fundType isEqualToString:@"04"]) {
        operation = @"大承兑";
        
    }else if ([model.fundType isEqualToString:@"05"]) {
        operation = @"小承兑";
        
    }else if ([model.fundType isEqualToString:@"06"]) {
        operation = @"临时授信";
        
    }else if ([model.fundType isEqualToString:@"07"]) {
        operation = @"垫底";
        
    }else if ([model.fundType isEqualToString:@"08"]) {
        operation = @"理财";
    }
    else if ([model.fundType isEqualToString:@"09"]) {
        operation = @"政策返利";
        
    }else if ([model.fundType isEqualToString:@"10"]) {
        operation = @"其他返利";
        
    }
    productCell.type.text = operation;
    productCell.time.text = [DDStringUtil toDateTimeString:model.inputDate];
    if (model.addAmt > 0.00) {
        productCell.monet.text = [NSString stringWithFormat:@"+￥%.2f",model.addAmt];

    }else{
        productCell.monet.text = [NSString stringWithFormat:@"-￥%.2f",model.plusAmt];

    }
    
    return productCell;
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (void)dataLoad{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FFListRequest *request = [FFListRequest Request];
    request.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    request.page = _currentPage;
    request.size = _pageSize;
    request.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    request.fundType = _fundType;
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_listTable.footer endRefreshing];
        
        if (isSuccess) {
            ListModel *model = [ListModel objectWithKeyValues:result.allDic];
            [_arrMMm addObjectsFromArray:model.list];
            
            
            if (model.list.count == 0) {
                [_listTable.footer endRefreshingWithNoMoreData];
            }
            if (_arrMMm.count == result.totalRecord) {
                [_listTable.footer endRefreshingWithNoMoreData];
                
            }
            if (_currentPage == [[result.allDic objectForKey:@"pages"] intValue]) {
                [_listTable.footer endRefreshingWithNoMoreData];
            }
            [_listTable reloadData];
            
            
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [WToast showWithTextCenter:result.message];
        }
    }];
}
- (IBAction)typeAction:(id)sender {
    _show = !_show;
    if (_show) {
        _coverView.frame = CGRectMake(0, _typeBtn.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-_typeBtn.bottom);
        [self.view addSubview:_coverView];
    }else{
        [_coverView removeFromSuperview];
    }
    
}
- (void)addPage{
    _currentPage++;
    [self dataLoad];
}

- (void)orderClick:(UIButton *)btn{
    
    for (UIView *obj in _contentScroll.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btnT = (UIButton *)obj;
            btnT.backgroundColor = RGBCOLORV(0xF2F2F2);
            btnT.selected = NO;
        }
        
    }
    btn.backgroundColor =[UIColor redColor];
    btn.selected = YES;
    [_typeBtn setTitle:btn.currentTitle forState:UIControlStateNormal];
    if (btn.tag > 0 && btn.tag <10) {
        _fundType = [NSString stringWithFormat:@"0%d",(int)btn.tag];
    }else if (btn.tag == 0){
        _fundType = @"";
    }else{
        _fundType = [NSString stringWithFormat:@"%d",(int)btn.tag];

    }
    [_coverView removeFromSuperview];

    [_arrMMm removeAllObjects];
    [_listTable reloadData];
    [self dataLoad];
}
@end
