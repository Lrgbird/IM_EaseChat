//
//  YBIMAddPhoneNumberView.m
//  yb
//
//  Created by LRG on 2017/6/10.
//  Copyright © 2017年 wsb0617@foxmail.com. All rights reserved.
//

#import "YBIMAddPhoneNumberView.h"
#import "UIView+Extension.h"


#define ViewLength(x) x*ScreenWidth
static CGFloat const BGViewWidth = 0.75;
static CGFloat const BGViewHeight = 0.75;

@interface YBIMAddPhoneNumberView ()<UITextFieldDelegate>
{
    UIWindow *_window;
    UITextField *_phoneNumberTF;
    UITextField *_codeTF;
    UIButton *_sendCodeBtn;
    UIButton *_sureBtn;
    NSTimer *_timer;
    long _time;
}

@end


@implementation YBIMAddPhoneNumberView
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
    img.image = [UIImage imageNamed:@"IM_phone_blue"];
    img.contentMode = UIViewContentModeScaleAspectFit;
    [backImageView addSubview:img];
    
    CGFloat ViewHeight = 44.0;
    UIView *bgView1 = [[UIView alloc]initWithFrame:CGRectMake(20.f, img.maxY, ViewLength(BGViewWidth)-40.f, ViewHeight)];
    bgView1.layer.cornerRadius = ViewHeight/2.0;
    bgView1.layer.borderWidth = 1.0;
    bgView1.layer.borderColor = YBColor(175, 182, 190).CGColor;
    bgView1.userInteractionEnabled = YES;
    [backImageView addSubview:bgView1];
    
    UIImageView *phoneImg = [[UIImageView alloc]initWithFrame:CGRectMake(10.f, 13.0, 18.0, 18.0)];
    phoneImg.image = [UIImage imageNamed:@"IM_phone_gray"];
    phoneImg.contentMode = UIViewContentModeScaleAspectFit;
    [bgView1 addSubview:phoneImg];
    
    _phoneNumberTF = [[UITextField alloc]initWithFrame:CGRectMake(phoneImg.maxX+10.f, phoneImg.y, bgView1.width-phoneImg.maxX-phoneImg.x, phoneImg.height)];
    _phoneNumberTF.delegate = self;
    _phoneNumberTF.placeholder = @"请填写手机号";
    _phoneNumberTF.keyboardType = UIKeyboardTypePhonePad;
    _phoneNumberTF.font = [UIFont systemFontOfSize:15];
    _phoneNumberTF.textColor = [UIColor blackColor];
    [bgView1 addSubview:_phoneNumberTF];
    
    UIView *bgView2 = [[UIView alloc]initWithFrame:CGRectMake(20.f, bgView1.maxY+20.f, bgView1.width, ViewHeight)];
    bgView2.layer.cornerRadius = ViewHeight/2.0;
    bgView2.layer.borderWidth = 1.0;
    bgView2.layer.borderColor = YBColor(175, 182, 190).CGColor;
    bgView2.userInteractionEnabled = YES;
    [backImageView addSubview:bgView2];
    
    UIImageView *messageImg = [[UIImageView alloc]initWithFrame:CGRectMake(10.f, 13.0, 18.0, 18.0)];
    messageImg.image = [UIImage imageNamed:@"IM_message"];
    messageImg.contentMode = UIViewContentModeScaleAspectFit;
    [bgView2 addSubview:messageImg];
    
    _codeTF = [[UITextField alloc]initWithFrame:CGRectMake(messageImg.maxX+10.f, messageImg.y, bgView2.width-messageImg.maxX-messageImg.x - 80.f, messageImg.height)];
    _codeTF.delegate = self;
    _codeTF.placeholder = @"请填写手机号";
    _codeTF.keyboardType = UIKeyboardTypePhonePad;
    _codeTF.font = [UIFont systemFontOfSize:15];
    _codeTF.textColor = [UIColor blackColor];
    [bgView2 addSubview:_codeTF];
    
    _sendCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendCodeBtn.frame = CGRectMake(bgView2.width-messageImg.x-80.f, messageImg.y, 80.0, messageImg.height);
    _sendCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_sendCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_sendCodeBtn setTitleColor:YBColor(199, 203, 209) forState:UIControlStateNormal];
    [_sendCodeBtn addTarget:self action:@selector(sendCodeBtnIsClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView2 addSubview:_sendCodeBtn];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(bgView2.x+10.f, bgView2.maxY+15.f, bgView2.width-20.f, 35)];
    label.numberOfLines = 2;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = YBColor(199, 203, 209);
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"对方同意后，可以看到彼此的手机号\n您可以在设置中修改手机号";
    [backImageView addSubview:label];
    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureBtn.frame = CGRectMake(bgView2.x, label.maxY+15.f, bgView2.width, 44.0);
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
-(void)sendCodeBtnIsClick:(UIButton*)btn{
    
    NSString *regex = @"^[1][34578][0-9]{9}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:_phoneNumberTF.text];
    
    if(!isMatch){
        [UIView showMessage:@"请输入正确手机号" withShowTime:0.8];
    }else{
        //发送验证码
        [_sendCodeBtn setTitle:@"正在发送..." forState:UIControlStateNormal];
        [_sendCodeBtn  setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//        __weak typeof(self)weakSelf=self;
//        [AQLHttpsTool getCodeDataWithPhone:_phoneTF.text tag:@"0" success:^(id  _Nullable json) {
//            if([json[@"status"] intValue]==1){
//                [weakSelf sendSuccess];
//            }else{
//                [AQLShowMessage showMessage:json[@"msg"]];
//                [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//                [_getCodeBtn setTitleColor:AQLTextGreenColor forState:UIControlStateNormal];
//            }
//        }];
    }

}
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
    [_phoneNumberTF resignFirstResponder];
    [_codeTF resignFirstResponder];
    [self hide];
}
#pragma mark ---代理


#pragma mark ---发送验证码按钮状态
- (void)sendSuccess
{
    _time = 60;
    [_sendCodeBtn setTitle:@"重发60" forState:UIControlStateNormal];
    [_sendCodeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _sendCodeBtn.userInteractionEnabled = NO;
    
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeRun:) userInfo:nil repeats:YES];
    }
    else
        [_timer setFireDate:[NSDate date]];
}
-(void)timeRun:(NSTimer *)timer{
    _time--;
    if (_time == 0) {
        [_sendCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_sendCodeBtn setTitleColor:YBColor(199, 203, 209) forState:UIControlStateNormal];
        _sendCodeBtn.userInteractionEnabled = YES;
        
        [_timer setFireDate:[NSDate distantFuture]];
    }
    else
    {
        [_sendCodeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_sendCodeBtn setTitle:[NSString stringWithFormat:@"重发%ld",_time] forState:UIControlStateNormal];
    }
    
}

@end
