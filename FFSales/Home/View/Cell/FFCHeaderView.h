//
//  FFCHeaderView.h
//  FFSales
//
//  Created by lin on 2018/5/31.
//  Copyright © 2018年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SDCycleScrollView;
@interface FFCHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIView *brandVIew;
- (IBAction)checkMoreA:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *contentTF;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *allCategoryBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkAll;
@end
