//
//  Model.h
//  finance
//
//  Created by 李传政 on 2017/5/5.
//  Copyright © 2017年 李传政. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

@interface Model : NSObject

@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) int pageSize;
@property (nonatomic, copy) NSString *response_code;
@property (nonatomic, copy) NSString *response_msg;
@property (nonatomic, copy) NSString *response_time;

@end
