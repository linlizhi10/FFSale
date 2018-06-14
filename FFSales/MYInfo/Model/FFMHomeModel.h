//
//  FFMHomeModel.h
//  FFSales
//
//  Created by lin on 2018/6/7.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "Model.h"

@interface FFMHomeModel : Model
@property (copy, nonatomic) NSString *custId; //
@property (copy, nonatomic) NSString *custName; //
@property (copy, nonatomic) NSString *sapNo; //
@property (copy, nonatomic) NSString *customerType; //
@property (copy, nonatomic) NSString *custAvator; //
@property (assign, nonatomic) float accountAvailable; //
@property (assign, nonatomic) float marginAvailable; //
@property (assign, nonatomic) float rebateAvailable; //
@property (assign, nonatomic) int deliveryOrderNum; //
@property (assign, nonatomic) int waitAuditOrderNum; //
@property (assign, nonatomic) BOOL needCheckAccount; //

@end
