//
//  DicBtn.m
//  DaDong
//
//  Created by 林立志 on 2018/5/7.
//  Copyright © 2018年 WintrueTeam. All rights reserved.
//

#import "DicBtn.h"

@implementation DicBtn
- (void)setTitleKey:(NSString *)titleKey{
    _titleKey = titleKey;
    [self setTitle:[_dic objectForKey:_titleKey] forState:UIControlStateNormal];

}
- (void)setDic:(NSDictionary *)dic{
    _dic = dic;
    [self setTitle:[dic objectForKey:_titleKey] forState:UIControlStateNormal];
}

@end
