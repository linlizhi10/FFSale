//
//  MainTab.h
//  b2bManager
//
//  Created by 李传政 on 17/5/5.
//  Copyright © 2017年 李传政. All rights reserved.
//

#import <UIKit/UIKit.h>


#if NS_BLOCKS_AVAILABLE
typedef void (^LoginCallBackBlock)(BOOL isLoginSuccess);
#endif


@interface MainTab : UITabBarController

+ (MainTab *)shareInstance;

//未登录状态下，调用登录界面
- (void)showLoginViewWithBlock:(LoginCallBackBlock)_callBack;

- (void)showForgetViewWithBlock:(LoginCallBackBlock)_callBack;

//获取上次点击tab的index
- (NSInteger)getLastIndexViewController;
@end
