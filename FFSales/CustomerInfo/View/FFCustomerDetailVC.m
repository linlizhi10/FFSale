//
//  FFCustomerDetailVC.m
//  FFSales
//
//  Created by lin on 2018/6/21.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFCustomerDetailVC.h"
#import "FFMHomeRequest.h"
#import "FFMHomeModel.h"
@interface FFCustomerDetailVC ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSString *_custId;
}
@property (strong, nonatomic) IBOutlet UITableViewCell *firstCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *thirdCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *fourthCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *secondCell;
@property (weak, nonatomic) IBOutlet UITableView *infoTable;


@property (weak, nonatomic) IBOutlet UILabel *customerNO;
@property (weak, nonatomic) IBOutlet UILabel *customerName;
@property (weak, nonatomic) IBOutlet UILabel *belongBigAera;
@property (weak, nonatomic) IBOutlet UILabel *inAera;
@property (weak, nonatomic) IBOutlet UILabel *detailAddress;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *businessType;
@property (weak, nonatomic) IBOutlet UILabel *cutomerType;
@property (weak, nonatomic) IBOutlet UILabel *belongSales;
@property (weak, nonatomic) IBOutlet UILabel *businessLevel;
@property (weak, nonatomic) IBOutlet UILabel *saleOrganization;
@property (weak, nonatomic) IBOutlet UILabel *saleCompany;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentConstaint;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (strong, nonatomic) IBOutlet UIView *additionView;
@property (weak, nonatomic) IBOutlet UILabel *openFlag;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *company;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *phoneC;
@property (weak, nonatomic) IBOutlet UILabel *companyAdd;
@property (strong , nonatomic) FFMUserModel *model;
@property (assign, nonatomic) CGFloat viewHeightAdd;
@end

@implementation FFCustomerDetailVC
- (instancetype)initWithNo:(NSString *)custId {
    self = [super init];
    if (self) {
        _custId = custId;
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户详细信息";
    _model = [[FFMUserModel alloc] init];
    [self dataRequest];}

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
    
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFMUserModel *model = _model;
    _customerNO.text = model.base.custId;
    _customerName.text = model.base.custName;
    _belongBigAera.text = model.base.region;
    _detailAddress.text = model.base.detailedAddress;
    _inAera.text = model.base.area;
    _phone.text = model.base.phone;
    
    _businessType.text = model.identification.customerService;
    _cutomerType.text = model.identification.customerType;
    _businessLevel.text = model.identification.customerLevel;
    _saleOrganization.text = model.identification.salesOrg;
    _saleCompany.text = model.identification.salesCompany;
    
    
    _openFlag.text = model.invoice.isInvoice;
    _type.text = model.invoice.invoiceType;
    _company.text = model.invoice.invoiceCompany;
    _companyAdd.text = model.invoice.invoiceCompanyAddress;
    _number.text = model.invoice.taxpayerIdentificationNum;
    _phoneC.text = model.invoice.invoiceConpanyPhone;
    
    switch (indexPath.row) {
        case 0:
        {
            _firstCell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 212);
            return _firstCell;
        }
            break;
        case 1:
        {
            _secondCell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 184);
            return _secondCell;
        }
            break;
        case 2:
        {
            
            _thirdCell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 62);
            CGFloat labelW = (SCREEN_WIDTH - 60) /4;
            CGFloat addWidth = 0;
            
            for (int i = 0;i<model.brandAreas.count;i++) {
                FFMBrandModel *brand = model.brandAreas[i];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0 + addWidth + 30 *i, SCREEN_WIDTH - 20, 30)];
                label.textColor = [UIColor darkGrayColor];
                label.font = [UIFont systemFontOfSize:12];
                label.numberOfLines = 0;
                label.text = brand.address;
                [_additionView addSubview:label];
                for (int j = 0 ; j < brand.brandNames.count; j ++) {
                    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20+(10+labelW)*(j%4), label.bottom + 6 + (6+ 30) * (j/4), labelW, 30)];
                    label1.font = [UIFont systemFontOfSize:12];
                    label1.numberOfLines = 0;
                    label1.textAlignment = NSTextAlignmentCenter;
                    label1.layer.borderWidth = 0.5;
                    label1.layer.borderColor = [UIColor lightGrayColor].CGColor;
                    label1.text = brand.brandNames[j];
                    [_additionView addSubview:label1];
                }
                if (brand.brandNames.count %4==0) {
                    addWidth += (6 + (6+ 30) * (brand.brandNames.count/4));

                }else{
                    addWidth += (6 + (6+ 30) * (brand.brandNames.count/4 + 1));

                }
            }
            _viewHeightAdd = 30 * model.brandAreas.count + addWidth;
            return _thirdCell;
        }
            break;
        case 3:
        {
            _fourthCell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 220);
            return _fourthCell;
        }
            break;
        default:
            break;
    }
    return _firstCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    switch (indexPath.row) {
        case 0:
        {
            return 212;
        }
            break;
        case 1:
        {
            return 184;
        }
            break;
        case 2:
        {
            return 38 + _viewHeightAdd;
        }
            break;
        case 3:
        {
            return 220;
        }
            break;
        default:
            break;
    }
    return 60;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
    
}

- (void)dataRequest{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FFMPersonInfoRequest *request = [FFMPersonInfoRequest Request];
    request.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    request.custId = _custId;
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (isSuccess) {
            
            FFMUserModel *detail = [FFMUserModel objectWithKeyValues:result.allDic];
            _model = detail;
            [_infoTable reloadData];
            
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [WToast showWithTextCenter:result.message];
        }
    }];
}

@end
