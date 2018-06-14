//
//  UIView+Frame.h
//  finance
//
//  Created by 汤军 on 17/5/5.
//  Copyright © 2017年 李传政. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIView (Frame)



@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

- (void)setCornerRadius:(CGFloat)radius;
- (void)setBoarderWidth:(float)width withColor:(UIColor *)color Radius:(CGFloat)radius;
- (void)setBoarderWidth:(float)width withColor:(UIColor *)color;
-(void)removeAllSubviews;

@end
