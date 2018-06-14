//
//  CreditCell.m
//  FFSales
//
//  Created by lin on 2018/6/12.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "CreditCell.h"

@implementation CreditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setType:(int)type{
    if (type>=1) {
        _flagView.hidden = YES;
        _leftMargin.constant = -15;
        _rightArrow.hidden = YES;
        _rightMargin.constant = -22;
    }
}
- (IBAction)moreAction:(id)sender {
}
@end
