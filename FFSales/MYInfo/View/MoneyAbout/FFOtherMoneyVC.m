//
//  FFOtherMoneyVC.m
//  FFSales
//
//  Created by lin on 2018/6/14.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFOtherMoneyVC.h"
#import "OtherMoneyCell.h"
#import "MoneyModel.h"
#import "FFMoneyRequest.h"
@interface FFOtherMoneyVC (){
    
    NSString *_custId;
}
@property (weak, nonatomic) IBOutlet UIButton *cashBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (assign, nonatomic)  int moneyType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipViewLeftMargin;
@property (strong, nonatomic) NSMutableArray *arrMMm;
@property (strong, nonatomic) NSMutableArray *arrN;

@property (assign, nonatomic) int pageSize;
@property (assign, nonatomic) int currentPage;

@property (weak, nonatomic) IBOutlet UITableView *cashTable;
@property (weak, nonatomic) IBOutlet UIView *creaditView;
@property (weak, nonatomic) IBOutlet UIView *cashView;
//@property (strong, nonatomic) moneyTypeModel *money;
- (IBAction)typeClick:(id)sender;
@end

@implementation FFOtherMoneyVC
- (instancetype)initWithNo:(NSString *)custId {
    self = [super init];
    if (self) {
        _custId = custId;
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"其他资金";
    _arrMMm = [[NSMutableArray alloc] init];
    _arrN = [[NSMutableArray alloc] init];
    _cashBtn.selected = YES;

    _currentPage = 1;
    _pageSize = 10;
    
    
    [_cashTable registerNib:[UINib nibWithNibName:@"OtherMoneyCell" bundle:nil] forCellReuseIdentifier:@"cellOth"];
    
    //    _orderTable.estimatedRowHeight = 44;
//    _cashTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addPage)];
    [self dataLoad];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _tipViewLeftMargin.constant = (SCREEN_WIDTH / 2 - 40)/2;
    
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
    if (_moneyType == 0) {
        return _arrMMm.count;
    }
    return _arrN.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OtherMoneyCell *productCell = [tableView dequeueReusableCellWithIdentifier:@"cellOth"];
    OtherMoneySmallModel *model = _arrMMm[indexPath.row];
    NSString *type= @"";
    if (_moneyType == 0) {
        type = @"保证金";
    }else{
        type = @"定金";
    }
    productCell.message.attributedText = [self originalContent:type differentContent:[NSString stringWithFormat:@"￥%.2f",model.accountBalance]];
//
//    productCell.time.text = [NSString stringWithFormat:@"%@时间:%@",operation,[DDStringUtil toDateTimeString:model.opTime]];
//    productCell.flag.text = stausS;
    
    return productCell;
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
        return 40;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        [but setTitle:@"如何退换保证金/定金？" forState:UIControlStateNormal];
        [but setTitleColor:RGBCOLORV(0x2395FF) forState:UIControlStateNormal];
        but.frame = CGRectMake(0, 0, SCREEN_WIDTH -20, 40);
        but.titleLabel.font = [UIFont systemFontOfSize:14];
        but.backgroundColor = [UIColor whiteColor];
        [but addTarget:self action:@selector(checkAllAction) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:but];;
        return view;
}
- (IBAction)typeClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    _moneyType = (int)btn.tag;
    if (_moneyType == 0) {
        _cashBtn.selected = YES;
        _checkBtn.selected = NO;
    }else{
        _cashBtn.selected = NO;
        _checkBtn.selected = YES;
    }
    btn.backgroundColor = [UIColor whiteColor];

    _tipViewLeftMargin.constant = (SCREEN_WIDTH / 2 - 40)/2 + (SCREEN_WIDTH / 2)*(btn.tag);
    [self.view setNeedsLayout];
    [self.view updateConstraints];
}
- (void)dataLoad{
    
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        FFOtherMoneyCRequest *request = [FFOtherMoneyCRequest Request];
        request.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
        [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
            if (isSuccess) {
                OtherMoney *model = [OtherMoney objectWithKeyValues:result.allDic];
                for (OtherMoneyTypeModel *type in model.list) {
                    if ([type.childrenAccountType isEqualToString:@"02"]) {//保证金
                        for (OtherMoneySmallModel *small in type.accountInfos) {
                            if ([small.serviceType isEqualToString:@"01"]) {//复肥
                                [_arrMMm addObject:small];
                            }
                        }
                        
                        
                    }else if ([type.childrenAccountType isEqualToString:@"03"]){
                        for (OtherMoneySmallModel *small in type.accountInfos) {//定金
                            if ([small.serviceType isEqualToString:@"01"]) {//复肥
                                [_arrN addObject:small];
                            }
                        }
                    }
                }
                [_cashTable reloadData];

            }else{
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                [WToast showWithTextCenter:result.message];
            }
        }];
    }
    
    
    
- (NSAttributedString *)originalContent:(NSString *)str1 differentContent:(NSString *)str2{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",str1?:@""] attributes:@{NSForegroundColorAttributeName:RGBCOLORV(0x999999),NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    NSAttributedString *strT = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",str2?:@""] attributes:@{NSForegroundColorAttributeName:RGBCOLORV(0x333333),NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [str appendAttributedString:strT];
    return str;
}
- (void)checkAllAction{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请联系你所在区域的业务员申请保证金/定金退款事宜" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    [alert show];
}
@end
