//
//  DDOrderDetailVC.m
//  DaDong
//
//  Created by lin on 2018/3/5.
//  Copyright © 2018年 WintrueTeam. All rights reserved.
//

#import "DDOrderDetailVC.h"
#import "OrderDCell.h"
#import "DDOrderRequest.h"
#import "OrderInfo.h"
#import "FFTrainTransVC.h"
#import "FFTransMethodVC.h"
#import "DDTransInfoVC.h"
@interface DDOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSString *_orderNoS;
    BOOL _audit;
}
@property (weak, nonatomic) IBOutlet UIView *trackView;
@property (weak, nonatomic) IBOutlet UILabel *tipsMessage;
@property (weak, nonatomic) IBOutlet UITableView *goodsTable;
- (IBAction)copyAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *orderName;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *orderState;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UILabel *orderType;//配送方式
@property (weak, nonatomic) IBOutlet UILabel *smallPackageFee;//小包费

@property (weak, nonatomic) IBOutlet UILabel *memberName;//sap编号
@property (weak, nonatomic) IBOutlet UILabel *guide;//下单时间
@property (weak, nonatomic) IBOutlet UILabel *commision;//支付时间
@property (weak, nonatomic) IBOutlet UILabel *payMethod;
@property (weak, nonatomic) IBOutlet UILabel *orderFinishTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lastViewHeightC;

@property (weak, nonatomic) IBOutlet UILabel *price;//总吨数

@property (weak, nonatomic) IBOutlet UILabel *deduction;//订单金额

@property (weak, nonatomic) IBOutlet UILabel *couponDiscoutAmount;//优惠金额
@property (weak, nonatomic) IBOutlet UILabel *promoDiscountAmount;//运费

@property (weak, nonatomic) IBOutlet UILabel *carriage;//装卸费
- (IBAction)transAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *amountDes;

@property (strong, nonatomic) OrderInfoDetail *detail;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
- (IBAction)cancelOrder:(id)sender;
- (IBAction)continuePay:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginConstant;
@property (weak, nonatomic) IBOutlet UILabel *transView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstant;
@property (weak, nonatomic) IBOutlet UILabel *factory;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
- (IBAction)trackAction:(id)sender;

@end
static NSString *refreshNoti = @"refreshOrderData";
@implementation DDOrderDetailVC
- (instancetype)initWithNo:(NSString *)orderNo audit:(BOOL)audit{
    self = [super init];
    if (self) {
        _orderNoS = orderNo;
        _audit = audit;
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"sourceChannel"]isEqualToString:@"EMP"]) {
        _topConstraint.constant = 0;
    }
    [_goodsTable registerNib:[UINib nibWithNibName:@"OrderDCell" bundle:nil] forCellReuseIdentifier:@"cellOrder"];
    _goodsTable.estimatedRowHeight = 102;
    _goodsTable.rowHeight = UITableViewAutomaticDimension;
    [self detailDataLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark
#pragma mark --tabel--

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderDCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellOrder"];
    OrderProduct *product = _detail.materials[indexPath.row];
    [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:product.picUrl] placeholderImage:[UIImage imageNamed:@"goodDefault"]];
    cell.goodsName.text = product.materialName;
//    cell.skuInfo.text = [NSString stringWithFormat:@"购买数量:%@吨",product.qty?:@""];
    cell.price.text = [NSString stringWithFormat:@"￥%@",product.price];
//    cell.goodsNumber.text = [NSString stringWithFormat:@"x%@",product.count];
    cell.goodsNO.text = [NSString stringWithFormat:@"购买数量:%.2f吨",product.qty];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _detail.materials.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 102;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 200;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
    return _headerView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if([_detail.status isEqualToString:@"05"] ){
        return 436;
    }
    return 400;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if([_detail.status isEqualToString:@"05"] ){
        _footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 466);
    }
    _footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 430);
    return _footerView;
}
#pragma mark ---- uialertviewDelegate-
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }else{
        [alertView dismissWithClickedButtonIndex:1 animated:YES];
        [self cancelOrderR];
    }
}

- (void)fillAmountDesAmount:(NSString *)number price:(NSString *)price{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"订单结算金额" attributes:@{NSForegroundColorAttributeName:RGBCOLORV(0x1c1c20)}];
    NSAttributedString *strT = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",price?:@""] attributes:@{NSForegroundColorAttributeName:RGBCOLORV(0xed265a)}];
    [str appendAttributedString:strT];
    _amountDes.attributedText =str;
    
}
- (void)cancelOrderR{
//    [WToast showWithTextCenter:@"功能暂未开放"];
//    return;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DDCancelRequest *request = [DDCancelRequest Request];
    request.orderNo = _orderNoS;
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSuccess) {
            _buttonView.hidden = YES;
            _orderState.text = @"已取消";
            [[NSNotificationCenter defaultCenter] postNotificationName:refreshNoti object:nil];
        }else{
            [WToast showWithTextCenter:result.message];
        }
    }];
}
- (void)detailDataLoad{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DDOrderDetailRequest *request = [DDOrderDetailRequest Request];
    request.orderId = _orderNoS;
    request.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];

    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (isSuccess) {
            
                OrderInfoDetail *detail = [OrderInfoDetail objectWithKeyValues:result.allDic];
                _detail = detail;
                [self fillContent:detail];
                [_goodsTable reloadData];
            
           
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [WToast showWithTextCenter:result.message];
        }
    }];
}
- (void)fillContent:(OrderInfoDetail *)detail{
//    _orderName.text = detail.receiver?:@"暂无";
    if (!_audit) {
        _tipsMessage.text = @"订单后台审核中";
        _trackView.hidden = YES;
        _marginConstant.constant = 10;
    }else{
        if ([detail.status isEqualToString:@"01"]) {//审核中
            _tipsMessage.text = @"订单后台审核中";
            _trackView.hidden = YES;
            _marginConstant.constant = 10;
        }
       else if ([detail.status isEqualToString:@"02"] || [detail.status isEqualToString:@"03"] ) {
            _tipsMessage.text = [NSString stringWithFormat:@"已发货%@/%.2f",detail.sendQty,detail.qty];
            _phone.text = [NSString stringWithFormat:@"%@吨商品已发货",detail.sendQty];

            
        }else if([detail.status isEqualToString:@"05"] ){
            _tipsMessage.text = @"订单已完成";
            _phone.text = @"你已确认收到所有货物";
            _orderFinishTime.hidden = NO;
            
        }else if([detail.status isEqualToString:@"06"] || [detail.status isEqualToString:@"07"] ){
            _tipsMessage.text = @"订单已关闭";
            _phone.text = @"订单已关闭";
        }
    }
//    _phone.text = detail.status?:@"暂无";
    _address.text = detail.receiveAdd?:@"暂无";
    _orderNo.text = detail.orderId;
    _orderType.text = detail.transport;
    _memberName.text = detail.sapCode;
    _factory.text = [NSString stringWithFormat:@"发货工厂：%@",detail.sendFactory];
    _guide.text = [NSString stringWithFormat:@"下单时间：%@",[self toDateString: detail.createTime]];
    NSString *statusS = @"";
    
        
    if ([detail.status isEqualToString:@"02"] || [detail.status isEqualToString:@"03"] ) {
        statusS = @"待完成";
        
    }else if([detail.status isEqualToString:@"05"] ){
        statusS = @"已完成";
        _orderFinishTime.hidden = NO;
    }else if([detail.status isEqualToString:@"06"] || [detail.status isEqualToString:@"07"] ){
        statusS = @"已关闭";
    }
    
    
    _orderState.text = statusS;
    
    
    _price.text = [NSString stringWithFormat:@"%.2f吨",detail.qty];
    _deduction.text = [NSString stringWithFormat:@"￥%.2f",detail.actualAmout];
    _couponDiscoutAmount.text = [NSString stringWithFormat:@"￥%.2f",detail.discountAmount];
    _promoDiscountAmount.text = [NSString stringWithFormat:@"￥%.2f",detail.transportAmout];
    _carriage.text = [NSString stringWithFormat:@"￥%@",detail.handlingCharges];
    _payMethod.text = [NSString stringWithFormat:@"支付方式：%@",detail.payType];
    _commision.text =[NSString stringWithFormat:@"支付时间：%@",[self toDateString: detail.payTime]];
    _orderFinishTime.text = [NSString stringWithFormat:@"订单完成：%@",[self toDateString: detail.finishTime]];
    [self fillAmountDesAmount:[NSString stringWithFormat:@"%.2f",detail.qty] price:[NSString stringWithFormat:@"￥%.2f",detail.payAmout]];
//    if ([detail.orderStatus isEqualToString:@"1"]) {
//        _buttonView.hidden = NO;
//        _bottomConstant.constant = 40;
//    }
}
- (IBAction)cancelOrder:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"取消订单" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
}

- (IBAction)continuePay:(id)sender {
    
}
- (IBAction)transAction:(id)sender {
    if ([_detail.transport isEqualToString:@"火运"]) {
        FFTrainTransVC *transVC = [[FFTrainTransVC alloc] initWithNo:_detail];
        [self.navigationController pushViewController:transVC animated:YES];
        
    }else{ FFTransMethodVC *transVC = [[FFTransMethodVC alloc] initWithNo:_detail];
        [self.navigationController pushViewController:transVC animated:YES];
    }}
   
- (NSString *)toDateString:(long)longDate{
    NSDate*timeDate = [[NSDate alloc]initWithTimeIntervalSince1970:longDate/1000.0];
    
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    
    dateFormatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    
    return [dateFormatter stringFromDate:timeDate];
}
- (IBAction)copyAction:(id)sender {
    [WToast showWithTextCenter:@"复制成功!"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _detail.sapCode;;
    
}
- (IBAction)trackAction:(id)sender {
    DDTransInfoVC *trans = [[DDTransInfoVC alloc] initWithNo:_detail.orderId];
    [self.navigationController pushViewController:trans animated:YES];
}
@end
