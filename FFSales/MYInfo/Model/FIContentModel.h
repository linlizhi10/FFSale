//
//  FIContentModel.h
//  finance
//
//  Created by lin on 17/5/9.
//  Copyright © 2017年 李传政. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FIContentModel : NSObject
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *contentTitle;
@property (nonatomic, copy) NSString *contentSubtitle;
@property (nonatomic, assign) BOOL hideArrow;
@end
