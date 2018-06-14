//
//  MoneyHistoryCell.h
//  FFSales
//
//  Created by lin on 2018/6/12.
//  Copyright © 2018年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoneyHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *historyTitle;

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *flag;

@end
