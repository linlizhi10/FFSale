//
//  FFAllCategoryVC.m
//  FFSales
//
//  Created by lin on 2018/6/6.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFAllCategoryVC.h"
#import "FFHomeBModel.h"
#import "DicBtn.h"
#import "FFProductListVC.h"
@interface FFAllCategoryVC (){
    NSMutableArray *_brandA;
    NSMutableArray *_strainA;
}
@property (weak, nonatomic) IBOutlet UIScrollView *contentScroll;

@end

@implementation FFAllCategoryVC
- (instancetype)initWithId:(NSArray *)brand strain:(NSArray *)strain {
    self = [super init];
    if (self) {
        _brandA = [NSMutableArray arrayWithArray:brand];
        _strainA = [NSMutableArray arrayWithArray:strain];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"所有分类";
//    self.view.backgroundColor = RGBCOLORV(0xdbdbdb);
    self.contentScroll.backgroundColor = RGBCOLORV(0xdbdbdb);
    [self.contentScroll addSubview:[self titleView:@"所有品系" image:[UIImage imageNamed:@"img-sypx"]]];
    for (int i=0; i<_strainA.count; i++) {
        FFHomeBrand *modelT = _strainA[i];
        DicBtn *btn = [DicBtn buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        btn.frame = CGRectMake(0 + (i%3)*((SCREEN_WIDTH - 0.5) / 3 + 0.25), 40 + (i/3)*(39.5+0.5), (SCREEN_WIDTH) / 3 - 0.5, 39.5);
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.dic = @{@"key":modelT.brandId};
        btn.tag = 1000 + i;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:modelT.levelName forState:UIControlStateNormal];
        [self.contentScroll addSubview:btn];
    }
    UIView *viewT = [self titleView:@"所有品牌" image:[UIImage imageNamed:@"img-sypp"]];
    viewT.frame = CGRectMake(0, 80 + (_strainA.count/3) * 40, SCREEN_WIDTH, 40);
    [self.contentScroll addSubview:viewT];
    for (int i=0; i<_brandA.count; i++) {
        FFHomeBrand *modelT = _brandA[i];
        DicBtn *btn = [DicBtn buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        btn.frame = CGRectMake(0 + (i%3)*((SCREEN_WIDTH - 0.5) / 3 + 0.25), viewT.frame.origin.y + 40 + (i/3)*(39.5+0.5), (SCREEN_WIDTH) / 3 - 0.5, 39.5);
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.dic = @{@"key":modelT.brandId};
        btn.tag = 100 + i;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
//        [btn setTitle:modelT.levelName forState:UIControlStateNormal];
        [btn sd_setImageWithURL:[NSURL URLWithString:modelT.picUrl?:@""] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"goodDefault"]];
        [self.contentScroll addSubview:btn];
    }
    [self.contentScroll setContentSize:CGSizeMake(SCREEN_WIDTH, 80 + (_strainA.count/3) * 40 + 40 +(_brandA.count/3 + 1) * 40)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)titleView:(NSString *)title image:(UIImage *)image{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 16, 16)];
    imageV.image = image;
    [view addSubview:imageV];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, SCREEN_WIDTH, 20)];
    label.font = [UIFont systemFontOfSize:14];
    label.text = title;
    [view addSubview:label];
    return view;
}
- (void)buttonClick:(DicBtn *)btn{
    if (btn.tag > 1000) {
        FFProductListVC *productV = [[FFProductListVC alloc] initWithId:nil strain:btn.dic[@"key"] brandA:nil strainA:_strainA];
        productV.title = btn.currentTitle;
        [self.navigationController pushViewController:productV animated:YES];
    }else{
        FFProductListVC *productV = [[FFProductListVC alloc] initWithId:btn.dic[@"key"] strain:nil brandA:_brandA strainA:nil];
        productV.title = btn.currentTitle;
        
        [self.navigationController pushViewController:productV animated:YES];
    }
}

@end
