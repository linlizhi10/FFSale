//
//  CustomerMCell.h
//  FFSales
//
//  Created by lin on 2018/6/20.
//  Copyright © 2018年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerMCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moneyType;
@property (weak, nonatomic) IBOutlet UILabel *useAmount;
@property (weak, nonatomic) IBOutlet UILabel *waitAmount;
@property (weak, nonatomic) IBOutlet UILabel *alreadyAmount;
@property (weak, nonatomic) IBOutlet UIButton *useBtn;
@property (weak, nonatomic) IBOutlet UIButton *fanliBtn;
@property (weak, nonatomic) IBOutlet UIButton *otherBtn;

@end
