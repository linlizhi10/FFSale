//
//  TransDetailCell.h
//  DaDong
//
//  Created by lin on 2018/3/7.
//  Copyright © 2018年 WintrueTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *lastItemView;
@property (weak, nonatomic) IBOutlet UIView *topItemView;
@property (weak, nonatomic) IBOutlet UIView *normalItemView;
@property (weak, nonatomic) IBOutlet UILabel *dateATime;
@property (weak, nonatomic) IBOutlet UILabel *transInfo;

@end
