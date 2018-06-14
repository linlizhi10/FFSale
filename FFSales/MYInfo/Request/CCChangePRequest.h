//
//  CCChangePRequest.h
//  FFSales
//
//  Created by lin on 2018/5/30.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "Request.h"

@interface CCChangePRequest : Request
@property (nonatomic, copy) NSString *accessToken; //
@property (nonatomic, copy) NSString *oldPassword; //
@property (nonatomic, copy) NSString *comPassword; //
@end
