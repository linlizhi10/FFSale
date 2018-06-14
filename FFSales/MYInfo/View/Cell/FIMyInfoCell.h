//
//  FIMyInfoCell.h
//  finance
//
//  Created by lin on 17/5/9.
//  Copyright © 2017年 李传政. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface FIMyInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *flagImage;
@property (weak, nonatomic) IBOutlet UILabel *contentTitle;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;

@end
