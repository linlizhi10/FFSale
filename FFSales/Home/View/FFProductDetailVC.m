//
//  FFProductDetailVC.m
//  FFSales
//
//  Created by lin on 2018/6/4.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFProductDetailVC.h"
#import "FFProductDetailRequest.h"
#import "FFProductModel.h"
#import "SDCycleScrollView.h"
#import "FFFactoryACell.h"
@interface FFProductDetailVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *_meterailId;
}
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *coverTitle;
@property (weak, nonatomic) IBOutlet UILabel *coverUnitPrice;
@property (weak, nonatomic) IBOutlet UILabel *coverInventory;

- (IBAction)factoryA:(id)sender;
- (IBAction)closeAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UITableView *factoryTable;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *unitPRICE;

@property (weak, nonatomic) IBOutlet UILabel *inventory;
@property (weak, nonatomic) IBOutlet UILabel *factoryName;
@property (weak, nonatomic) IBOutlet UILabel *brand;
@property (weak, nonatomic) IBOutlet UILabel *color;
@property (weak, nonatomic) IBOutlet UILabel *mixValue;
@property (weak, nonatomic) IBOutlet UILabel *strain;
@property (weak, nonatomic) IBOutlet UILabel *consentration;
@property (weak, nonatomic) IBOutlet UILabel *pureAmount;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScroll;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *headImageView;
@property (strong, nonatomic) NSMutableArray *arrMessage;

@property (strong, nonatomic) IBOutlet UIView *navView;
- (IBAction)priductAction:(id)sender;
- (IBAction)detailAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIButton *productBtn;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

- (IBAction)backAction:(id)sender;


@end

@implementation FFProductDetailVC
- (instancetype)initWithId:(NSString *)meterailId {
    self = [super init];
    if (self) {
        _meterailId = meterailId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    [_productBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    _coverView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH + 280);
    [_contentScroll addSubview:_headerView];
    _headImageView.backgroundColor = [UIColor whiteColor];
    _headImageView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _headImageView.pageDotColor = [UIColor redColor];
    _headImageView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
    
    _arrMessage = [[NSMutableArray alloc] init];

    [_factoryTable registerNib:[UINib nibWithNibName:@"FFFactoryACell" bundle:nil] forCellReuseIdentifier:@"cellF"];
    _contentScroll.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH + 280);
    [self detailRequest];
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    self.navView.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    if (kDevice_Is_iPhoneX) {
        self.navView.frame = CGRectMake(0, 44, SCREEN_WIDTH, 44);
        _topConstraint.constant = 88;
    }
    [self.view addSubview:self.navView];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    
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
    
    return _arrMessage.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FFFactoryACell *productCell = [tableView dequeueReusableCellWithIdentifier:@"cellF"];
    //    productCell.delegate = self;
    FFProductFactoryModel *infom = _arrMessage[indexPath.row];
    productCell.factoryName.text = infom.factoryName;
    return productCell;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FFProductFactoryModel *info = _arrMessage[indexPath.row];
    _coverInventory.text = [NSString stringWithFormat:@"库存:%@",info.saleTun];
    _coverUnitPrice.attributedText = [self originalContent:info.price differentContent:@"/吨"];
    _factoryName.text = info.factoryName;
    _inventory.text = [NSString stringWithFormat:@"库存:%@",info.saleTun];

    [_coverView removeFromSuperview];
}

- (void)fillContent:(FFProductDetailModel *)detail{
//    _headImageView.backgroundColor = [UIColor redColor];
    if (detail.picUrls && detail.picUrls.count > 0) {
        NSArray *imagesURLStrings = detail.picUrls;
        _headImageView.imageURLStringsGroup = imagesURLStrings;
    }
    if (detail.picUrls.count > 0) {
        [_coverImage sd_setImageWithURL:[NSURL URLWithString:detail.picUrls.firstObject?:@""] placeholderImage:[UIImage imageNamed:@"goodDefault"]];

    }
    
    _productName.text = detail.name;
    _coverTitle.text = detail.name;
    
    _unitPRICE.attributedText = [self originalContent:detail.price differentContent:@"/吨"];
    _coverUnitPrice.attributedText = _unitPRICE.attributedText;
    
    FFProductPropertiesModel *property = detail.properties;
    _brand.attributedText = [self originalContentNext:@"品牌:" differentContent:property.brandName];
    _color.attributedText = [self originalContentNext:@"颜色:" differentContent:property.color];
    _mixValue.attributedText = [self originalContentNext:@"配比:" differentContent:property.proportion];
    _consentration.attributedText = [self originalContentNext:@"养分:" differentContent:property.nutrient];
    _pureAmount.attributedText = [self originalContentNext:@"规格:" differentContent:property.spec];
    _strain.attributedText = [self originalContentNext:@"品系:" differentContent:detail.strain];
    _factoryName.text = detail.factory;
    _inventory.text = [NSString stringWithFormat:@"库存:%@",detail.saleTun];

    __block CGFloat heightTemp = _headerView.frame.size.height;
    
    //test
//    detail.detailUrls = [NSArray arrayWithObjects:@"http://uatimage.dusto.cn/uat/804029/ce863827693249d1bcc8a28a49f1efc4.jpg",@"http://uatimage.dusto.cn/uat/804029/ce863827693249d1bcc8a28a49f1efc4.jpg", nil];
    [_contentScroll setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH + 288 + 200 *detail.detailUrls.count)];

    for (int i = 0; i < detail.detailUrls.count; i ++) {
        NSString *imgUrl = detail.detailUrls[i];
        if (!imgUrl) {
            imgUrl = @"";
        }
        imgUrl = [imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        imgUrl = [imgUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.frame = CGRectMake(0, SCREEN_WIDTH + 288, SCREEN_WIDTH, 0);
        [imageV sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"goodDefault"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error) {
                NSLog(@"error is %@",error.description);
            }else{
//890130
                imageV.frame = CGRectMake(0, heightTemp, SCREEN_WIDTH, SCREEN_WIDTH*(image.size.height / image.size.width));
                heightTemp = imageV.frame.origin.y + imageV.frame.size.height;
                [_contentScroll setContentSize:CGSizeMake(SCREEN_WIDTH, imageV.frame.origin.y + imageV.frame.size.height)];

            }

        }];
        [_contentScroll addSubview:imageV];
//        [_contentScroll setContentSize:CGSizeMake(SCREEN_WIDTH, imageV.frame.origin.y + imageV.frame.size.height)];
    }
    
}
- (void)detailRequest{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    WS(ws);
    FFProductDetailRequest *request = [FFProductDetailRequest Request];
    request.materialId = _meterailId;
    request.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];

    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSuccess) {
            
            NSLog(@"success");
            FFProductDetailModel *detail = [FFProductDetailModel objectWithKeyValues:result.allDic];
            [ws fillContent:detail];
            [_arrMessage addObjectsFromArray:detail.factorys];
            [_factoryTable reloadData];
        
        }else{
            [WToast showWithTextCenter:result.message];
        }
    }];
    
}

- (IBAction)factoryChooseA:(id)sender {
}

- (NSAttributedString *)originalContent:(NSString *)str1 differentContent:(NSString *)str2{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",str1?:@""] attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
    NSAttributedString *strT = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",str2?:@""] attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [str appendAttributedString:strT];
    return str;
}
- (NSAttributedString *)originalContentNext:(NSString *)str1 differentContent:(NSString *)str2{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",str1?:@""] attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
    NSAttributedString *strT = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",str2?:@""] attributes:@{NSForegroundColorAttributeName:RGBCOLORV(0x333333),NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [str appendAttributedString:strT];
    return str;
}

- (void)resetImageFrameObject:(id)obj{
    NSDictionary *dic = [[NSDictionary alloc] init];
    if ([obj isKindOfClass:[NSArray class]]) {
        dic = (NSDictionary *)obj;
    }
    UIImageView *imageV= [dic objectForKey:@"imageV"];
    UIImage *image = [dic objectForKey:@"image"];
    CGFloat heightTemp = [[dic objectForKey:@"heightTemp"] floatValue];
        imageV.frame = CGRectMake(0, heightTemp, SCREEN_WIDTH, SCREEN_WIDTH*(image.size.height / image.size.width));
        heightTemp = imageV.frame.origin.y + imageV.frame.size.height;
    [_contentScroll addSubview:imageV];

    [_contentScroll setContentSize:CGSizeMake(SCREEN_WIDTH, imageV.frame.origin.y + imageV.frame.size.height)];

}
- (IBAction)factoryA:(id)sender {
    [[UIApplication sharedApplication].keyWindow addSubview:_coverView];

}

- (IBAction)closeAction:(id)sender {
    [_coverView removeFromSuperview];

}
- (IBAction)priductAction:(id)sender {
    [_productBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_detailBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_contentScroll setContentOffset:CGPointMake(0, 0)];
}

- (IBAction)detailAction:(id)sender {
    [_productBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_detailBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_contentScroll setContentOffset:CGPointMake(0, SCREEN_WIDTH + 288)];
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
