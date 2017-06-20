//
//  YBChatCommentPopUpView.m
//  yb
//
//  Created by LRG on 2017/6/9.
//  Copyright © 2017年 wsb0617@foxmail.com. All rights reserved.
//

#import "YBChatCommentPopUpView.h"
#import "UIView+Extension.h"

#define  viewWidth   0.75*ScreenWidth
#define  viewHeight  0.75*ScreenWidth

static NSString *const placeHolderText = @"  请填写您对该医生的评价...";
@interface YBChatCommentPopUpView ()<UITextViewDelegate>
{
    UIWindow *_window;
    UITextView *_textView;
    UIButton *_submitBtn;
    UILabel *_numCountLabel;
    UIImageView *_backImageView;
    NSString *_doctorID;
    
    long _currentStarNum;
    long _currentNum;
    
}
@end


@implementation YBChatCommentPopUpView
-(instancetype)initWithDoctorID:(NSString*)ID{
    if(self = [super init]){
        _doctorID = ID;
        [self configUI];
    }
    return self;
}
-(void)configUI{
    
    _currentNum = 0;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.userInteractionEnabled = YES;
    _window = [UIApplication sharedApplication].keyWindow;
    self.frame = _window.bounds;
    
     _backImageView= [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth-viewWidth)/2.0, (ScreenHeight-viewHeight)/2.0, viewWidth, viewHeight)];
    _backImageView.image = [UIImage imageNamed:@"IM_bgImg"];
    _backImageView.contentMode = UIViewContentModeScaleAspectFit;
    _backImageView.userInteractionEnabled = YES;
    
    CGFloat imgWidth = 0.25*ScreenWidth;
    CGFloat imgHeight = 0.25*ScreenWidth;
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(viewWidth/2.0-imgWidth/2.0,-40.f, imgWidth, imgHeight)];
    img.image = [UIImage imageNamed:@"IM_flower"];
    img.contentMode = UIViewContentModeScaleAspectFit;
    [_backImageView addSubview:img];
    
    
    CGFloat starWidth = 22.f;
    CGFloat gap = 20.f;
    CGFloat x = viewWidth/2.0-2.5*starWidth-2*gap;
    for(int i=0;i<5;i++){
        UIImageView *starView = [[UIImageView alloc]initWithFrame:CGRectMake(x+i*(starWidth+gap), img.maxY, starWidth, starWidth)];
        starView.image = [UIImage imageNamed:@"IM_star_gray"];
        starView.contentMode = UIViewContentModeScaleAspectFit;
        starView.tag = 1000+i;
        starView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(starImgIsClick:)];
        [starView addGestureRecognizer:tap];
        [_backImageView addSubview:starView];
    }
    
    CGFloat btnHeight = 45.f;
    CGFloat btnWidth = viewWidth-30.f;
    _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitBtn.frame = CGRectMake(15.f,viewHeight-20.f-btnHeight, btnWidth, btnHeight);
    _submitBtn.layer.cornerRadius = btnHeight/2.0;
    [_submitBtn setBackgroundImage:[UIView createImageWithColor:YBColor(120, 168, 238)] forState:UIControlStateNormal];
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn addTarget:self action:@selector(submitBtnIsClick) forControlEvents:UIControlEventTouchUpInside];
    [_backImageView addSubview:_submitBtn];
    
    CGFloat textViewY = img.maxY+10.f+starWidth+10.f;
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(_submitBtn.x,textViewY , _submitBtn.width, _submitBtn.y-textViewY-20.f)];
    _textView.text = placeHolderText;
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.textColor = YBColor(130, 138, 151);
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.autocorrectionType = UITextAutocorrectionTypeNo;
    
    _textView.layer.borderColor = YBColor(120, 168, 238).CGColor;
    _textView.layer.borderWidth = 1;
    _textView.layer.cornerRadius = 10;
    
    _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textView.keyboardType = UIReturnKeyDefault;
    _textView.returnKeyType = UIReturnKeyDefault;
    _textView.scrollEnabled = YES;
    _textView.delegate = self;
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_backImageView addSubview:_textView];
    
    _numCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(_textView.maxX-70.f, _textView.maxY+5.f, 70.f, 13.f)];
    _numCountLabel.font = [UIFont systemFontOfSize:12];
    _numCountLabel.textAlignment = NSTextAlignmentRight;
    _numCountLabel.textColor = YBColor(130, 138, 151);
    _numCountLabel.text = [NSString stringWithFormat:@"%ld/60",_currentNum];
    [_backImageView addSubview:_numCountLabel];
    
    [self addSubview:_backImageView];
}
#pragma mark ---事件
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_textView resignFirstResponder];
    [self hiden];
}
-(void)starImgIsClick:(UITapGestureRecognizer*)tap{
    
}
-(void)submitBtnIsClick{
    [self hiden];
    self.commentFinishBlock();
}

-(void)show{
    [_window addSubview:self];
}
-(void)hiden{
    [self removeFromSuperview];
}

#pragma mark ---代理
/**
 将要开始编辑
 @param textView textView
 @return BOOL
 */
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
    
}
/**
 开始编辑
 @param textView textView
 */
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:placeHolderText]) {
        
        textView.text = @"";
        
    }
}

/**
 将要结束编辑
 
 @param textView textView
 
 @return BOOL
 */
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    return YES;
    
}

/**
 结束编辑
 
 @param textView textView
 */
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length <1) {
        textView.text = placeHolderText;
    }
    
    
}


/**
 内容将要发生改变编辑 限制输入文本长度 监听TextView 点击了ReturnKey 按钮
 
 @param textView textView
 @param range    范围
 @param text     text
 
 @return BOOL
 */
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location < 60)
    {
        return  YES;
        
    } else  if ([textView.text isEqualToString:@"\n"]) {
        
        //这里写按了ReturnKey 按钮后的代码
        return NO;
    }
    
    if (textView.text.length == 100) {
        
        return NO;
    }
    
    return YES;
    
}


/**
 内容发生改变编辑 自定义文本框placeholder
 有时候我们要控件自适应输入的文本的内容的高度，只要在textViewDidChange的代理方法中加入调整控件大小的代理即可
 @param textView textView
 */
- (void)textViewDidChange:(UITextView *)textView
{
    _numCountLabel.text = [NSString stringWithFormat:@"%ld/60", textView.text.length];
}
@end
