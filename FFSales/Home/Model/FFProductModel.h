//
//  FFProductModel.h
//  FFSales
//
//  Created by lin on 2018/6/1.
//  Copyright © 2018年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFProductModel : NSObject
@property (copy, nonatomic) NSString *category; //
@property (copy, nonatomic) NSString *materialId; //
@property (copy, nonatomic) NSString *name; //
@property (copy, nonatomic) NSString *picUrl; //
@property (copy, nonatomic) NSString *policies; //
@property (copy, nonatomic) NSString *price; //
@end
@interface FFProductListModel : NSObject
@property (strong, nonatomic) NSArray<FFProductModel *>*list;

@end


@interface FFProductPropertiesModel : NSObject
@property (copy, nonatomic) NSString *nutrient; //
@property (copy, nonatomic) NSString *proportion; //
@property (copy, nonatomic) NSString *spec; //
@property (copy, nonatomic) NSString *color; //
@property (copy, nonatomic) NSString *brandName; //
@property (copy, nonatomic) NSString *prodGroupDesc; //
@end
@interface FFProductFactoryModel : NSObject
@property (copy, nonatomic) NSString *factoryId; //
@property (copy, nonatomic) NSString *factoryName; //
@property (copy, nonatomic) NSString *saleTun; //
@property (copy, nonatomic) NSString *price; //

@end

@interface FFProductDetailModel : NSObject
@property (copy, nonatomic) NSString *category; //
@property (copy, nonatomic) NSString *materialId; //
@property (copy, nonatomic) NSString *name; //
@property (copy, nonatomic) NSString *factory; //
@property (copy, nonatomic) NSString *strain; //
@property (copy, nonatomic) NSString *price; //
@property (copy, nonatomic) NSString *saleTun; //

@property (strong, nonatomic) FFProductPropertiesModel *properties;
@property (strong, nonatomic) NSArray<FFProductFactoryModel *>*factorys;

@property (strong, nonatomic) NSArray<NSString *>*policies;
@property (strong, nonatomic) NSArray<NSString *>*detailUrls;
@property (strong, nonatomic) NSArray<NSString *>*picUrls;

@end
