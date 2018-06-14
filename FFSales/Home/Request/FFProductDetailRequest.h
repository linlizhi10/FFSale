//
//  FFProductDetail.h
//  FFSales
//
//  Created by lin on 2018/6/4.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "Request.h"

@interface FFProductDetailRequest : Request
@property (nonatomic, copy) NSString *materialId; //
@property (nonatomic, copy) NSString *accessToken; //

@end
@interface FFProductListRequest : Request
@property (nonatomic, copy) NSString *brand; //
@property (nonatomic, copy) NSString *accessToken; //
@property (nonatomic, copy) NSString *strain; //
@property (nonatomic, copy) NSString *keyword; //
@property (nonatomic, assign) int page; //
@property (nonatomic, assign) int size; //
@end
