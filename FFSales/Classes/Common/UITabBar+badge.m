//
//  UITabBar+badge.m
//  FFSales
//
//  Created by lin on 2018/6/22.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "UITabBar+badge.h"
#define TabbarItemNums 3.0

@implementation UITabBar (badge)
//显示红点
- (void)showBadgeOnItemIndex:(int)index withNumber:(int)number{
    [self removeBadgeOnItemIndex:index];
    //新建小红点
    UILabel *bview = [[UILabel alloc]init];
    bview.tag = 888+index;
    bview.layer.cornerRadius = 8;
    bview.clipsToBounds = YES;
    bview.backgroundColor = [UIColor redColor];
    CGRect tabFram = self.frame;
    bview.text = [NSString stringWithFormat:@"%d",number];
    bview.font = [UIFont systemFontOfSize:11];
    bview.textColor = [UIColor whiteColor];
    float percentX = (index+0.6)/TabbarItemNums;
    CGFloat x = ceilf(percentX*tabFram.size.width);
    CGFloat y = ceilf(0.1*tabFram.size.height);
    bview.frame = CGRectMake(x, y, 16, 16);
    [self addSubview:bview];
    [self bringSubviewToFront:bview];
}

//隐藏红点
-(void)hideBadgeOnItemIndex:(int)index{
    [self removeBadgeOnItemIndex:index];
}
//移除控件
- (void)removeBadgeOnItemIndex:(int)index{
    for (UIView*subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

@end
