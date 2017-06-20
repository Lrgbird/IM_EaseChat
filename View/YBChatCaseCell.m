//
//  YBChatCaseCell.m
//  yb
//
//  Created by LRG on 2017/6/10.
//  Copyright © 2017年 wsb0617@foxmail.com. All rights reserved.
//

#import "YBChatCaseCell.h"
#import "UIView+Extension.h"

#define BubbleViewWidth 0.65*ScreenWidth
#define BubbleViewHeight 0.4*ScreenWidth
static CGFloat const shadeWidth = 40.f;

@interface YBChatCaseCell ()
{
    UILabel *_titleLabel;
    UILabel *_caseDesLabel;
    UIImageView *_imgView;
    UILabel *_nameLabel;
    UILabel *_sexLabel;
    UILabel *_ageLabel;
    UIButton *_iconBtn;
    
}
@end


@implementation YBChatCaseCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self configUI];
    }
    return self;
}
-(void)configUI{
    
    
    _iconBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _iconBtn.frame=CGRectMake(10.0,shadeWidth, 40.0, 40.0);
    _iconBtn.layer.cornerRadius=20.f;
    _iconBtn.layer.masksToBounds=YES;
    [_iconBtn addTarget:self action:@selector(iconIsClick) forControlEvents:UIControlEventTouchUpInside];
    [_iconBtn setImage:[[UIImage imageNamed:@"IM_wx_blue"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.contentView addSubview:_iconBtn];
    
    
    
    UIImageView *bubbleView = [[UIImageView alloc]initWithFrame:CGRectMake(_iconBtn.maxX+15-shadeWidth+10.f, _iconBtn.y-shadeWidth, BubbleViewWidth+2*shadeWidth, BubbleViewHeight+2*shadeWidth)];
    bubbleView.contentMode = UIViewContentModeScaleToFill;
    bubbleView.image = [UIImage imageNamed:@"IM_case_border"];
    bubbleView.userInteractionEnabled = YES;
    [self.contentView addSubview:bubbleView];
    
    
    
    NSString *title =  @"【曲筱绡的病例】我又牙齿方面的病症，需要您的帮忙...";
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.f+shadeWidth, 10.f+shadeWidth, BubbleViewWidth-20.f, 45.f)];
    _titleLabel.numberOfLines = 2;
    _titleLabel.attributedText = [self returnStringWithFont:15 lineSpace:5 color:[UIColor blackColor] text:title];
    [bubbleView addSubview:_titleLabel];
    
    NSString *des = @"病症描述： 本人最近一个月经常口腔溃疡...";
    _caseDesLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.x, _titleLabel.maxY+5.f, _titleLabel.width-40.f-20.f, 40.f)];
    _caseDesLabel.numberOfLines = 2;
    _caseDesLabel.attributedText = [self returnStringWithFont:12 lineSpace:8 color:YBColor(193, 198, 205) text:des];
    [bubbleView addSubview:_caseDesLabel];
    
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(_caseDesLabel.maxX+15.f, _caseDesLabel.y, 45.f, 45.f)];
    _imgView.image = [UIImage imageNamed:@"IM_patient"];
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    [bubbleView addSubview:_imgView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(shadeWidth, _imgView.maxY+8.f, BubbleViewWidth, 1)];
    lineView.backgroundColor = YBColor(233, 234, 238);
    [bubbleView addSubview:lineView];
    
    CGFloat labelWidth = (BubbleViewWidth - 10.f)/3.0;
    NSArray *strArray = @[@"姓名:曲筱绡",@"性别:女",@"年龄:24"];
    for (int i =0; i<3; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.x+i*labelWidth, lineView.maxY+10.f, labelWidth, 13)];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor blackColor];
        label.text = strArray[i];
        label.tag = 1000+i;
        [bubbleView addSubview:label];
    }
    _nameLabel = [bubbleView viewWithTag:1000];
    _sexLabel = [bubbleView viewWithTag:1001];
    _ageLabel = [bubbleView viewWithTag:1002];
    [self setBackgroundColor:[UIColor clearColor]];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
}

-(void)iconIsClick{
    
}

-(NSMutableAttributedString*)returnStringWithFont:(CGFloat)font lineSpace:(CGFloat)space color:(UIColor*)color text:(NSString*)text{
    NSMutableAttributedString *str=[[NSMutableAttributedString alloc]initWithString:text];
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, text.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, text.length)];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = space;
    style.alignment = NSTextAlignmentLeft;
    [str addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    return str;
    
}
+(CGFloat)returnCellHeight{
    return 235.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
