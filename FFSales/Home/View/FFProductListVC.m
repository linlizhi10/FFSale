//
//  FFProductListVC.m
//  FFSales
//
//  Created by lin on 2018/6/5.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFProductListVC.h"
#import "FFProductDetailRequest.h"
#import "FFProductModel.h"
#import "FFProductDetailVC.h"
#import "TableGoodsCell.h"
#import "FilterCell.h"
#import "FFHomeBModel.h"
@interface FFProductListVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSString *_brand;
    NSString *_strain;
    NSMutableArray *_brandA;
    NSMutableArray *_strainA;
}
@property (assign, nonatomic) int pageSize;
@property (assign, nonatomic) int currentPage;

@property (weak, nonatomic) IBOutlet UITableView *productList;
@property (strong, nonatomic) NSMutableArray *arrP;
@property (strong, nonatomic) FFProductListModel *model;
@property (weak, nonatomic) IBOutlet UITextField *contentTF;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
- (IBAction)allBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UITableView *filterTable;

@end

@implementation FFProductListVC
- (instancetype)initWithId:(NSString *)brand strain:(NSString *)strain brandA:(NSArray *)brandA strainA:(NSArray *)strainA {
    self = [super init];
    if (self) {
        _brand = brand;
        _strain = strain;
        _brandA = [NSMutableArray arrayWithArray:brandA];
        _strainA = [NSMutableArray arrayWithArray:strainA];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = _brand?_brand:_strain;
    [_productList registerNib:[UINib nibWithNibName:@"TableGoodsCell" bundle:nil] forCellReuseIdentifier:@"goods"];
    [_filterTable registerNib:[UINib nibWithNibName:@"FilterCell" bundle:nil] forCellReuseIdentifier:@"filter"];

    _productList.footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(addPage)];

    _contentTF.returnKeyType = UIReturnKeySearch;
    _contentTF.delegate = self;
    _arrP = [[NSMutableArray alloc] init];
    _currentPage = 1;
    _pageSize = 20;
    [self dataRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    [self dataRequest];
    return YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _productList) {
        return _arrP.count;

    }else{
        if (_brandA.count >0) {
            return _brandA.count;
        }else{
            return _strainA.count;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _productList) {
        TableGoodsCell *productCell = [tableView dequeueReusableCellWithIdentifier:@"goods"];
        
        FFProductModel *product = _arrP[indexPath.row];
        [productCell.goodsImage sd_setImageWithURL:[NSURL URLWithString:product.picUrl?:@""] placeholderImage:[UIImage imageNamed:@"goodDefault"]];
        productCell.productName.text = product.name;
        productCell.unitPrice.attributedText = [self originalContent:product.price differentContent:@"/吨"];
        return productCell;
    }else{
        FilterCell *productCell = [tableView dequeueReusableCellWithIdentifier:@"filter"];
        productCell.backgroundColor = [UIColor blackColor];
        FFHomeBrand *product = nil;
        if (_brandA.count > 0) {
            product = _brandA[indexPath.row];
        }else{
            product = _strainA[indexPath.row];
        }
        productCell.contentLabel.text = product.levelName;
        return productCell;
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _productList) {
        FFProductModel *prodcutI = _arrP[indexPath.row];
        FFProductDetailVC *inventoryVC = [[FFProductDetailVC alloc] initWithId:prodcutI.materialId];
        [self.navigationController pushViewController:inventoryVC animated:YES];
    }else{
        [self allBtnAction:nil];
        FFHomeBrand *product = nil;
        if (_brandA.count >0) {
            product = _brandA[indexPath.row];
            _brand = product.brandId;
        }else{
            product = _strainA[indexPath.row];
            _strain = product.brandId;
        }
        [self dataRequest];
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _productList) {

        return 100;
    }return 40;
}
- (void)dataRequest{
   
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    FFProductListRequest *request = [FFProductListRequest Request];
    request.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    request.page = _currentPage;
    request.size = _pageSize;
    request.brand = _brand;
    request.strain = _strain;
    request.keyword = _contentTF.text;
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_productList.footer endRefreshing];
        if (isSuccess) {
            _model = [FFProductListModel objectWithKeyValues:result.allDic];
            [_arrP addObjectsFromArray:_model.list];
            [_productList reloadData];
            if (_model.list.count == 0) {
                [_productList.footer endRefreshingWithNoMoreData];
            }
            if (_arrP.count == result.totalRecord) {
                [_productList.footer endRefreshingWithNoMoreData];
                
            }
        }else{
            [WToast showWithTextCenter:result.message];
        }
    }];
    
}
- (IBAction)allBtnAction:(id)sender {
    _shadowView.hidden = !_shadowView.hidden;
    if (_shadowView.hidden) {
        [_allBtn setImage:[UIImage imageNamed:@"icon-syfn-down"] forState:UIControlStateNormal];
    }else{
        [_allBtn setImage:[UIImage imageNamed:@"icon-syfn-up"] forState:UIControlStateNormal];

    }
}
- (NSAttributedString *)originalContent:(NSString *)str1 differentContent:(NSString *)str2{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",str1?:@""] attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
    NSAttributedString *strT = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",str2?:@""] attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [str appendAttributedString:strT];
    return str;
}
- (void)addPage{
    _currentPage++;
    [self dataRequest];
}
@end
