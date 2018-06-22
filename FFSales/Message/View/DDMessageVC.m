//
//  DDMessageVC.m
//  FFSales
//
//  Created by lin on 2018/5/30.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "DDMessageVC.h"
#import "MessageCell.h"
#import "FFMessageReqeust.h"
#import "MessageModel.h"
#import "FFMessageListVC.h"
#import "DDStringUtil.h"
#import "UITabBar+badge.h"
@interface DDMessageVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *messageTable;
@property (strong, nonatomic) NSMutableArray *arrMeesage;
@property (assign, nonatomic) int pageSize;
@property (assign, nonatomic) int currentPage;
@end

@implementation DDMessageVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self dataLoadCust];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.tabBarController.tabBar hideBadgeOnItemIndex:1];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    _currentPage = 1;
    _pageSize = 10;
    [_messageTable registerNib:[UINib nibWithNibName:@"MessageCell" bundle:nil] forCellReuseIdentifier:@"cellMess"];
//    [self dataLoadCust];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _arrMeesage.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MessageCell *productCell = [tableView dequeueReusableCellWithIdentifier:@"cellMess"];
    MessageHomeItemModel *item = _arrMeesage[indexPath.row];
    NSString *image = @"icon-dd";

    if ([item.type isEqualToString:@"ORDER"]) {
        productCell.flagTitle.text = @"订单";
    }else{
        image = @"icon-shsrxx";
        productCell.flagTitle.text = @"资金";

    }
    
    productCell.flagImage.image = Img(image);
    
    productCell.number.hidden = !(item.unReadNum.intValue > 0);
    productCell.number.text = item.unReadNum;
    productCell.content.text = item.lastMessage;
    productCell.time.text = [DDStringUtil toDateTimeString:item.lastMessageDate];
    return productCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str  = @"ORDER";
    if (indexPath.row == 1) {
        str = @"FUND";
    }
    FFMessageListVC *listVC = [[FFMessageListVC alloc] initWithNo:str];
    listVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listVC animated:YES];
}
- (void)dataLoadCust{
    _arrMeesage = [[NSMutableArray alloc] init];

    WS(ws);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FFMessageHomeReqeust *request = [FFMessageHomeReqeust Request];
    request.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_messageTable.footer endRefreshing];
        
        
        if (isSuccess) {
            MessageHomeModel *model = [MessageHomeModel objectWithKeyValues:result.allDic];
            [_arrMeesage addObjectsFromArray:model.list];
            int number = 0;
            for (MessageHomeItemModel *item in model.list) {
                number+=item.unReadNum.intValue;
            }
            if (number > 0) {
                if (number > 99) {
                    number = 99;
                }
                [ws.tabBarController.tabBar showBadgeOnItemIndex:1 withNumber:number];

            }else{
                [ws.tabBarController.tabBar hideBadgeOnItemIndex:1];

            }
            [_messageTable reloadData];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [WToast showWithTextCenter:result.message];
        }
    }];
}
- (void)addPage{
    _currentPage++;
    [self dataLoadCust];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
