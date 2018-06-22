//
//  FFRankClassVC.m
//  FFSales
//
//  Created by lin on 2018/6/19.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFRankClassVC.h"
#import "FFMHomeRequest.h"
#import "FFrank.h"
@interface FFRankClassVC ()
@property (weak, nonatomic) IBOutlet UIButton *cashBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (assign, nonatomic)  int moneyType;
@property (weak, nonatomic) IBOutlet UIImageView *imageNunber;
@property (weak, nonatomic) IBOutlet UILabel *percentage;
@property (weak, nonatomic) IBOutlet UILabel *dunNumber;
@property (weak, nonatomic) IBOutlet UILabel *goal;
@property (weak, nonatomic) IBOutlet UILabel *distanceNumber;
@property (weak, nonatomic) IBOutlet UILabel *areaComplish;
@property (weak, nonatomic) IBOutlet UILabel *provinceComplish;
@property (weak, nonatomic) IBOutlet UILabel *exportNmber;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UILabel *district;
@property (weak, nonatomic) IBOutlet UILabel *province;
@property (weak, nonatomic) IBOutlet UILabel *districtNumber;
@property (weak, nonatomic) IBOutlet UILabel *provinceNumber;
@property (weak, nonatomic) IBOutlet UILabel *natiionNumber;
@property (strong, nonatomic) FFrank *rank;
- (IBAction)timeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *shadowView;

- (IBAction)filterAction:(id)sender;
@property (strong, nonatomic) NSMutableArray *arrTitle;
@property (strong, nonatomic) NSMutableArray *arrTitleB;

@property (weak, nonatomic) IBOutlet UILabel *nation;

@end

@implementation FFRankClassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务排名";
    _rank = [[FFrank alloc] init];
    [self dataLoad];
    _arrTitle = [NSMutableArray arrayWithObjects:@{@"key":_district,@"value":_districtNumber},@{@"key":_province,@"value":_provinceNumber},@{@"key":_nation,@"value":_natiionNumber}, nil];
    _arrTitleB = [NSMutableArray arrayWithObjects:_areaComplish,_provinceComplish, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)typeClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    _moneyType = (int)btn.tag;
    if (_moneyType == 0) {
        _cashBtn.selected = YES;
        _checkBtn.selected = NO;
        _checkBtn.backgroundColor = [UIColor whiteColor];
        
    }else{
        _cashBtn.selected = NO;
        _checkBtn.selected = YES;
        _cashBtn.backgroundColor = [UIColor whiteColor];

    }
    btn.backgroundColor = RGBCOLORV(0xf8f8f8);
    
    [self dataLoad];
   
}

- (IBAction)timeAction:(id)sender {
    _shadowView.hidden = !_shadowView.hidden;
    if (_shadowView.hidden) {
        [_timeBtn setImage:[UIImage imageNamed:@"icon-syfn-down"] forState:UIControlStateNormal];
    }else{
        [_timeBtn setImage:[UIImage imageNamed:@"icon-syfn-up"] forState:UIControlStateNormal];
        
    }
}
- (IBAction)filterAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [_timeBtn setTitle:btn.currentTitle forState:UIControlStateNormal];
    _shadowView.hidden = YES;
    [self fillSubContent:(int)btn.tag];
}

- (void)dataLoad{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FFTaskRequest *request = [FFTaskRequest Request];
    WS(ws);
    request.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    request.taskListType = _moneyType;
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (isSuccess) {
          
            FFrank *rank = [FFrank objectWithKeyValues:result.allDic];
            _rank = rank;
            [ws fillContent:rank];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [WToast showWithTextCenter:result.message];
        }
    }];
}
- (void)fillContent:(FFrank *)rank{
    _goal.text = [NSString stringWithFormat:@"目标:%.2f吨",rank.yearTargetCoefficient];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",rank.coefficient] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    NSAttributedString *strT = [[NSAttributedString alloc] initWithString:@"吨" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    [str appendAttributedString:strT];
    _dunNumber.attributedText = str;
    NSString *strTemp = @"实物吨";
    if (_moneyType == 1) {
        strTemp = @"标准吨";
    }
    _distanceNumber.text = [NSString stringWithFormat:@"%@距年度任务量的返利目标还差%.2f吨",strTemp,rank.yearTargetCoefficient - rank.coefficient];
    _percentage.text = [NSString stringWithFormat:@"%.0f%%",(rank.coefficient / rank.yearTargetCoefficient) * 100];
    float num = (rank.coefficient / rank.yearTargetCoefficient) * 10;
    NSString *images = [NSString stringWithFormat:@"img-ybp-%.0f",num];
    _imageNunber.image = Img(images);
    int count = 2;
    if (count >= rank.reachs.count) {
        count = (int)rank.reachs.count;
    }
    for (int i = 0; i<count; i ++) {
        UILabel *valueL = _arrTitleB[i];
        FFreachs *area = rank.reachs[i];
        
        valueL.text = [NSString stringWithFormat:@"%@已有%d家公司达成目标",area.area,area.num];
    }
    
    [self fillSubContent:1];
   
}
- (void)fillSubContent:(int)type{
    NSString *timeStr = @"本月";
    FFmonth *monthS = _rank.month;
    if (type == 2) {
        timeStr = @"本季度";
        monthS = _rank.quarter;
    }else if (type == 3){
        timeStr = @"本年";
        monthS = _rank.year;
    }
    _exportNmber.text = [NSString stringWithFormat:@"你%@出货量:%.2f吨",timeStr,monthS.shipments] ;
    
    for (int i = 0; i<monthS.areas.count; i++) {
        if (i<_arrTitle.count) {
            NSDictionary *dic = _arrTitle[i];
            FFareas *area = monthS.areas[i];
            UILabel *keyL = [dic objectForKey:@"key"];
            keyL.text = area.area;
            UILabel *valueL = [dic objectForKey:@"value"];
            valueL.text = [NSString stringWithFormat:@"%@排名:第%d名",timeStr,area.num];
        }
    }
}
@end
