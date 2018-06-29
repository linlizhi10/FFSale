//
//  DDHomeVC.m
//  FFSales
//
//  Created by lin on 2018/5/30.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "DDHomeVC.h"
#import "FFInfo.h"
#import "SearchRCell.h"
#import "FFCHeaderView.h"
#import "FFSHeaderView.h"
#import "FFHomeRequest.h"
#import "FFGoodsCell.h"
#import "FFHomeBModel.h"
#import "FFProductModel.h"
#import "FFProductDetailVC.h"
#import "FFSearchVC.h"
#import "SDCycleScrollView.h"
#import "FFProductListVC.h"
#import "FFOrderVC.h"
#import "DicBtn.h"
#import "FFAllCategoryVC.h"
#import "FIUserInfoRequest.h"
#import "FFGestureData.h"
@interface DDHomeVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *goodsListC;

@property (strong, nonatomic) IBOutlet UIView *secondHeader;
@property (strong, nonatomic) FFHomeBAModel *modelBA;
@property (weak, nonatomic) FFCHeaderView *headerV;
@property (assign, nonatomic) int pageSize;
@property (assign, nonatomic) int currentPage;
@property (strong, nonatomic) FFProductListModel *model;
@property (strong, nonatomic) NSMutableArray *arrLike;

@property (strong, nonatomic) NSMutableArray *brandA;
@property (strong, nonatomic) NSMutableArray *strainA;
@end

@implementation DDHomeVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"sourceChannel"]isEqualToString:@"EMP"]) {
    }else{
        [self gestureGet];

    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    _modelBA = [[FFHomeBAModel  alloc] init];
    [_goodsListC registerNib:[UINib nibWithNibName:@"FFCHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    [_goodsListC registerNib:[UINib nibWithNibName:@"FFSHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sHeaderView"];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    CGFloat itemW =(SCREEN_WIDTH- 30)/2;
    flowLayout.itemSize = CGSizeMake(itemW, itemW + 68);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [_goodsListC setCollectionViewLayout:flowLayout];
    //    _goodsListC.backgroundColor = [UIColor yellowColor];
    _goodsListC.pagingEnabled = YES;
    _goodsListC.showsHorizontalScrollIndicator = NO;
    _goodsListC.showsVerticalScrollIndicator = NO;
    [_goodsListC registerNib:[UINib nibWithNibName:@"SearchRCell" bundle:nil] forCellWithReuseIdentifier:@"search"];
    [_goodsListC registerNib:[UINib nibWithNibName:@"FFGoodsCell" bundle:nil] forCellWithReuseIdentifier:@"goods"];

    _goodsListC.footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(addPage)];
    _currentPage = 1;
    _pageSize = 20;
    _arrLike = [[NSMutableArray alloc] init];
    _goodsListC.scrollsToTop = YES;
    [self dataReqeust];
    
}
- (void)dealloc{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    FFSearchVC *searchV = [[FFSearchVC alloc] init];
    searchV.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchV animated:YES];
    return NO;
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return _model.list.count;
    }
    return _arrLike.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        FFGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"goods" forIndexPath:indexPath];
        FFProductModel *model = _model.list[indexPath.row];
        [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.picUrl?:@""] placeholderImage:[UIImage imageNamed:@"goodDefault"]];
        cell.productName.text = model.name;
        cell.unitPrice.attributedText = [self originalContent:model.price differentContent:@"/吨"];
        return cell;
    }else{
        SearchRCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"search" forIndexPath:indexPath];
        FFProductModel *model = _arrLike[indexPath.row];
        [cell.productImg sd_setImageWithURL:[NSURL URLWithString:model.picUrl?:@""] placeholderImage:[UIImage imageNamed:@"goodDefault"]];
        cell.titleLabel.text = model.name;
        cell.price.attributedText = [self originalContent:model.price differentContent:@"/吨"];
    
        return cell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        FFProductModel *prodcutI = _model.list[indexPath.row];
        FFProductDetailVC *inventoryVC = [[FFProductDetailVC alloc] initWithId:prodcutI.materialId];
        inventoryVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:inventoryVC animated:YES];
    }else{
        FFProductModel *prodcutI = _arrLike[indexPath.row];
        FFProductDetailVC *inventoryVC = [[FFProductDetailVC alloc] initWithId:prodcutI.materialId];
        inventoryVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:inventoryVC animated:YES];
    }
 
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, 372);

    }else{
        return CGSizeMake(SCREEN_WIDTH, 40);
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView =nil;
    
    if(kind ==UICollectionElementKindSectionHeader){
        if (indexPath.section == 0) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier: @"headerView" forIndexPath: indexPath];
            reusableView = headerView;
            _headerV = (FFCHeaderView *)headerView;
            _headerV.contentTF.delegate = self;
            _headerV.headImageView.backgroundColor = [UIColor whiteColor];
            _headerV.headImageView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
            _headerV.headImageView.pageDotColor = [UIColor redColor];
            _headerV.headImageView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
            [_headerV.checkAll addTarget:self action:@selector(checkAllAction) forControlEvents:UIControlEventTouchUpInside];
            [_headerV.allCategoryBtn addTarget:self action:@selector(allCategoryAction) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if (indexPath.section == 1) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier: @"sHeaderView" forIndexPath: indexPath];
            reusableView = headerView;
            
        }
    }
    
    if(kind ==UICollectionElementKindSectionFooter) {
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier: @"headerView" forIndexPath: indexPath];
        
        reusableView = headerView;
        
    }
    
    return reusableView;
    
   
}
#pragma mark -- UICollectionViewDelegateFlowLayout
// 每个cell的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemW =(SCREEN_WIDTH- 30)/2;

    if (indexPath.section == 0) {
        return CGSizeMake(SCREEN_WIDTH- 30, 101);
    }else if (indexPath.section == 1){
        return CGSizeMake(itemW, itemW + 68);
    }
    return CGSizeMake(SCREEN_WIDTH- 30, itemW + 68);

}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    FFHomeBModel *brand = _modelBA.list[index];
    if ([brand.type isEqualToString:@"brand"]) {
        FFProductListVC *productV = [[FFProductListVC alloc] initWithId:brand.value strain:nil brandA:_brandA strainA:nil];
        productV.title = brand.levelName;
        productV.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:productV animated:YES];
    }else{
        FFProductListVC *productV = [[FFProductListVC alloc] initWithId:nil strain:brand.value brandA:nil strainA:_strainA];
        productV.title = brand.levelName;
        productV.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:productV animated:YES];
    }
   
}

- (void)dataReqeust{
    [self bannerGet];
    [self brandRequestType:@"1"];
    [self brandRequestType:@"2"];
    [self recentlyRequest];
    [self likeRequest];
}
- (void)likeRequest{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    FFHomeLikeRequest *request = [FFHomeLikeRequest Request];
    request.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    request.page = _currentPage;
    request.size = _pageSize;
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_goodsListC.footer endRefreshing];

        if (isSuccess) {
            
            FFProductListModel *model = [FFProductListModel objectWithKeyValues:result.allDic];
            [_arrLike addObjectsFromArray:model.list];
            if (model.list.count == 0) {
                [_goodsListC.footer endRefreshingWithNoMoreData];
            }
            if (_arrLike.count == result.totalRecord) {
                [_goodsListC.footer endRefreshingWithNoMoreData];
                
            }
            [_goodsListC reloadData];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            [WToast showWithTextCenter:result.message];
        }
    }];
    
}
- (void)recentlyRequest{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    FFHomeRecentlyRequest *request = [FFHomeRecentlyRequest Request];
    request.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    request.page = 1;
    request.size = 10;
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSuccess) {
            
            FFProductListModel *model = [FFProductListModel objectWithKeyValues:result.allDic];
            _model = model;
            [_goodsListC reloadData];

        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            [WToast showWithTextCenter:result.message];
        }
    }];

}
- (void)brandRequestType:(NSString *)type{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    FFHomeBrandRequest *request = [FFHomeBrandRequest Request];
    request.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    request.levels = type;
    //    request.password = @"168e969d48e2fe1c7a1f84f41f2cc2cd";
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSuccess) {
            
            NSLog(@"success");
            FFHomeBrandA *model = [FFHomeBrandA objectWithKeyValues:result.allDic];
           
            if ([type isEqualToString:@"1"]) {
                _brandA = [NSMutableArray arrayWithArray:model.list];

                for (int i =0; i < 2; i++) {
                    FFHomeBrand *modelT = model.list[i];
                    DicBtn *btn = [DicBtn buttonWithType:UIButtonTypeCustom];
                    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                    btn.frame = CGRectMake(0 + i*(SCREEN_WIDTH) / 3, 80, (SCREEN_WIDTH) / 3, 40);
                    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                    btn.dic = @{@"key":modelT.brandId};

                    [_headerV.brandVIew addSubview:btn];
                    btn.tag = 6 + i;
//                    [btn setTitle:modelT.levelName forState:UIControlStateNormal];
                    [btn sd_setImageWithURL:[NSURL URLWithString:modelT.picUrl?:@""] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"goodDefault"]];
                    
                }
            }else if ([type isEqualToString:@"2"]){
                _strainA = [NSMutableArray arrayWithArray:model.list];

                for (int i =0; i < 6; i++) {
                    FFHomeBrand *modelT = model.list[i];
                    DicBtn *btn = [DicBtn buttonWithType:UIButtonTypeCustom];
                    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                    btn.dic = @{@"key":modelT.brandId};
                    btn.frame = CGRectMake(0 + (i % 3)*(SCREEN_WIDTH) / 3, (i/3)*40, (SCREEN_WIDTH) / 3, 40);
                    [_headerV.brandVIew addSubview:btn];
                    btn.tag = i;
                    btn.titleLabel.font = [UIFont systemFontOfSize:14];
                    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                    [btn setTitle:modelT.levelName forState:UIControlStateNormal];
                    //                [btn sd_setImageWithURL:[NSURL URLWithString:modelT.picUrl?:@""] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"goodDefault"]];
                    
                }
                
            }
            
            [_goodsListC reloadData];
            
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            [WToast showWithTextCenter:result.message];
        }
    }];
}
- (void)bannerGet{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    FFHomeBannerRequest *request = [FFHomeBannerRequest Request];
    request.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    //    request.password = @"168e969d48e2fe1c7a1f84f41f2cc2cd";
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSuccess) {
            
            NSLog(@"success");
            FFHomeBAModel *model = [FFHomeBAModel objectWithKeyValues:result.allDic];
            NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
            for (int i =0; i < model.list.count; i++) {
                FFHomeBModel *modelT = model.list[i];
                _modelBA = model;
//                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [arrTemp addObject:modelT.img];
//                btn.frame = CGRectMake(0 + (SCREEN_WIDTH) * i, 0, SCREEN_WIDTH, 200);
//                btn.backgroundColor = [UIColor redColor];
//                [_headerV.imageScroll addSubview:btn];
//                [btn sd_setImageWithURL:[NSURL URLWithString:modelT.img?:@""] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"goodDefault"]];
//                [btn sd_setImageWithURL:[NSURL URLWithString:@"http://uatimage.dusto.cn/uat/804029/ce863827693249d1bcc8a28a49f1efc4.jpg"] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"goodDefault"]];

            }
            _headerV.headImageView.delegate = self;
            _headerV.headImageView.imageURLStringsGroup = arrTemp;
            [_goodsListC reloadData];
            
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            [WToast showWithTextCenter:result.message];
        }
    }];

}

#pragma mark - gesture get -
- (void)gestureGet{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    FIUserInfoRequest *request = [FIUserInfoRequest Request];
    request.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSuccess) {
            
            FFGestureInfo *gesture = [FFGestureInfo objectWithKeyValues:result.allDic];
            [FFGestureData insertGestureCode:gesture.code key:GestureCodeString];
            [FFGestureData insertGestureState:gesture.state key:GestureStateString];
            
        }else{
            if ([result.status isEqualToString:@"404"]) {
                
            }else{
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                [WToast showWithTextCenter:result.message];
                
            }
        }
    }];
    
}


- (NSAttributedString *)originalContent:(NSString *)str1 differentContent:(NSString *)str2{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",str1?:@""] attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
    NSAttributedString *strT = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",str2?:@""] attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [str appendAttributedString:strT];
    return str;
}
- (void)buttonClick:(DicBtn *)btn{
    if (btn.tag < 6) {
        FFProductListVC *productV = [[FFProductListVC alloc] initWithId:nil strain:btn.dic[@"key"] brandA:nil strainA:_strainA];
        productV.title = btn.currentTitle;
        productV.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:productV animated:YES];
    }else{
        FFProductListVC *productV = [[FFProductListVC alloc] initWithId:btn.dic[@"key"] strain:nil brandA:_brandA strainA:nil];
        productV.title = btn.currentTitle;

        productV.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:productV animated:YES];
    }
}
- (void)allCategoryAction{
    FFAllCategoryVC *inventoryVC = [[FFAllCategoryVC alloc] initWithId:_brandA strain:_strainA];
    inventoryVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:inventoryVC animated:YES];
}
- (void)addPage{
    _currentPage++;
    [self likeRequest];
}
- (void)checkAllAction{
    FFOrderVC *orderVC= [[FFOrderVC alloc] initWithType:0];
    orderVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderVC animated:YES];
}
@end
