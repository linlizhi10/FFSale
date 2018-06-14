//
//  LZTextField.m
//  BaseFoudation
//
//  Created by lin on 17/3/16.
//  Copyright © 2017年 lin. All rights reserved.
//

#import "FITextField.h"
@interface FITextField()
{
    NSInteger _maxNumber;
}
@end
@implementation FITextField
- (instancetype)initWithMaxContains:(NSInteger)maxNumber{
    self = [super init];
    if (self) {
        _maxNumber = maxNumber;
        self.font = [UIFont systemFontOfSize:14];
        [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

//xib 调用
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _maxNumber = LONG_MAX;
        self.font = [UIFont systemFontOfSize:14];
        [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _maxNumber = LONG_MAX;
        [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        
    }
    return self;
}
- (void)setContains:(NSInteger)maxNumber
{
    _maxNumber = maxNumber;
}

- (void)textFieldDidChange:(FITextField *)textField{
    textField.textColor = [UIColor blackColor];

    NSString *toBeString = textField.text;
    
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start  offset:0];
    //没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.length > _maxNumber)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:_maxNumber];
            if  (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:_maxNumber];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, _maxNumber)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    
}

@end
