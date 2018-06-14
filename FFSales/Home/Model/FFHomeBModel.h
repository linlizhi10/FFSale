//
//  FFHomeBModel.h
//  FFSales
//
//  Created by lin on 2018/6/1.
//  Copyright © 2018年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFHomeBModel : NSObject
@property (copy, nonatomic) NSString *img; //
@property (copy, nonatomic) NSString *levelName; //
@property (copy, nonatomic) NSString *type; //
@property (copy, nonatomic) NSString *value; //
@end
@interface FFHomeBAModel : NSObject
@property (strong, nonatomic) NSArray<FFHomeBModel *>*list;
@end
@interface FFHomeBrand : NSObject
@property (copy, nonatomic) NSString *brandId; //
@property (copy, nonatomic) NSString *levelName; //
@property (copy, nonatomic) NSString *levels; //
@property (copy, nonatomic) NSString *picUrl; //
@end
@interface FFHomeBrandA : NSObject
@property (strong, nonatomic) NSArray<FFHomeBrand *>*list;
@end
