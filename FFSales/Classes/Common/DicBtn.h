//
//  DicBtn.h
//  DaDong
//
//  Created by 林立志 on 2018/5/7.
//  Copyright © 2018年 WintrueTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DicBtn : UIButton
@property (strong, nonatomic) NSString *titleKey;
@property (strong, nonatomic) NSDictionary *dic;
@property (assign, nonatomic) NSInteger indexSection;
@end
