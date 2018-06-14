//
//  FFMoneyRequest.m
//  FFSales
//
//  Created by lin on 2018/6/13.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFMoneyRequest.h"
//cash
@implementation FFMoneyRequest
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = @"/custAccountInfos/availableCash";
    self.METHOD = @"GET";
    self.params = @{@"accessToken":self.accessToken?:@"",
                    @"custId":self.custId?:@""
                    
                    }
    ;
    [super startCallBack:_callBack];
}
@end
@implementation FFMoneyBRequest
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = @"/custAccountInfos/availableAcceptance";
    self.METHOD = @"GET";
    self.params = @{@"accessToken":self.accessToken?:@"",
                    @"custId":self.custId?:@""
                    
                    }
    ;
    [super startCallBack:_callBack];
}
@end
@implementation FFMoneyCRequest
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = @"/custAccountInfos/availableCredit";
    self.METHOD = @"GET";
    self.params = @{@"accessToken":self.accessToken?:@"",
                    @"custId":self.custId?:@""
                    
                    }
    ;
    [super startCallBack:_callBack];
}
@end
@implementation FFOtherMoneyCRequest
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = @"/custAccountInfos/other";
    self.METHOD = @"GET";
    self.params = @{@"accessToken":self.accessToken?:@"",
                    @"custId":self.custId?:@""
                    
                    }
    ;
    [super startCallBack:_callBack];
}
@end
@implementation FFBackMoneyCRequest
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = @"/custAccountInfos/rebate";
    self.METHOD = @"GET";
    self.params = @{@"accessToken":self.accessToken?:@"",
                    @"custId":self.custId?:@""
                    
                    }
    ;
    [super startCallBack:_callBack];
}
@end
@implementation FFCreaditSubRequest
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = @"/custAccountInfos/availableCredit/children";
    self.METHOD = @"GET";
    self.params = @{@"accessToken":self.accessToken?:@"",
                    @"custId":self.custId?:@"",
                    @"serviceType":self.serviceType?:@"",
                    @"childrenAccountType":self.childrenAccountType?:@""
                    }
    ;
    [super startCallBack:_callBack];
}
@end
@implementation FFCreaditDRequest
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = [NSString stringWithFormat:@"/custAccountInfos/availableCredit/%@",self.accountId];
    self.METHOD = @"GET";
    self.params = @{
                    @"accessToken":self.accessToken?:@"",
                    
                    };
    [super startCallBack:_callBack];
}
@end

@implementation FFHistoryRequest
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = @"/custAccountInfos/records";
    self.METHOD = @"GET";
    self.params = @{@"accessToken":self.accessToken?:@"",
                    @"custId":self.custId?:@"",
                    @"serviceType":self.serviceType?:@"",
                    @"childrenAccountType":self.childrenAccountType?:@"",
                    @"page":@(_page),
                    @"size":@(_size)
                    }
    ;
    [super startCallBack:_callBack];
}
@end
@implementation FFListRequest
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.PATH = @"/fundTranDetailFlows";
    self.METHOD = @"GET";
    self.params = @{@"accessToken":self.accessToken?:@"",
                    @"custId":self.custId?:@"",
                    @"fundType":self.fundType?:@"",
                    @"page":@(_page),
                    @"size":@(_size)
                    }
    ;
    [super startCallBack:_callBack];
}
@end
