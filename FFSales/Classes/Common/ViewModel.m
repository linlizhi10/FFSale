//
//  ViewModel.m
//  DaDong
//
//  Created by 李传政 on 2018/3/20.
//  Copyright © 2018年 WintrueTeam. All rights reserved.
//

#import "ViewModel.h"

@implementation ViewModel


+ (instancetype)viewModel{
    return [[self alloc]initModel];
}

- (instancetype)initModel{
    self = [super init];
    if(self){
    }
    return self;
}

- (void)loadRequestWithStart:(requestDataStartBlock)_startBlock
            andCallBackBlock:(requestDataCallBackBlock)_block
                    andParam:(NSDictionary *)_paramDic{
    
}

@end
