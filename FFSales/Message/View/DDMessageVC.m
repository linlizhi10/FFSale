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
@interface DDMessageVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *messageTable;
@property (strong, nonatomic) NSMutableArray *arrMeesage;
@property (assign, nonatomic) int pageSize;
@property (assign, nonatomic) int currentPage;
@end

@implementation DDMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    _arrMeesage = [[NSMutableArray alloc] init];
    _currentPage = 1;
    _pageSize = 10;
    [_messageTable registerNib:[UINib nibWithNibName:@"MessageCell" bundle:nil] forCellReuseIdentifier:@"cellMess"];
    [self dataLoadCust];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MessageCell *productCell = [tableView dequeueReusableCellWithIdentifier:@"cellMess"];
    NSString *image = @"icon-dd";
    productCell.flagTitle.text = @"订单";
    if (indexPath.row == 1) {
        image = @"icon-shsrxx";
        productCell.flagTitle.text = @"资金";

    }
    productCell.flagImage.image = Img(image);
    
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
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FFMessageReqeust *request = [FFMessageReqeust Request];
    request.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    request.type = @"";
    request.page = _currentPage;
    request.size = _pageSize;
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_messageTable.footer endRefreshing];
        
        
        if (isSuccess) {
            MessageModel *model = [MessageModel objectWithKeyValues:result.allDic];
            [_arrMeesage addObjectsFromArray:model.list];
            
            
            if (model.list.count == 0) {
                [_messageTable.footer endRefreshingWithNoMoreData];
            }
            if (_arrMeesage.count == result.totalRecord) {
                [_messageTable.footer endRefreshingWithNoMoreData];
                
            }
            if (_currentPage == [[result.allDic objectForKey:@"pages"] intValue]) {
                [_messageTable.footer endRefreshingWithNoMoreData];
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
