//
//  FFSearchVC.m
//  FFSales
//
//  Created by lin on 2018/6/5.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFSearchVC.h"
#import "FFProductDetailRequest.h"
#import "FFProductModel.h"
#import "FFProductDetailVC.h"
@interface FFSearchVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *sectionHeaser;
@property (strong, nonatomic) IBOutlet UIView *sectionFooter;
- (IBAction)clearHistory:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) FFProductListModel *model;
@property (weak, nonatomic) IBOutlet UITextField *contentTF;
- (IBAction)backAction:(id)sender;
@property (strong, nonatomic) NSMutableArray *arrHistory;
@property (strong, nonatomic) NSMutableArray *arrPr;

@property (nonatomic, assign) BOOL searchBegin;
@property (weak, nonatomic) IBOutlet UITableView *listTable;
@property (assign, nonatomic) int pageSize;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (assign, nonatomic) int currentPage;
@end

@implementation FFSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = 1;
    _pageSize = 20;
    _listTable.footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(addPage)];
    _arrPr = [[NSMutableArray alloc] init];

    self.automaticallyAdjustsScrollViewInsets = NO;
    _contentTF.returnKeyType = UIReturnKeySearch;
    _contentTF.delegate = self;
    [_contentTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    NSString *keyString = [[NSUserDefaults standardUserDefaults] stringForKey:@"phone"];
    NSData *historyData = [[NSUserDefaults standardUserDefaults] objectForKey:keyString];
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:historyData];
    if (arr.count > 0) {
        _arrHistory = [NSMutableArray arrayWithArray:arr];
    }else{
        _arrHistory = [[NSMutableArray alloc] init];
    }
    [self searchRequest];
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    self.headerView.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    if (kDevice_Is_iPhoneX) {
        self.headerView.frame = CGRectMake(0, 44, SCREEN_WIDTH, 44);
        _topConstraint.constant = 88;
    }
    [self.view addSubview:self.headerView];
    
    [self addObserver:self forKeyPath:@"searchBegin" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeObserver:self forKeyPath:@"searchBegin"];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textFieldDidChange:(UITextField *)textField{
    if ([textField.text isEqualToString:@""]) {
        self.searchBegin = NO;
        //        NSLog(@"no");
        
    }else{
        self.searchBegin = YES;
//        NSLog(@"text is %@,",textField.text);
//        [self getSearchResult:[textField.text pureString]];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    _currentPage = 1;
    [self searchRequest];
    return YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_searchBegin) {
        return _arrPr.count;

    }
    return _arrHistory.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellI"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellI"];
    }
    if (_searchBegin) {
        FFProductModel *product = _arrPr[indexPath.row];
        cell.textLabel.text = product.name;
    }else{
        //倒序
        cell.textLabel.text = _arrHistory[_arrHistory.count - 1 - indexPath.row];
    }
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (!_searchBegin) {
        return 70;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (!_searchBegin) {
        return 40;
    }
    return 1;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        if (_searchBegin) {
            return nil;
        }
//        _sectionHeaser.frame = CGRectMake(0, 40, SCREEN_WIDTH, 40);
//        return _sectionHeaser;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 16, 16)];
        imageV.image = [UIImage imageNamed:@"imgssls"];
        [view addSubview:imageV];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, SCREEN_WIDTH, 20)];
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"搜索历史";
        [view addSubview:label];
        return view;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        if (_searchBegin) {
            return nil;
        }
        _sectionFooter.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        return _sectionFooter;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_searchBegin) {
        FFProductModel *prodcutI = _arrPr[indexPath.row];
        FFProductDetailVC *inventoryVC = [[FFProductDetailVC alloc] initWithId:prodcutI.materialId];
        [self.navigationController pushViewController:inventoryVC animated:YES];
    }else{
        _contentTF.text = _arrHistory[_arrHistory.count - 1 - indexPath.row];
        _searchBegin = YES;
        [self searchRequest];
    }
    
    
}

- (IBAction)clearHistory:(id)sender {
    [_arrHistory removeAllObjects];
    [_listTable reloadData];
    NSString *keyString = [[NSUserDefaults standardUserDefaults] stringForKey:@"phone"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:keyString];
}
- (void)searchRequest{
    if ([_arrHistory containsObject:_contentTF.text]) {
        [_arrHistory removeObject:_contentTF.text];
        [_arrHistory addObject:_contentTF.text];
    }else{
        if (_contentTF.text.length>0) {
            [_arrHistory addObject:_contentTF.text];

        }
        
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_arrHistory];
    NSString *keyString = [[NSUserDefaults standardUserDefaults] stringForKey:@"phone"];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:keyString];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FFProductListRequest *request = [FFProductListRequest Request];
    request.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    request.page = _currentPage;
    request.size = _pageSize;
    request.keyword = _contentTF.text;
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_listTable.footer endRefreshing];
        if (isSuccess) {
            
            FFProductListModel *model = [FFProductListModel objectWithKeyValues:result.allDic];
            [_arrPr addObjectsFromArray:model.list];
            [_listTable reloadData];
            if (model.list.count == 0) {
                [_listTable.footer endRefreshingWithNoMoreData];
            }
            if (_arrPr.count == result.totalRecord) {
                [_listTable.footer endRefreshingWithNoMoreData];
                
            }
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [WToast showWithTextCenter:result.message];
        }
    }];
    
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"searchBegin"]) {
        BOOL searchBegin = [[change objectForKey:@"new"] boolValue];
        if (searchBegin == YES) {
           
        }else{
            
        }
        
    }
}
- (void)addPage{
    _currentPage++;
    [self searchRequest];
}
@end
