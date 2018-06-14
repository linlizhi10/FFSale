//
//  BackCell.h
//  FFSales
//
//  Created by lin on 2018/6/14.
//  Copyright © 2018年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *useAmount;
@property (weak, nonatomic) IBOutlet UILabel *lockAmount;

@end
