//
//  UITabBar+badge.h
//  FFSales
//
//  Created by lin on 2018/6/22.
//  Copyright © 2018年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)
- (void)showBadgeOnItemIndex:(int)index withNumber:(int)number;
- (void)hideBadgeOnItemIndex:(int)index;
@end
