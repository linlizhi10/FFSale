//
//  FFHomeRequest.h
//  FFSales
//
//  Created by lin on 2018/6/1.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "Request.h"
//
@interface FFHomeBannerRequest : Request
@property (nonatomic, copy) NSString *accessToken; //

@end
@interface FFHomeBrandRequest : Request
@property (nonatomic, copy) NSString *accessToken; //
@property (nonatomic, copy) NSString *levels; //级别(1:品牌,2:品系,3:品类,4:大类)
@end
@interface FFHomeRecentlyRequest : Request
@property (nonatomic, copy) NSString *accessToken; //
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int size;

@end
@interface FFHomeLikeRequest : Request
@property (nonatomic, copy) NSString *accessToken; //
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int size;

@end


@interface FFEMPHomeRequest : Request
@property (nonatomic, copy) NSString *accessToken; //

@end
