//
//  FFFactoryACell.m
//  FFSales
//
//  Created by lin on 2018/6/4.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "FFFactoryACell.h"

@implementation FFFactoryACell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [_factoryABtn setSelected:selected];
    if (selected) {
        _factoryABtn.backgroundColor = [UIColor redColor];
        
    }else{
        _factoryABtn.backgroundColor = RGBCOLORV(0xF2F2F2);
    }
    // Configure the view for the selected state
}

@end
