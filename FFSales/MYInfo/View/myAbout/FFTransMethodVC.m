//
//  FFTransMethodVC.m
//  FFSales
//
//  Created by lin on 2018/6/11.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFTransMethodVC.h"
#import "OrderInfo.h"
@interface FFTransMethodVC ()<UIAlertViewDelegate>
{
    OrderInfoDetail *_order;
}


@property (weak, nonatomic) IBOutlet UILabel *transMethod;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *carrageFee;
- (IBAction)callAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *flagImage;
@property (weak, nonatomic) IBOutlet UILabel *wayOfTrans;
@property (weak, nonatomic) IBOutlet UILabel *tipsMessage;
@property (nonatomic, strong) UIAlertView *alert;
@property (copy, nonatomic) NSString *customerTel;

@end

@implementation FFTransMethodVC
- (instancetype)initWithNo:(OrderInfoDetail *)order{
    self = [super init];
    if (self) {
        _order = order;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"配送方式";
    _customerTel = @"400-8188-2539";
    _transMethod.text = _order.transport;
    _tipsMessage.text = [NSString stringWithFormat:@"%@客户自己承担运输费用",_order.transport];
    _wayOfTrans.text = _order.transport;
    _number.text = [NSString stringWithFormat:@"%.2f吨",_order.qty];
    _carrageFee.attributedText = [self originalContentNext:[NSString stringWithFormat:@"装卸费:%.2f/吨",_order.transportPrice] differentContent:[NSString stringWithFormat:@"￥%.2f",_order.transportAmout]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSLog(@"phone");
        NSString *telphoneStr = [NSString stringWithFormat:@"tel:%@",_customerTel];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telphoneStr]];
        
    }
}
- (IBAction)callAction:(id)sender {
    NSLog(@"call action");
    NSString *str2 = [[UIDevice currentDevice] systemVersion];
    if ([str2 compare:@"10.2" options:NSNumericSearch] == NSOrderedDescending || [str2 compare:@"10.2" options:NSNumericSearch] == NSOrderedSame)
    {
        NSString* PhoneStr = [NSString stringWithFormat:@"telprompt://%@",_customerTel];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PhoneStr] options:@{} completionHandler:^(BOOL success) {
            NSLog(@"phone success");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        //        [MBProgressHUD hideHUDForView:self.view];
        
    }else{
        if (!_alert) {
            _alert = [[UIAlertView alloc] initWithTitle:nil message:_customerTel delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
        }
        
        [_alert show];
    }
}

- (NSAttributedString *)originalContentNext:(NSString *)str1 differentContent:(NSString *)str2{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",str1?:@""] attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    NSAttributedString *strT = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",str2?:@""] attributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [str appendAttributedString:strT];
    return str;
}
@end
