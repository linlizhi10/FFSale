//
//  DDCommonScanVC.h
//  DaDong
//
//  Created by 李传政 on 2018/2/28.
//  Copyright © 2018年 WintrueTeam. All rights reserved.
//

#import "DDCommonNaviVC.h"

#if NS_BLOCKS_AVAILABLE
typedef void (^scanGetStrings)(NSString * scanResult);
#endif

@interface DDCommonScanVC : DDCommonNaviVC

@property (nonatomic, copy)scanGetStrings scanBlock;
@property (nonatomic, copy)NSString * ptitle;

@end
