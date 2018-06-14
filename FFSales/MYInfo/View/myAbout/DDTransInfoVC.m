//
//  DDTransInfoVC.m
//  DaDong
//
//  Created by lin on 2018/3/6.
//  Copyright © 2018年 WintrueTeam. All rights reserved.
//

#import "DDTransInfoVC.h"
#import "TransDetailCell.h"
#import "DDOrderRequest.h"
#import "DDTransInfo.h"
@interface DDTransInfoVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *_orderNoS;
    
}
@property (weak, nonatomic) IBOutlet UITableView *transInfoTable;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScroll;
@property (weak, nonatomic) IBOutlet UIScrollView *btnScroll;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (strong, nonatomic)  DDTransInfo *transInfo;
@property (assign, nonatomic)  int selectOrder;
@property (weak, nonatomic) IBOutlet UILabel *sendaA;
@property (weak, nonatomic) IBOutlet UILabel *buyA;
@property (weak, nonatomic) IBOutlet UILabel *readyA;

@end

@implementation DDTransInfoVC
- (instancetype)initWithNo:(NSString *)orderNo{
    self = [super init];
    if (self) {
        _orderNoS = orderNo;
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"物流信息";
    self.automaticallyAdjustsScrollViewInsets = YES;
     [_transInfoTable registerNib:[UINib nibWithNibName:@"TransDetailCell" bundle:nil] forCellReuseIdentifier:@"cellTD"];
//    _transInfoTable.estimatedSectionHeaderHeight = 0;
//    _transInfoTable.estimatedSectionFooterHeight = 10;
    _transInfoTable.rowHeight = UITableViewAutomaticDimension;
    [self transR];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark --tabel--

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TransDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTD"];
    DDSubInfo *infos = _transInfo.deliveryInfos[indexPath.row];
    cell.transInfo.text = [NSString stringWithFormat:@"%.2f吨商品%@",infos.qty,infos.deliveryStatus];
    cell.dateATime.text = [self toDateString:infos.postTime];
        if (indexPath.row == 0) {
            cell.topItemView.hidden = NO;
            cell.normalItemView.hidden = YES;
            cell.lastItemView.hidden = YES;
            
        }else if (indexPath.row == _transInfo.deliveryInfos.count - 1){
            cell.topItemView.hidden = YES;
            cell.normalItemView.hidden = YES;
            cell.lastItemView.hidden = NO;
            
        }else{
            cell.topItemView.hidden = YES;
            cell.normalItemView.hidden = NO;
            cell.lastItemView.hidden = YES;
            
        }
        return cell;
        
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _transInfo.deliveryInfos.count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (void)transR{
    //    [WToast showWithTextCenter:@"功能暂未开放"];
    //    return;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DDTransRequest *request = [DDTransRequest Request];
    request.orderId = _orderNoS;
//    request.mainOrderNo = @"3317183782756352001";
    request.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];

    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSuccess) {
            DDTransInfo *transInfo = [DDTransInfo objectWithKeyValues:result.allDic];
            _transInfo = transInfo;
            [_transInfoTable reloadData];
            _sendaA.text = [NSString stringWithFormat:@"已发货:%.2f吨",_transInfo.sendQty];
            _buyA.text = [NSString stringWithFormat:@"购买数量:%.2f吨",_transInfo.qty];
            _readyA.text = [NSString stringWithFormat:@"d待发货:%.2f吨",_transInfo.qty-_transInfo.sendQty];

        }else{
            [WToast showWithTextCenter:result.message];
        }
    }];
}


- (NSString *)toDateString:(long)longDate{
    NSDate*timeDate = [[NSDate alloc]initWithTimeIntervalSince1970:longDate/1000.0];
    
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    
    dateFormatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    
    return [dateFormatter stringFromDate:timeDate];
}
@end
