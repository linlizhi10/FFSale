//
//  FFGetGoodsDVC.m
//  FFSales
//
//  Created by lin on 2018/6/20.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFGetGoodsDVC.h"
#import "FFGoodsHistory.h"
#import "FFGetGoodsRequest.h"
#import "DDStringUtil.h"
@interface FFGetGoodsDVC (){
    NSString *_pickupId;
}
@property (weak, nonatomic) IBOutlet UIImageView *flagImage;
@property (weak, nonatomic) IBOutlet UILabel *flagTitle;
@property (weak, nonatomic) IBOutlet UILabel *salesMan;
@property (weak, nonatomic) IBOutlet UILabel *applyDate;
@property (weak, nonatomic) IBOutlet UILabel *finishDate;
@property (weak, nonatomic) IBOutlet UILabel *note;

@end

@implementation FFGetGoodsDVC
- (instancetype)initWithNo:(NSString *)pickupId {
    self = [super init];
    if (self) {
        _pickupId = pickupId;
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提货详情";
    
    [self detailGet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)detailGet{
    WS(ws);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FFGetGoodsDRequest *request = [FFGetGoodsDRequest Request];
    request.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    request.pickupId = _pickupId;
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (isSuccess) {
            FFGoodsHistoryItem *item = [FFGoodsHistoryItem objectWithKeyValues:result.allDic];;
            [ws fillContent:item];
        }else{
            //                [MBProgressHUD showError:result.message toView:self.view];
            [WToast showWithTextCenter:result.message];
        }
    }];
}
- (void)fillContent:(FFGoodsHistoryItem *)item{
    switch (item.status) {
        case -1:
        {
            _flagTitle.text = @"驳回";
            _flagImage.image = Img(@"img-bohui");
        }
            break;
        case 0:
        {
            _flagTitle.text = @"处理中";
            _flagImage.image = Img(@"img-clz");
        }
            break;
        case 1:
        {
            _flagTitle.text = @"已完成";
            _flagImage.image = Img(@"img-ywc");
        }
            break;
        default:
            break;
    }
    
    _salesMan.text = item.salesman;
    _applyDate.text = [DDStringUtil toDateTimeString:item.createdTime];
    _finishDate.text = [DDStringUtil toDateTimeString:item.invoiceTime];
    _note.text = item.note;
}
@end
