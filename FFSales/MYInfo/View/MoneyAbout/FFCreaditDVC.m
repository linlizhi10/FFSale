//
//  FFCreaditDVC.m
//  FFSales
//
//  Created by lin on 2018/6/14.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFCreaditDVC.h"
#import "FFMoneyRequest.h"
#import "MoneyModel.h"
#import "DDStringUtil.h"
@interface FFCreaditDVC ()
{
    NSString *_accountId;
}
@property (weak, nonatomic) IBOutlet UIScrollView *contentScroll;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *moneyType;
@property (weak, nonatomic) IBOutlet UILabel *creaditAmount;
@property (weak, nonatomic) IBOutlet UILabel *useageAmout;
@property (weak, nonatomic) IBOutlet UILabel *waitReturn;
@property (weak, nonatomic) IBOutlet UILabel *alreadyReturn;
@property (weak, nonatomic) IBOutlet UILabel *startDate;
@property (weak, nonatomic) IBOutlet UILabel *endDate;
@property (weak, nonatomic) IBOutlet UILabel *returnDate;
@property (weak, nonatomic) IBOutlet UILabel *ratio;
@property (weak, nonatomic) IBOutlet UILabel *funacialNo;
@property (weak, nonatomic) IBOutlet UILabel *createDate;
@property (weak, nonatomic) IBOutlet UILabel *cutomerName;
@property (weak, nonatomic) IBOutlet UILabel *saleCompany;
@property (weak, nonatomic) IBOutlet UILabel *businiessType;

@end

@implementation FFCreaditDVC
- (instancetype)initWithNo:(NSString *)accountId {
    self = [super init];
    if (self) {
        _accountId = accountId;
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"授信详细";
    _contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 500);
    [_contentScroll addSubview:_contentView];
    [_contentScroll setContentSize:CGSizeMake(SCREEN_WIDTH, 500)];
    [self dataLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dataLoad{
    WS(ws);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FFCreaditDRequest *request = [FFCreaditDRequest Request];
    request.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    request.accountId = _accountId;
    
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        if (isSuccess) {
            CreaditDetailModel *model = [CreaditDetailModel objectWithKeyValues:result.allDic];
            
            [ws fillContent:model];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [WToast showWithTextCenter:result.message];
        }
    }];
}
- (void)fillContent:(CreaditDetailModel *)model{
    NSString *type = @"";
    if ([model.childrenAccountType isEqualToString:@"07"]) {
        type = @"垫底";
    }else if ([model.childrenAccountType isEqualToString:@"08"]) {
        type = @"理财授信";
    }else if ([model.childrenAccountType isEqualToString:@"06"]) {
        type = @"临时授信";
    }
    _moneyType.text = type;
    _useageAmout.text = [NSString stringWithFormat:@"￥%.2f",model.availableBalance];
    _alreadyReturn.text = [NSString stringWithFormat:@"￥%.2f",model.alreadyRepayment];
    _waitReturn.text = [NSString stringWithFormat:@"￥%.2f",model.needPayment];
    _creaditAmount.text = [NSString stringWithFormat:@"￥%.2f",model.approvedAmount];
    _creaditAmount.text = [NSString stringWithFormat:@"￥%.2f",model.approvedAmount];
    _startDate.text = [DDStringUtil toDateTimeString:model.beginDate];
    _endDate.text = [DDStringUtil toDateTimeString:model.endDate];
    _returnDate.text = [DDStringUtil toDateTimeString:model.repayDate];
    _ratio.text = [NSString stringWithFormat:@"%.2f%%",model.rate*100];
    _returnDate.text = [DDStringUtil toDateString:model.repayDate];
    _createDate.text = [DDStringUtil toDateTimeString:model.inputDate];
    _cutomerName.text = model.custName;
    _saleCompany.text = model.saleCompany;
    _funacialNo.text = model.accountId;
    NSString *tempStr =@"";
    if ([model.serviceType isEqualToString:@"01"]) {
        tempStr = @"复肥";
    }else if ([model.serviceType isEqualToString:@"02"]) {
        tempStr = @"盐";
    }else if ([model.serviceType isEqualToString:@"03"]) {
        tempStr = @"酒";
    }else if ([model.serviceType isEqualToString:@"04"]) {
        tempStr = @"联碱";
    }
    _businiessType.text = model.serviceType;
}

@end
