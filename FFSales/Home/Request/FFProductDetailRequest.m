//
//  FFProductDetail.m
//  FFSales
//
//  Created by lin on 2018/6/4.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFProductDetailRequest.h"

@implementation FFProductDetailRequest
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = [NSString stringWithFormat:@"/materialProducts/%@",_materialId];
    self.METHOD = @"GET";
    self.params = @{@"accessToken":self.accessToken?:@""
                    };
    [super startCallBack:_callBack];
}
@end
@implementation FFProductListRequest
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = @"/materialProducts";
    self.METHOD = @"GET";
    self.params = @{@"accessToken":self.accessToken?:@"",
                    @"keyword":self.keyword?:@"",
                    @"brand":self.brand?:@"",
                    @"strain":self.strain?:@"",
                    @"page":@(self.page),
                    @"size":@(self.size)
                    };
    [super startCallBack:_callBack];
}
@end
