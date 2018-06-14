//
//  DDCommonWebVC.m
//  DaDong
//
//  Created by 李传政 on 2018/5/10.
//  Copyright © 2018年 WintrueTeam. All rights reserved.
//

#import "DDCommonWebVC.h"

@interface DDCommonWebVC ()
{
    UIWebView * webView;
    
}
@end

@implementation DDCommonWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _Ptitle;
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]];
    [self.view addSubview: webView];
    [webView setBackgroundColor:[UIColor clearColor]];
    [webView setOpaque:NO];
    [webView loadRequest:request];
    
    
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction{
    if ([webView canGoBack]) {
        [webView goBack];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
