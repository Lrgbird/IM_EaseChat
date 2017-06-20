//
//  YBCopyInfoCell.m
//  yb
//
//  Created by LRG on 2017/6/6.
//  Copyright © 2017年 wsb0617@foxmail.com. All rights reserved.
//

#import "YBCopyInfoCell.h"
#import "UIView+Extension.h"


static  CGFloat const ViewWidth = 283.f;
static  CGFloat const ViewHeight = 85.f;
static  CGFloat const shadeWidth = 19.f;

@implementation YBCopyInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self configUI];
    }
    return self;
}
-(void)configUI{
    
    UIImageView *bubbleView=[[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2.0-ViewWidth/2.0, 0, ViewWidth, ViewHeight)];
    bubbleView.contentMode = UIViewContentModeScaleToFill;
    bubbleView.image = [UIImage imageNamed:@"YBIM_copy_bg"];
    bubbleView.userInteractionEnabled = YES;
    [self.contentView addSubview:bubbleView];
    
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(shadeWidth, shadeWidth-2.f, 2.0*(ViewWidth-2*shadeWidth)/3.0, ViewHeight-2*shadeWidth)];
    _titleLabel.backgroundColor=[UIColor whiteColor];
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    _titleLabel.font=[UIFont systemFontOfSize:16];
    _titleLabel.textColor=[UIColor blackColor];
    [bubbleView addSubview:_titleLabel];
    
    _btn=[UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame=CGRectMake(_titleLabel.maxX, _titleLabel.y, ViewWidth-shadeWidth-_titleLabel.maxX, ViewHeight-2*shadeWidth);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_btn.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _btn.bounds;
    maskLayer.path = maskPath.CGPath;
    _btn.layer.mask = maskLayer;
    
    
    _btn.titleLabel.font=[UIFont systemFontOfSize:15];
    [_btn addTarget:self action:@selector(btnIsClick) forControlEvents:UIControlEventTouchUpInside];
    [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bubbleView addSubview:_btn];
    
    [self setBackgroundColor:[UIColor clearColor]];
}
-(void)configCellWithString:(YBInfoType)type{
    switch (type) {
        case YBInfoTypeWX:
        {
            _titleLabel.text=@"对方的微信";
            [_btn setTitle:@"点击复制" forState:UIControlStateNormal];
            [_btn setBackgroundImage:[UIView createImageWithColor:YBColor(114, 202, 89)] forState:UIControlStateNormal];
        }
            break;
        case YBInfoTypePhoneNumber:
        {
            _titleLabel.text=@"对方的手机号";
            [_btn setTitle:@"点击复制" forState:UIControlStateNormal];
            [_btn setBackgroundImage:[UIView createImageWithColor:YBColor(244, 132, 131)] forState:UIControlStateNormal];
        }
            break;
    }
}
-(void)btnIsClick{
    self.btnIsClickBlock();
}
+(CGFloat)returnCellHeight{
    return 85.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
