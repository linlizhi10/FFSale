//
//  FFrank.h
//  FFSales
//
//  Created by lin on 2018/6/19.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "Model.h"

@interface FFreachs : Model

@property (assign, nonatomic) int num;
@property (copy, nonatomic) NSString *area;//
@end
@interface FFareas : Model
@property (assign, nonatomic) int num;
@property (copy, nonatomic) NSString *area;//
@end


@interface FFmonth : Model

@property (assign, nonatomic) float shipments;
@property (strong, nonatomic) NSArray<FFareas *> *areas;
@end


@interface FFrank : Model
@property (assign, nonatomic) float yearTargetCoefficient;
@property (assign, nonatomic) float coefficient;

@property (strong, nonatomic) NSArray<FFreachs *> *reachs;
@property (strong, nonatomic) FFmonth  *month;
@property (strong, nonatomic) FFmonth  *quarter;
@property (strong, nonatomic) FFmonth  *year;


@end
