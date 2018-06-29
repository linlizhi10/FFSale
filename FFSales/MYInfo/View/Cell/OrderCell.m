//
//  OrderCell.m
//  DaDong
//
//  Created by lin on 2018/3/1.
//  Copyright © 2018年 WintrueTeam. All rights reserved.
//

#import "OrderCell.h"
#import "OrderInfo.h"
#import "DDStringUtil.h"
@implementation OrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)stateBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickSatateAction:)]) {
        [self.delegate clickSatateAction:self];
    }
}
- (void)setType:(NSOrderType)type{
    _type = type;
//    if (_type == NSOrderTypeAll) {
//        _customerName.text = @"订单类型";
//    }else{
//        _customerName.text = @"客户名";
//    }
}
- (void)fillCellWith:(OrderInfo *)orInfo{
   
    NSString *commissionT = @"提成:暂无";
    
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"提成:" attributes:@{NSForegroundColorAttributeName:RGBCOLORV(0x1c1c20)}];
//
//        NSAttributedString *strT = [[NSAttributedString alloc] initWithString:orInfo.bonus?:@"暂无" attributes:@{NSForegroundColorAttributeName:RGBCOLORV(0xed265a)}];
//        [str appendAttributedString:strT];
//        _commission.attributedText =str;
    
    
    _orderTime.text = [NSString stringWithFormat:@"下单时间:%@",[DDStringUtil toDateTimeString:orInfo.createTime]];
    _money.text = [NSString stringWithFormat:@"共%ld件商品,总计%.2f吨，实付金额￥%.2f",orInfo.materials.count,orInfo.sendQty,orInfo.actualAmout];
    /*
    switch (_type) {
        case 1:
            auditS = [NSString stringWithFormat:@"WAIT_AUDIT"];
            break;
        case 2:
            statusS = [NSString stringWithFormat:@"02,03"];
            break;
        case 3:
            statusS = [NSString stringWithFormat:@"05"];
            break;
        case 4:
            statusS = [NSString stringWithFormat:@"06,07"];
            break;
        default:
            break;
    }
    */
    _TransBtn.hidden = YES;

    if ([orInfo.auditStatus isEqualToString:@"WAIT_AUDIT"] ) {
        _state.text = @"等待后台管理员审核";
        _state.textColor = [UIColor darkGrayColor];

    }else{
    
    if ([orInfo.status isEqualToString:@"02"] || [orInfo.status isEqualToString:@"03"] ) {
        _state.text = [NSString stringWithFormat:@"已发货%.2f吨/%.2f吨",orInfo.sendQty,orInfo.qty];
        _state.textColor = [UIColor darkGrayColor];
        _TransBtn.hidden = NO;

    }else if([orInfo.status isEqualToString:@"05"] ){
        _state.text = @"货物已全部发完";
        _state.textColor = [UIColor darkGrayColor];
//        _TransBtn.hidden = NO;

    }else if([orInfo.status isEqualToString:@"06"] || [orInfo.status isEqualToString:@"07"] ){
        _state.text = @"订单已关闭";
        _state.textColor = [UIColor redColor];
    }
    }
    NSInteger count = 0;
    if (orInfo.materials.count > 4) {
        count = 4;
    }else{
        count = orInfo.materials.count;
    }
    CGFloat imagew = 69;
    for (int i = 0; i < count; i ++) {
        UIImageView *image = [[UIImageView alloc] init];
        image.frame = CGRectMake(2+(imagew + 2)*i, 12.5, imagew, imagew);
        OrderProduct *product = orInfo.materials[i];
        NSString *imageurl = product.picUrl;
        [image sd_setImageWithURL:[NSURL URLWithString:imageurl?:@""] placeholderImage:[UIImage imageNamed:@"goodDefault"]];
//        image.backgroundColor = [UIColor redColor];
        [_imageTView addSubview:image];
    }
}
@end
