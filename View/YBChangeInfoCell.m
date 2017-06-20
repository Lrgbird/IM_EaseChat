//
//  YBChangeInfoCell.m
//  yb
//
//  Created by LRG on 2017/6/6.
//  Copyright © 2017年 wsb0617@foxmail.com. All rights reserved.
//

#import "YBChangeInfoCell.h"
#import "UIView+Extension.h"
#import "YBChatMessageText.h"

static CGFloat const ViewWidth = 241.f;
static CGFloat const ViewHeight = 153.f;
//static CGFloat const IconWidth = 40.f;
static CGFloat const shadeWidth = 21.f;

@implementation YBChangeInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self configUI];
    }
    return self;
}
-(void)configUI{
    _iconBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _iconBtn.frame=CGRectMake(20.0,5.0, 40.0, 40.0);
    _iconBtn.layer.cornerRadius=20.f;
    _iconBtn.layer.masksToBounds=YES;
    [_iconBtn addTarget:self action:@selector(iconIsClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_iconBtn];
    
    
    CGFloat btnHeight=44.f;
    UIImageView *bubbleView=[[UIImageView alloc]initWithFrame:CGRectMake(_iconBtn.maxX+15-shadeWidth+10.f, 0, ViewWidth, ViewHeight)];
    bubbleView.contentMode = UIViewContentModeScaleToFill;
    bubbleView.image = [UIImage imageNamed:@"YBIM_changeInf_bg"];
    bubbleView.userInteractionEnabled = YES;
    [self.contentView addSubview:bubbleView];
    
    _label=[[UILabel alloc]initWithFrame:CGRectMake(shadeWidth+15.f,shadeWidth, ViewWidth-2*shadeWidth-30.f, ViewHeight-btnHeight-2*shadeWidth)];
    [bubbleView addSubview:_label];
    
    
    _agreeBtn=[[UIButton alloc]initWithFrame:CGRectMake(shadeWidth, _label.maxY, ViewWidth/2.0-shadeWidth, btnHeight)];
    _agreeBtn.tag=1000;
    [_agreeBtn setBackgroundImage:[UIView createImageWithColor:YBColor(120, 168, 238)] forState:UIControlStateNormal];
    [_agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
    [_agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_agreeBtn addTarget:self action:@selector(isChangeInfoBtnIsClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //失效状态
    [_agreeBtn setBackgroundImage:[UIView createImageWithColor:YBColor(233, 234, 238)] forState:UIControlStateDisabled];
    [_agreeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    [bubbleView addSubview:_agreeBtn];
    
    _disagreeBtn=[[UIButton alloc]initWithFrame:CGRectMake(_agreeBtn.maxX, _agreeBtn.y,_agreeBtn.width, btnHeight)];
    _disagreeBtn.tag=1001;
    [_disagreeBtn setBackgroundImage:[UIView createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_disagreeBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    [_disagreeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_disagreeBtn addTarget:self action:@selector(isChangeInfoBtnIsClick:) forControlEvents:UIControlEventTouchUpInside];
    //失效状态
    [_disagreeBtn setBackgroundImage:[UIView createImageWithColor:YBColor(233, 234, 238)] forState:UIControlStateDisabled];
    [_disagreeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    [bubbleView addSubview:_disagreeBtn];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(_disagreeBtn.x, _disagreeBtn.y, 1, _disagreeBtn.height)];
    lineView1.backgroundColor = [UIColor whiteColor];
    [bubbleView addSubview:lineView1];
    
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(_disagreeBtn.x, _disagreeBtn.y, _disagreeBtn.width, 1)];
    lineView.backgroundColor=YBColor(233, 234, 238);
    [bubbleView addSubview:lineView];
    
    [self setBackgroundColor:[UIColor clearColor]];
    
}
-(void)configCellWithModel:(id<IMessageModel>)messageModel cotentString:(NSString *)content{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:content];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, content.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, content.length)];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = 7.0;
    style.alignment = NSTextAlignmentLeft;
    [str addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, content.length)];
    _label.attributedText = str;
    _label.numberOfLines = 2;
    
    EMMessage *message = messageModel.message;
    NSDictionary *extDic = message.ext;
    if(extDic&&[extDic objectForKey:kYBHaveTouchChangeMessageKey]){
        NSString *isTouched = [extDic objectForKey:kYBHaveTouchChangeMessageKey];
        if([isTouched isEqualToString:kYBHaveTouchChangeMessageValue ]){
            _agreeBtn.enabled = NO;
            _disagreeBtn.enabled = NO;
        }
        if([isTouched isEqualToString:kYBNotTouchChangeMessageValue]){
            _agreeBtn.enabled = YES;
            _disagreeBtn.enabled = YES;
        }
    }
}
//头像点击
-(void)iconIsClick{
    self.iconIsClickBlock();
    
}
//是否同意交换信息按钮点击
-(void)isChangeInfoBtnIsClick:(UIButton*)btn{
    _disagreeBtn.enabled = NO;
    _agreeBtn.enabled = NO;
    self.isChangeInfoBtnIsClickBlock(btn.tag-1000);
}

+(CGFloat)returnCellHeight{
    return 160.f;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
