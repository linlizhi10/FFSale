//
//  Header.h
//  QuickFlip
//
//  Created by 李传政 on 15-3-16.
//  Copyright (c) 2015年 李传政. All rights reserved.
//

#ifndef JR_PrefixHeader_pch
#define JR_PrefixHeader_pch
#define ClientSecret @"AHDTNCa6tss3rMrrnLBOiH9pzC1vr0Nf"
/*
 ********UI**********
 */
//图片
#define Img(a) [UIImage imageNamed:a]
//尺寸
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define IS_IPHONE4 SCREEN_HEIGHT==480
#define IS_IPHONE5 SCREEN_HEIGHT==568
#define IS_IPHONE6 SCREEN_HEIGHT==667
#define IS_IPHONE6PS SCREEN_HEIGHT==736

//颜色
//转换16位色值
#define RGBCOLORV(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:1.0]

#define RGBColor(R,G,B) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1]
#define RGBAColor(R,G,B,A) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]

//字体

#define Font(f) [UIFont systemFontOfSize:(f)]
#define BoldFont(f) [UIFont boldSystemFontOfSize:(f)]

/*
 ********其他**********
 */
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define WeakSelf __weak __typeof(&*self)

//日志输出
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif


//#define ServerAddressURL @"http://172.31.255.13/interf-rf"
//测试
#define ServerAddressURL @"http://10.13.3.202:8080/npk"
#define ServerH5AddressURL @"http://uatdaogou.dusto.cn"

//正式
//#define ServerAddressURL @"http://api.dusto.cn/interf-rf"
//#define ServerH5AddressURL @"http://daogou.dusto.cn"


//html 地址域
#define WebAddressURL @"http://uatdaogou.dusto.cn/#/"
//程序初次进入
#define APPFirstLoadInKey @"APPFirstLoadInKey"

//系统版本号
#define CurrentSystemVersion [[UIDevice currentDevice].systemVersion floatValue]

//IOS 11 新增宏
//if (@available(iOS 11.0, *)) { }
#define StatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
#define NavigationBarHeight 44
#define VerticalLayoutStartHeight (StatusBarHeight + NavigationBarHeight)
#define IS_IPhoneX [[UIScreen mainScreen] bounds].size.height == 812

typedef NS_ENUM(NSInteger, NSOrderType) {
    NSOrderTypeAll      = 0,    //
    NSOrderTypeForCustomer    = 1,    // 代课
    NSOrderTypeOnline    = 2,    // 线上
    NSOrderTypeOffline    = 3,    // 门店
    
} ;
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#endif
#import <MBProgressHUD.h>
#import "WToast.h"
#import <UIImageView+WebCache.h>
#import <MJExtension.h>
#import "CALayer+Anim.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import <MJRefresh.h>
#import "UIView+Frame.h"
