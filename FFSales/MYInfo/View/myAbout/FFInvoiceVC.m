//
//  FFInvoiceVC.m
//  FFSales
//
//  Created by lin on 2018/6/19.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFInvoiceVC.h"
#import "FFMHomeRequest.h"
#import "FFMHomeModel.h"
@interface FFInvoiceVC ()
{
    
    NSString *_custId;
}
@property (weak, nonatomic) IBOutlet UILabel *typeO;
@property (weak, nonatomic) IBOutlet UILabel *header;
@property (weak, nonatomic) IBOutlet UILabel *numberO;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *bankName;

@property (weak, nonatomic) IBOutlet UILabel *account;

@end

@implementation FFInvoiceVC
- (instancetype)initWithNo:(NSString *)custId {
    self = [super init];
    if (self) {
        _custId = custId;
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发票信息";
    [self dataRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dataRequest{
    WS(ws);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FFInvoiceRequest *request = [FFInvoiceRequest Request];
    request.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (isSuccess) {
            
            FFMInvoiceModel *detail = [FFMInvoiceModel objectWithKeyValues:result.allDic];
            [ws fillContent:detail];
            
            
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [WToast showWithTextCenter:result.message];
        }
    }];
}
- (void)fillContent:(FFMInvoiceModel *)detail{
    _typeO.text = detail.invoiceType;
    _header.text = detail.invoiceCompany;
    _numberO.text = detail.taxpayerIdentificationNum;
    _address.text = detail.invoiceCompanyAddress;
    _phone.text = detail.invoiceConpanyPhone;
    _bankName.text = detail.bank;
    _account.text = detail.account;
}
@end
