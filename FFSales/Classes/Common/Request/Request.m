//
//  Request.m
//  KYiOS
//
//  Created by mini珍 on 15/9/14.
//  Copyright (c) 2015年 mini珍. All rights reserved.
//

#import "Request.h"
#import "DDStringUtil.h"
#import "MainTab.h"
@implementation Request

+(id)Request{
    return [[self alloc]initRequest];
}

-(id)initRequest{
    self = [self init];
    if(self){
        [self loadRequest];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if(self){
        [self loadRequest];
    }
    return self;

}
-(void)loadRequest{
    self.params = [NSDictionary dictionary];
    self.requestFiles_Upload = [NSDictionary dictionary];
    self.httpHeaderFields =[NSMutableDictionary dictionary];
}
- (NSString *)signString{
    NSMutableArray *arrParam = [[NSMutableArray alloc] init];
    if (self.params.count>0) {
        for (int i = 0; i<self.params.count; i++) {
            NSString *strValue = [NSString stringWithFormat:@"%@",[self.params.allValues objectAtIndex:i]];
            if (strValue.length > 0) {
                NSString *strTemp = [NSString stringWithFormat:@"%@=%@",[self.params.allKeys objectAtIndex:i],[self.params.allValues objectAtIndex:i]];
                [arrParam addObject:strTemp];
            }
           
            }
        }
    
    NSArray *result = [arrParam sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2]; //升序
    }];
    
    NSMutableString *readyString = [[NSMutableString alloc] initWithString:@""];
    if (result.count>0) {
        for (int i = 0; i<result.count; i++) {
            if (i == 0) {
                NSString *strTemp = [NSString stringWithFormat:@"%@",result[i]];
                [readyString appendString:strTemp];
            }else{
                NSString *strTemp = [NSString stringWithFormat:@"&%@",result[i]];
                [readyString appendString:strTemp];
            }
            
        }
    }
    if (readyString.length > 0) {
        [readyString appendString:[NSString stringWithFormat:@"&%@",ClientSecret]];
    }
    NSLog(@"----->before sign is %@",readyString);
    return [DDStringUtil md5Endode32:readyString];
}


- (void)startCallBack:(RequestCallBackBlock)_callBack{
    
    //因为请求头加密要用到参数里面的数据，所以每次都要重新加密
    self.httpHeaderFields = [NSMutableDictionary dictionaryWithDictionary:@{@"sign":[self signString]}];
//    if(self.currentPage && [self.currentPage intValue] > 0){
//        [self.httpHeaderFields setObject:self.pageSize?:@"20" forKey:@"pageSize"];
//        [self.httpHeaderFields setObject:self.currentPage forKey:@"currentPage"];
//    }
#ifdef DEBUG
    
//    NSLog(@"---- httpHeaderFields : %@ ----",self.httpHeaderFields);

#endif
    //
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    //AFHTTPRequestSerializer            二进制格式
    
    //AFJSONRequestSerializer            JSON
    
    //AFPropertyListRequestSerializer    PList(是一种特殊的XML,解析起来相对容易)
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    //**HTTPS请求专属**
//    manager.securityPolicy = securityPolicy;
    //**

    //请求头
    if (self.httpHeaderFields.count>0) {
        for (NSString * key in self.httpHeaderFields.allKeys) {
            [manager.requestSerializer setValue:[self.httpHeaderFields objectForKey:key] forHTTPHeaderField:key];
        }
    }
    //超时时间
    [manager.requestSerializer setTimeoutInterval:20];
    
    //请求地址
    NSString * url;
    if (self.HOST) {
        url = [NSString stringWithFormat:@"%@%@",self.HOST,self.PATH];
    }else{
        url = [NSString stringWithFormat:@"%@%@",ServerAddressURL,self.PATH];
    }
#ifdef DEBUG
    NSMutableString * str = [NSMutableString stringWithString:url];
    if (self.params.count>0) {
        for (int i = 0; i<self.params.count; i++) {
            if (i == 0) {
                [str appendString:[NSString stringWithFormat:@"?%@=%@",[self.params.allKeys objectAtIndex:i],[self.params.allValues objectAtIndex:i]]];
            }else{
                [str appendString:[NSString stringWithFormat:@"&%@=%@",[self.params.allKeys objectAtIndex:i],[self.params.allValues objectAtIndex:i]]];
            }
        }
        NSLog(@"\n----RequestURL GET URL \n%@\n  -----------",str);
    }
#endif
    __block Request *ws = self;    //请求正文
    if ([self.METHOD isEqualToString:@"GET"]) {
        [manager GET:url parameters:self.params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"res is ---->%@",responseObject);
            [ws sucessDataDeal:responseObject CallBack:_callBack];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error is %@",error);
            NetworkModel *nm = [[NetworkModel alloc] init];
            nm.message = @"网络状况不佳";
            _callBack(NO,nm);
        }];
    }else if([self.METHOD isEqualToString:@"POST"]){
        //需要上传图片流
        if (self.requestFiles_Upload.count >0) {
        }else{
            //纯数据
            
            [manager POST:url parameters:self.params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"res is ---->%@",responseObject);
                [ws sucessDataDeal:responseObject CallBack:_callBack];

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //
                NSLog(@"error is %@",error);
                NetworkModel *nm = [[NetworkModel alloc] init];
                nm.message = @"网络状况不佳";
                _callBack(NO,nm);
            }];
        }
    }else if ([self.METHOD isEqualToString:@"PUT"]){
        [manager PUT:url parameters:self.params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"res is ---->%@",responseObject);
            [ws sucessDataDeal:responseObject CallBack:_callBack];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error is %@",error);
            NetworkModel *nm = [[NetworkModel alloc] init];
            nm.message = @"网络状况不佳";
            _callBack(NO,nm);
        }];
    }
}
- (void)sucessDataDeal:(id)responseObject CallBack:(RequestCallBackBlock)_callBack{
    NetworkModel *nm = [[NetworkModel alloc] initWithJsonData:responseObject];
    if ([nm.status isEqualToString:@"0"]) {
        _callBack(YES,nm);
    }else{
        _callBack(NO,nm);
        if ([nm.status isEqualToString:@"401"]) {
            [self tokenFailed];
        }
    }
}
- (void)tokenFailed{
    [[MainTab shareInstance] showLoginViewWithBlock:^(BOOL isLoginSuccess) {
    }];
    
}

//token失效跳转
//- (void)tokenFaildMethodTipsMessage:(NSString *)message{
//    if ([FIUser shareUser].loginStatus == YES) {
//        //清除user数据
//        [FIUser clearUerInfo];
//        //阿里解绑 
//        [CloudPushSDK unbindAccount:^(CloudPushCallbackResult *res) {
//            //
//        }];
//    }
//    UINavigationController * loginNav = (UINavigationController *)[MainTab shareInstance].presentedViewController;
//
//    if (loginNav && [loginNav isKindOfClass:[FIGestureNavViewController class]]) {
//        [loginNav dismissViewControllerAnimated:YES completion:nil];
//    }
//    
//    
//    UINavigationController * nav = (UINavigationController *)[MainTab shareInstance].selectedViewController;
//
//    if ([MainTab shareInstance].selectedIndex == 0) {
//        [nav popToRootViewControllerAnimated:NO];
//    }else{
//        [nav popToRootViewControllerAnimated:NO];
//        [[MainTab shareInstance]setSelectedIndex:0];
//    }
//     [[NSNotificationCenter defaultCenter] postNotificationName:@"tokenFailed" object:nil];
//    
//    NSString *messageTitle = [NSString stringWithFormat:@"%@",message];
//    
//    //messageTitle == @"您还未登录";
////    if ([messageTitle isEqualToString:@"您还未登录"]) {return;}
//    
//    if ([[UIApplication sharedApplication].keyWindow isKindOfClass:NSClassFromString(@"_UIAlertControllerShimPresenterWindow")]) {
//        NSLog(@"alertView");
//        
//        UIWindow *keyWindow = [MainTab shareInstance].view.window;
//        [UICustomAlert showAlertTitle:nil andExpandMessage:messageTitle andCancelBtn:@"重置密码" andOtherBtn:@"重新登录" andTouchAction:^(NSInteger selectIndex) {
//            if (selectIndex == 1) {
//                [[MainTab shareInstance] showLoginViewWithBlock:^(BOOL isLoginSuccess) {
//                    //
//                }];
//            }else if (selectIndex == 0){
//            [[MainTab shareInstance] showForgetViewWithBlock:^(BOOL isLoginSuccess) {
//                
//            }];
//                
//            }
//        } andSuperShow:keyWindow];
//    }
//    else{
//        [UICustomAlert showAlertTitle:nil andExpandMessage:messageTitle andCancelBtn:@"重置密码" andOtherBtn:@"重新登录" andTouchAction:^(NSInteger selectIndex) {
//            if (selectIndex == 1) {
//                [[MainTab shareInstance] showLoginViewWithBlock:^(BOOL isLoginSuccess) {
//                    //
//                }];
//            }else if (selectIndex == 0){
//                [[MainTab shareInstance] showForgetViewWithBlock:^(BOOL isLoginSuccess) {
//                    
//                }];
//                
//            }
//        } andSuperShow:nil];
//    }
//}

//签名key失效
//- (void)resetSignKeyWith:(NSString *)key{
//    if (key) {
//        dispatch_async(dispatch_get_main_queue(), ^{
////            [FIBaseData share].skey = key;
//             [FISkeyManager share].skey = key;            
//        });
//    }
//}

@end


@implementation NetworkModel

- (instancetype)initWithDictionary : (NSDictionary *)_dictionary{
    self = [super init];
    if (self) {
        NSDictionary * dic = _dictionary;
        self.allDic = _dictionary;
        if (!dic || [dic count] <= 0) {
            self.isJsonError = YES;
            self.status = @"-1";
        }
        else{
            if ([dic objectForKey:@"status"] && [dic objectForKey:@"status"] != [NSNull null]) {
                
                    if ([dic objectForKey:@"message"]) {
                        self.status = [dic objectForKey:@"status"];

                    }else{
                        self.status = @"0";

                    }
                
            }else{
                self.status = @"0";
            }
        
            self.message = [dic objectForKey:@"message"]?:@"服务器错误";
            NSString *totalS = [NSString stringWithFormat:@"%@",[dic objectForKey:@"total"]];
            self.totalRecord = [totalS integerValue];
            
            self.data = [dic objectForKey:@"response_data"]?:nil;
            if (!self.data && [self.data count] <= 0) {
                self.isNoData = YES;
            }
            else if([self.data isKindOfClass:[NSArray class]]){
                self.isArray = YES;
            }
        }
    }
    return self;
}

- (instancetype)initWithJsonData : (NSDictionary *)_jsonData
{
    NSDictionary *dic = _jsonData;
    if (!dic || [dic count] <= 0) {
        self = [super init];
        self.isJsonError = YES;
        self.status = @"-1";
    }
    else{
        self = [self initWithDictionary:dic];
    }
    return self;
}



@end

