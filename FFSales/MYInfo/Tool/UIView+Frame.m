//
//  UIView+Frame.m
//  FFSales
//
//  Created by lin on 2018/6/8.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)



- (CGFloat)top{
    return self.frame.origin.y;
}
- (void)setTop:(CGFloat)top{
    self.frame = CGRectMake(self.left, top, self.width, self.height);
}
- (CGFloat)left{
    return self.frame.origin.x;
}
- (void)setLeft:(CGFloat)left{
    self.frame = CGRectMake(left, self.top, self.width, self.height);
}
- (CGFloat)bottom{
    return self.top + self.height;
}
- (void)setBottom:(CGFloat)bottom{
    self.frame = CGRectMake(self.left, bottom - self.height, self.width, self.height);
}
- (CGFloat)right{
    return self.left + self.width;
}
- (void)setRight:(CGFloat)right{
    self.frame = CGRectMake(right - self.width, self.top, self.width, self.height);
}
- (CGFloat)width{
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width{
    self.frame = CGRectMake(self.left, self.top, width, self.height);
}
- (CGFloat)height{
    return  self.frame.size.height;
}
- (void)setHeight:(CGFloat)height{
    self.frame = CGRectMake(self.left, self.top, self.width, height);
}
- (CGPoint)center{
    return  CGPointMake(self.left + self.width*0.5, self.top + self.height*0.5);
}
- (void)setCenter:(CGPoint)center{
    self.frame = CGRectMake(center.x - self.width*0.5, center.y - self.height*0.5, self.width, self.height);
}
- (CGFloat)centerX{
    return self.left + self.width*0.5;
}
- (void)setCenterX:(CGFloat)centerX{
    self.frame = CGRectMake(centerX - self.width*0.5, self.top, self.width, self.height);
}
-(CGFloat)centerY{
    return self.top + self.height*0.5;
}
- (void)setCenterY:(CGFloat)centerY{
    self.frame = CGRectMake(self.left, centerY - self.height*0.5, self.width, self.height);
}
- (CGSize)size{
    return self.frame.size;
}
- (void)setSize:(CGSize)size{
    self.frame = CGRectMake(self.left, self.top, size.width, size.height);
}
- (CGPoint)origin{
    return  self.frame.origin;
}
- (void)setOrigin:(CGPoint)origin{
    self.frame = CGRectMake(origin.x, origin.y, self.width, self.height);
}

@end
