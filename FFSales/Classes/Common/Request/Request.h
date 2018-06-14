//
//  Request.h
//  KYiOS
//
//  Created by mini珍 on 15/9/14.
//  Copyright (c) 2015年 mini珍. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


@class NetworkModel;

#if NS_BLOCKS_AVAILABLE
typedef void (^RequestCallBackBlock)(BOOL isSuccess,NetworkModel * result);
#endif

@interface Request : NSObject
@property(nonatomic,strong)NSString *HOST;//域名
@property(nonatomic,strong)NSString *PATH;//请求路径
@property(nonatomic,strong)NSString *METHOD;//提交方式
@property(nonatomic,strong)NSMutableDictionary *httpHeaderFields;//Http头参数设置
@property(nonatomic,strong)NSDictionary *params; //使用字典参数
@property(nonatomic,assign)NSTimeInterval timeoutInterval;//默认是60S
@property(nonatomic,strong)NSDictionary *requestFiles_Upload; //上传文件字典
#pragma mark ----lin 添加分页内容，放在头里
@property (copy, nonatomic) NSString *pageSize; //每页数量
@property (copy, nonatomic) NSString *currentPage; //当前页
+(id)Request;
- (void)startCallBack:(RequestCallBackBlock)_callBack;
@end

@interface  NetworkModel : NSObject
@property (nonatomic,strong)NSString *status;//返回状态值
@property (nonatomic,strong)NSString *message;//返回成功或失败消息
@property (nonatomic,strong)NSDictionary *allDic;//返回所有返回值jsondic
@property (nonatomic,strong)id data;//返回值获取
@property (nonatomic,assign)BOOL isArray;
@property (nonatomic,assign)BOOL isNoData;
@property (nonatomic,assign)BOOL isJsonError;
@property (nonatomic,assign) NSInteger totalRecord;
- (instancetype)initWithJsonData : (NSData *)_jsonData;
- (instancetype)initWithDictionary : (NSDictionary *)_dictionary;
@end
