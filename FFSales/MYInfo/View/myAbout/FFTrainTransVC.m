//
//  FFTrainTransVC.m
//  FFSales
//
//  Created by lin on 2018/6/12.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFTrainTransVC.h"
#import "OrderInfo.h"
@interface FFTrainTransVC ()
{
    OrderInfoDetail *_order;
}
@property (weak, nonatomic) IBOutlet UILabel *transMethod;
@property (weak, nonatomic) IBOutlet UILabel *factoryFrom;
@property (weak, nonatomic) IBOutlet UILabel *destination;
@property (weak, nonatomic) IBOutlet UILabel *trainArrive;
@property (weak, nonatomic) IBOutlet UILabel *transAmount;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *address;

@end

@implementation FFTrainTransVC
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
    _factoryFrom.text = _order.sendFactory;
    _destination.text = _order.destination;
    _trainArrive.text = _order.destination;
     _number.text = [NSString stringWithFormat:@"%@吨",_order.qty];

    _transAmount
    .attributedText = [self originalContentNext:[NSString stringWithFormat:@"装卸费:%.2f/吨",_order.transportPrice] differentContent:[NSString stringWithFormat:@"￥%.2f",_order.transportAmout]];
    _phone.text = _order.receiverPhone;
    _name.text = [NSString stringWithFormat:@"收货人:%@",_order.receiveName];
    _address.text =[NSString stringWithFormat:@"收货地址:%@",_order.receiveAdd];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSAttributedString *)originalContentNext:(NSString *)str1 differentContent:(NSString *)str2{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",str1?:@""] attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    NSAttributedString *strT = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",str2?:@""] attributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [str appendAttributedString:strT];
    return str;
}
@end
