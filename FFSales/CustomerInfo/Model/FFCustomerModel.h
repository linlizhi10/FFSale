//
//  FFCustomerModel.h
//  FFSales
//
//  Created by lin on 2018/6/21.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "Model.h"
@interface FFCustomerItemModel : Model
@property (copy, nonatomic) NSString *custId;//
@property (copy, nonatomic) NSString *custName;//
@property (copy, nonatomic) NSString *phone;//

@property (copy, nonatomic) NSString *reviewStatus;//审核状态：录入(HAS_RECORDED)，待审核(WAIT_AUDIT)，已审核(HAS_AUDIT)
@property (copy, nonatomic) NSString *custStatus;//客户状态：新增ADD_NEW，正常:NORMAL，失效:EFFECT，FREEZE：冻结,TERMINAT:终止合作
@property (copy, nonatomic) NSString *sapNo;//
@property (strong, nonatomic) NSArray<NSString *> *brandNames;
@end

@interface FFCustomerModel : Model
@property (strong, nonatomic) NSArray<FFCustomerItemModel *> *list;

@end
