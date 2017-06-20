//
//  YBIMAddWXView.m
//  yb
//
//  Created by LRG on 2017/6/12.
//  Copyright © 2017年 wsb0617@foxmail.com. All rights reserved.
//

#import "YBIMAddWXView.h"
#import "UIView+Extension.h"

#define ViewLength(x) x*ScreenWidth
static CGFloat const BGViewWidth = 0.75;
static CGFloat const BGViewHeight = 0.75;

@interface YBIMAddWXView ()
{
    UIWindow *_window;
    UITextField *_wxTF;
    UIButton *_sureBtn;
}
@end


@implementation YBIMAddWXView
-(instancetype)init{
    if(self = [super init]){
        [self configUI];
    }
    return self;
}
-(void)configUI{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.userInteractionEnabled = YES;
    _window = [UIApplication sharedApplication].keyWindow;
    self.frame = _window.bounds;
    
    UIImageView *backImageView= [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth-ViewLength(BGViewWidth))/2.0, (ScreenHeight-ViewLength(BGViewHeight))/2.0, ViewLength(BGViewWidth), ViewLength(BGViewHeight))];
    backImageView.image = [UIImage imageNamed:@"IM_bgImg"];
    backImageView.contentMode = UIViewContentModeScaleAspectFit;
    backImageView.userInteractionEnabled = YES;
    
    [self addSubview:backImageView];
    
    CGFloat imgWidth = 0.25*ScreenWidth;
    CGFloat imgHeight = 0.25*ScreenWidth;
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(ViewLength(BGViewWidth)/2.0-imgWidth/2.0,-40.f, imgWidth, imgHeight)];
    img.image = [UIImage imageNamed:@"IM_wx_blue"];
    img.contentMode = UIViewContentModeScaleAspectFit;
    [backImageView addSubview:img];
    
    CGFloat ViewHeight = 44.0;
    UIView *bgView1 = [[UIView alloc]initWithFrame:CGRectMake(20.f, img.maxY+10.f, ViewLength(BGViewWidth)-40.f, ViewHeight)];
    bgView1.layer.cornerRadius = ViewHeight/2.0;
    bgView1.layer.borderWidth = 1.0;
    bgView1.layer.borderColor = YBColor(175, 182, 190).CGColor;
    bgView1.userInteractionEnabled = YES;
    [backImageView addSubview:bgView1];
    
    UIImageView *phoneImg = [[UIImageView alloc]initWithFrame:CGRectMake(10.f, 13.0, 18.0, 18.0)];
    phoneImg.image = [UIImage imageNamed:@"IM_wx_gray"];
    phoneImg.contentMode = UIViewContentModeScaleAspectFit;
    [bgView1 addSubview:phoneImg];
    
    _wxTF = [[UITextField alloc]initWithFrame:CGRectMake(phoneImg.maxX+10.f, phoneImg.y, bgView1.width-phoneImg.maxX-phoneImg.x, phoneImg.height)];
    _wxTF.placeholder = @"请填写您的微信号";
    _wxTF.keyboardType = UIKeyboardTypePhonePad;
    _wxTF.font = [UIFont systemFontOfSize:15];
    _wxTF.textColor = [UIColor blackColor];
    [bgView1 addSubview:_wxTF];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(bgView1.x+20.f, bgView1.maxY+15.f, bgView1.width-20.f, 35)];
    label.numberOfLines = 2;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = YBColor(199, 203, 209);
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"对方同意后，可以看到彼此的微信号\n您可以在设置中修改微信号";
    [backImageView addSubview:label];
    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureBtn.frame = CGRectMake(bgView1.x, label.maxY+25.f, bgView1.width, 44.0);
    _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    _sureBtn.layer.cornerRadius = 22.0;
    _sureBtn.layer.masksToBounds = YES;
    [_sureBtn setBackgroundImage:[UIView createImageWithColor:YBColor(114, 160, 226)] forState:UIControlStateNormal];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(sureBtnIsClick) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:_sureBtn];

}
#pragma mark ---事件
-(void)sureBtnIsClick{
    [self hide];
}
-(void)show{
    [_window addSubview:self];
}
-(void)hide{
    [self removeFromSuperview];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_wxTF resignFirstResponder];
    [self hide];
}

@end
