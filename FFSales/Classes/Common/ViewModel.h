//
//  ViewModel.h
//  DaDong
//
//  Created by 李传政 on 2018/3/20.
//  Copyright © 2018年 WintrueTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

#if NS_BLOCKS_AVAILABLE
typedef void (^requestDataCallBackBlock)(BOOL isSuccess,NSString * errorMessage);
typedef void (^requestDataStartBlock)();
#endif



@interface ViewModel : NSObject
+ (instancetype)viewModel;
/**
 载入方法
 @param _startBlock 开始
 @param _block 返回
 @param _paramDic 参数字典
 */
- (void)loadRequestWithStart:(requestDataStartBlock)_startBlock
            andCallBackBlock:(requestDataCallBackBlock)_block
                    andParam:(NSDictionary *)_paramDic;
@end
