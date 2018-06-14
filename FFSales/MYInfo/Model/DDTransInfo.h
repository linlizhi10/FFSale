//
//  DDTransInfo.h
//  DaDong
//
//  Created by lin on 2018/6/7.
//  Copyright © 2018年 WintrueTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDSubInfo : NSObject
@property (assign, nonatomic) long postTime; //
@property (assign, nonatomic) float qty;
@property (copy, nonatomic) NSString *deliveryStatus;//

@end
@interface DDTransInfo : NSObject
@property (assign, nonatomic) float qty;
@property (assign, nonatomic) float sendQty;

@property (strong, nonatomic) NSArray<DDSubInfo *> *deliveryInfos;

@end
