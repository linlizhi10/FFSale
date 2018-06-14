//
//  CreditCell.h
//  FFSales
//
//  Created by lin on 2018/6/12.
//  Copyright © 2018年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreditCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UILabel *limitTip;
@property (weak, nonatomic) IBOutlet UILabel *moneyType;
- (IBAction)moreAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *useAmount;
@property (weak, nonatomic) IBOutlet UILabel *waitAmount;
@property (weak, nonatomic) IBOutlet UILabel *alreadyAmount;
@property (weak, nonatomic) IBOutlet UIView *flagView;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMargin;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
- (void)setType:(int)type;
@end
