//
//  FFGetGoodsHistory.m
//  FFSales
//
//  Created by lin on 2018/6/20.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFGetGoodsHistory.h"
#import "FFGoodsHistoryCell.h"
#import "FFGetGoodsRequest.h"
#import "FFGoodsHistory.h"
#import "DDStringUtil.h"
#import "FFGetGoodsDVC.h"
@interface FFGetGoodsHistory ()
@property (weak, nonatomic) IBOutlet UITableView *hsitoryTable;
@property (strong, nonatomic) NSMutableArray *arrMMm;
@property (assign, nonatomic) int pageSize;
@property (assign, nonatomic) int currentPage;
@end

@implementation FFGetGoodsHistory

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"取货记录";
    _currentPage = 1;
    _pageSize = 10;
    _arrMMm = [[NSMutableArray alloc] init];

    [_hsitoryTable registerNib:[UINib nibWithNibName:@"FFGoodsHistoryCell" bundle:nil] forCellReuseIdentifier:@"cellGH"];
    _hsitoryTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addPage)];
    [self dataLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _arrMMm.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FFGoodsHistoryCell *productCell = [tableView dequeueReusableCellWithIdentifier:@"cellGH"];
    FFGoodsHistoryItem *model = _arrMMm[indexPath.row];
    productCell.title.text = [NSString stringWithFormat:@"%@ %@",model.custName,model.sapNo];
    productCell.note.text = model.note;
    productCell.time.text = [DDStringUtil toDateTimeString:model.createdTime];
    switch (model.status) {
        case -1:
        {
            productCell.statusl.text = @"驳回";
            productCell.statusl.textColor = [UIColor redColor];
            productCell.statusl.backgroundColor = RGBCOLORV(0xfbcaca);
        }
            break;
        case 0:
        {
            productCell.statusl.text = @"处理中";
            productCell.statusl.textColor = RGBCOLORV(0x61aa39);
            productCell.statusl.backgroundColor = RGBCOLORV(0xB9E6A1);
        }
            break;
        case 1:
        {
            productCell.statusl.text = @"已完成";
            productCell.statusl.textColor = RGBCOLORV(0x666666);
            productCell.statusl.backgroundColor = RGBCOLORV(0xE0E0E0);
        }
            break;
        default:
            break;
    }
    return productCell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FFGoodsHistoryItem *model = _arrMMm[indexPath.row];
    FFGetGoodsDVC *detailVC = [[FFGetGoodsDVC alloc] initWithNo:model.pickupId];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 106;
}
- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (void)dataLoad{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FFGetGoodsHistoryRequest *request = [FFGetGoodsHistoryRequest Request];
    request.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    request.page = _currentPage;
    request.size = _pageSize;
   
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_hsitoryTable.footer endRefreshing];
        
        if (isSuccess) {
            FFGoodsHistory *model = [FFGoodsHistory objectWithKeyValues:result.allDic];
            [_arrMMm addObjectsFromArray:model.list];
            
            
            if (model.list.count == 0) {
                [_hsitoryTable.footer endRefreshingWithNoMoreData];
            }
            if (_arrMMm.count == result.totalRecord) {
                [_hsitoryTable.footer endRefreshingWithNoMoreData];
                
            }
            if (_currentPage == [[result.allDic objectForKey:@"pages"] intValue]) {
                [_hsitoryTable.footer endRefreshingWithNoMoreData];
            }
            [_hsitoryTable reloadData];
            
            
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [WToast showWithTextCenter:result.message];
        }
    }];
}
- (void)addPage{
    _currentPage++;
    [self dataLoad];
}
@end
