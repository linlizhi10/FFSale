//
//  FFCustomerRequest.h
//  FFSales
//
//  Created by lin on 2018/6/21.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "Request.h"

@interface FFCustomerRequest : Request
@property (nonatomic, copy) NSString *keyword; //
@property (nonatomic, copy) NSString *accessToken; //
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int size;
@end
