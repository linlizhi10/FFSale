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
    if (selected) {
        self.backgroundColor = [UIColor redColor];
        _factoryName.textColor = [UIColor whiteColor];
        _factoryName.backgroundColor = [UIColor redColor];
    }else{
        self.backgroundColor = [UIColor whiteColor];
        _factoryName.textColor = RGBCOLORV(0x333333);
        _factoryName.backgroundColor = RGBCOLORV(0xF2F2F2);
    }
    // Configure the view for the selected state
}

@end
