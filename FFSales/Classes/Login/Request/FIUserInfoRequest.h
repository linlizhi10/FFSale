//
//  FIUserInfoRequest.h
//  finance
//
//  Created by lin on 17/5/22.
//  Copyright © 2017年 李传政. All rights reserved.
//

#import "Request.h"

@interface FIUserInfoRequest : Request
@property (nonatomic, copy) NSString *accessToken; //

@end
@interface FIGestureUpdateRequest : Request
@property (nonatomic, copy) NSString *accessToken; //
@property (nonatomic, copy) NSString *code; //
@property (nonatomic, copy) NSString *state; //

@end
