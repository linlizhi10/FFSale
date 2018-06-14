//
//  TableGoodsCell.h
//  FFSales
//
//  Created by lin on 2018/6/6.
//  Copyright © 2018年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *unitPrice;
@end
