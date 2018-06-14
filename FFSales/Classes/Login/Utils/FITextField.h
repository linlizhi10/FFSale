//
//  LZTextField.h
//  BaseFoudation
//
//  Created by lin on 17/3/16.
//  Copyright © 2017年 lin. All rights reserved.
//
#pragma mark ------ 限制输入字数的 -------
#import <UIKit/UIKit.h>

@interface FITextField : UITextField
/**
 *  init textfield with the max content
 *
 *  @param maxNumber the max content length
 *
 */
- (instancetype)initWithMaxContains:(NSInteger)maxNumber;
- (void)setContains:(NSInteger)maxNumber;
@end
