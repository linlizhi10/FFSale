//
//  DDLoginVC.h
//  DaDong
//
//  Created by 李传政 on 2018/2/26.
//  Copyright © 2018年 WintrueTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^LoginCallBackBlock)(BOOL isLoginSuccess);

@interface DDLoginVC : UIViewController
- (instancetype)initWithSource:(int)source block:(LoginCallBackBlock)block;
@end
