//
//  FFMHomeRequest.h
//  FFSales
//
//  Created by lin on 2018/6/7.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "Request.h"

@interface FFMHomeRequest : Request
@property (nonatomic, copy) NSString *accessToken; //

@end
@interface FFMPersonInfoRequest : Request
@property (nonatomic, copy) NSString *accessToken; //
@property (nonatomic, copy) NSString *custId; //

@end
@interface FFInvoiceRequest : Request
@property (nonatomic, copy) NSString *accessToken; //

@end

@interface FFTaskRequest : Request
@property (nonatomic, copy) NSString *accessToken; //
@property (nonatomic, assign) int taskListType; //

@end
