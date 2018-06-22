//
//  FFGetGoodsVC.m
//  FFSales
//
//  Created by lin on 2018/6/20.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFGetGoodsVC.h"
#import "FFGetGoodsRequest.h"
#import "FFGetGoodsHistory.h"
@interface FFGetGoodsVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *placeHoder;
- (IBAction)confirmAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation FFGetGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"云图提货";
    
    UIButton *but1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    but1.frame =CGRectMake(0,0, 60, 44);
    
    [but1 setTitle:@"取货记录" forState:UIControlStateNormal];
    [but1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    but1.titleLabel.font = [UIFont systemFontOfSize:14];
    [but1 addTarget:self action:@selector(historyAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem  *barBut1 = [[UIBarButtonItem alloc] initWithCustomView:but1];
    
    self.navigationItem.rightBarButtonItem = barBut1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -text delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{
    if (![text isEqualToString:@""]){
        
        _placeHoder.hidden = YES;
        //        _button.enabled = YES;
        //        _button.backgroundColor = BlueTintColor;
        
    }
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1){
        
        _placeHoder.hidden = NO;
        //        _button.enabled = NO;
        //        _button.backgroundColor = [UIColor lightGrayColor];
    }
    
    
    
    return YES;
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _placeHoder.hidden = YES;
}
- (void)confirmAction:(id)sender{
    [self uploadAdvice];
}
- (void)uploadAdvice{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FFGetGoodsRequest *request = [FFGetGoodsRequest Request];
    request.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    request.note = _textView.text;
    [request startCallBack:^(BOOL isSuccess, NetworkModel *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (isSuccess) {
            [WToast showWithTextCenter:@"提交成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];;
            
            //                [MBProgressHUD showSuccess:@"短信验证码发送成功" toView:self.view];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            [WToast showWithTextCenter:result.message];
        }
    }];
}
- (void)historyAction{
    FFGetGoodsHistory *setVC = [[FFGetGoodsHistory alloc] init];
    [self.navigationController pushViewController:setVC animated:YES];
}

@end
