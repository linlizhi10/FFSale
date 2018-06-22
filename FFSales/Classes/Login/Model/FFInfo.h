//
//  FFInfo.h
//  FFSales
//
//  Created by lin on 2018/6/20.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "Model.h"
@interface FFInfoItem : Model
@property (copy, nonatomic) NSString *agentNumber;
@property (copy, nonatomic) NSString *name;

@end
@interface FFInfo : Model
@property (strong, nonatomic) NSArray<FFInfoItem *> *list;

@end

@interface FFGestureInfo : Model
@property (copy, nonatomic) NSString *code;
@property (copy, nonatomic) NSString *state;

@end
