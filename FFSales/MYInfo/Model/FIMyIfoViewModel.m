//
//  FIMyIfoViewModel.m
//  finance
//
//  Created by lin on 17/5/9.
//  Copyright © 2017年 李传政. All rights reserved.
//

#import "FIMyIfoViewModel.h"
#import "FIContentModel.h"
#import "FIUser.h"
@implementation FIMyIfoViewModel
+ (NSArray *)infoContentArray{
    NSMutableArray *contentArr = [[NSMutableArray alloc] init];
    FIContentModel *content1 = [[FIContentModel alloc] init];
    content1.imageName = @"icon-rwpm";
    content1.contentTitle = @"任务排名";
    content1.contentSubtitle = @"我的年度任务和经销商排名";
    
    FIContentModel *content2 = [[FIContentModel alloc] init];
    content2.imageName = @"icon-zjdz";
    content2.contentTitle = @"资金对账";
    content2.contentSubtitle = @"本月未对账";
    
    FIContentModel *content3 = [[FIContentModel alloc] init];
    content3.imageName = @"icon-kfdh";
    content3.contentTitle = @"客服电话";
    content3.contentSubtitle = @"400-800-8888";
   
    
    FIContentModel *content4 = [[FIContentModel alloc] init];
    content4.imageName = @"icon-fpxx";
    content4.contentTitle = @"发票信息";
    content4.contentSubtitle = @"";
    content4.hideArrow = NO;
    
    FIContentModel *content5 = [[FIContentModel alloc] init];
    content5.imageName = @"icon-ytqh";
    content5.contentTitle = @"云图取货";
    content5.contentSubtitle = @"";
    
    
    
    FIContentModel *content9 = [[FIContentModel alloc] init];
    content9.imageName = @"icon-dlmasz";
    content9.contentTitle = @"安全设置";
    content9.contentSubtitle = @"";
    
    FIContentModel *content6 = [[FIContentModel alloc] init];
    content6.imageName = @"icon-cesj";
    content6.contentTitle = @"修改商家资料";
    
    content6.contentSubtitle = @"";
    
    FIContentModel *content7 = [[FIContentModel alloc] init];
    content7.imageName = @"icon-bzzx";
    content7.contentTitle = @"帮助中心";
    content7.contentSubtitle = @"";
    
    FIContentModel *content8 = [[FIContentModel alloc] init];
    content8.imageName = @"icon-kffw";
    content8.contentTitle = @"客服服务";
    content8.contentSubtitle = @"";
    
    [contentArr addObject:content1];
//    [contentArr addObject:content2];
    [contentArr addObject:content3];
    [contentArr addObject:content4];
    [contentArr addObject:content5];

    return contentArr;
}

@end
