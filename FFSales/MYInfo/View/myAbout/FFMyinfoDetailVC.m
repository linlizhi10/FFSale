//
//  FFMyinfoDetailVC.m
//  FFSales
//
//  Created by lin on 2018/6/19.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFMyinfoDetailVC.h"
#import "FFMHomeRequest.h"
#import "FFMHomeModel.h"
@interface FFMyinfoDetailVC (){
    
    NSString *_custId;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScroll;
@property (strong, nonatomic) IBOutlet UIView *contentView;
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
@property (strong, nonatomic) IBOutlet UIView *contentViewTT;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@end

@implementation FFMyinfoDetailVC
- (instancetype)initWithNo:(NSString *)custId {
    self = [super init];
    if (self) {
        _custId = custId;
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    
    [self dataRequest];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            [self fillContent:detail];
            
            
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [WToast showWithTextCenter:result.message];
        }
    }];
}
- (void)fillContent:(FFMUserModel *)model{
    
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
    CGFloat labelW = (_contentViewTT.width - 60) /4;
    CGFloat addWidth = 0;
    _contentViewTT.frame = CGRectMake(0, 0, SCREEN_WIDTH, 737);
    [_contentScroll addSubview:_contentViewTT];
    for (int i = 0;i<model.brandAreas.count;i++) {
        FFMBrandModel *brand = model.brandAreas[i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, _brandLabel.bottom + 40 + 10 + addWidth + 30 *i, _contentViewTT.width - 40, 30)];
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:12];
        label.numberOfLines = 0;
        label.text = brand.address;
        [_contentViewTT addSubview:label];
        for (int j = 0 ; j < brand.brandNames.count; j ++) {
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20+(10+labelW)*(j%4), label.bottom + 6 + (6+ 30) * (j/4), labelW, 30)];
            label1.font = [UIFont systemFontOfSize:12];
            label1.numberOfLines = 0;
            label1.textAlignment = NSTextAlignmentCenter;
            label1.layer.borderWidth = 0.5;
            label1.layer.borderColor = [UIColor lightGrayColor].CGColor;
            label1.text = brand.brandNames[j];
            [_contentViewTT addSubview:label1];
        }
        if (brand.brandNames.count %4==0) {
            addWidth += (6 + (6+ 30) * (brand.brandNames.count/4));
            
        }else{
            addWidth += (6 + (6+ 30) * (brand.brandNames.count/4 + 1));
            
        }
       
    }
    _contentViewTT.frame = CGRectMake(0, 0, SCREEN_WIDTH, 737 + model.brandAreas.count * 30 + addWidth +40);
    _topConstraint.constant = 50 + model.brandAreas.count * 30 + addWidth;
    [_contentScroll setContentSize:CGSizeMake(SCREEN_WIDTH, _contentViewTT.bottom)];
    
    
    _openFlag.text = model.invoice.isInvoice;
    _type.text = model.invoice.invoiceType;
    _company.text = model.invoice.invoiceCompany;
    _companyAdd.text = model.invoice.invoiceCompanyAddress;
    _number.text = model.invoice.taxpayerIdentificationNum;
    _phoneC.text = model.invoice.invoiceConpanyPhone;
    
 

}


@end
