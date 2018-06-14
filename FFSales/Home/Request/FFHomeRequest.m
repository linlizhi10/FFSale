//
//  FFHomeRequest.m
//  FFSales
//
//  Created by lin on 2018/6/1.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFHomeRequest.h"

@implementation FFHomeBannerRequest
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = @"/banners";
    self.METHOD = @"GET";
    self.params = @{@"accessToken":self.accessToken?:@""
                    }
    ;
    [super startCallBack:_callBack];
}
@end
@implementation FFHomeBrandRequest
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = @"/materialClasss";
    self.METHOD = @"GET";
    self.params = @{@"accessToken":self.accessToken?:@"",
                    @"levels":self.levels?:@""
                    }
    ;
    [super startCallBack:_callBack];
}
@end
@implementation FFHomeRecentlyRequest
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = @"/materialProducts/recency";
    self.METHOD = @"GET";
    self.params = @{@"accessToken":self.accessToken?:@"",
                    @"page":@(_page),
                    @"size":@(_size)
                    }
    ;
    [super startCallBack:_callBack];
}
@end
@implementation FFHomeLikeRequest
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = @"/materialProducts/like";
    self.METHOD = @"GET";
    self.params = @{@"accessToken":self.accessToken?:@"",
                    @"page":@(_page),
                    @"size":@(_size)
                    }
    ;
    [super startCallBack:_callBack];
}
@end
