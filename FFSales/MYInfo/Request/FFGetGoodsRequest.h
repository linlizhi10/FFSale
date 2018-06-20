//
//  FFGetGoodsRequest.h
//  FFSales
//
//  Created by lin on 2018/6/20.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "Request.h"

@interface FFGetGoodsRequest : Request
@property (nonatomic, copy) NSString *note; //
@property (nonatomic, copy) NSString *accessToken; //
@end
@interface FFGetGoodsHistoryRequest : Request
@property (assign, nonatomic) int page; //
@property (assign, nonatomic) int size; //
@property (nonatomic, copy) NSString *accessToken; //
@end
@interface FFGetGoodsDRequest : Request
@property (nonatomic, copy) NSString *pickupId; //
@property (nonatomic, copy) NSString *accessToken; //
@end
