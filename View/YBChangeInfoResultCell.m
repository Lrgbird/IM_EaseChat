//
//  YBChangeInfoResultCell.m
//  yb
//
//  Created by LRG on 2017/6/6.
//  Copyright © 2017年 wsb0617@foxmail.com. All rights reserved.
//

#import "YBChangeInfoResultCell.h"
#import "UIView+Extension.h"
#import "YBChatMessageText.h"
static CGFloat const LabelHeight = 25.f;
static CGFloat const LabelWidth = 250.f;

@implementation YBChangeInfoResultCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self configUI];
    }
    return self;
}
-(void)configUI{
    _label=[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2.0-LabelWidth/2.0, 5, LabelWidth,LabelHeight)];
    _label.layer.cornerRadius=LabelHeight/2.0;
    _label.layer.masksToBounds=YES;
    _label.layer.borderColor=YBColor(233, 234, 238).CGColor;
    _label.backgroundColor=YBColor(233, 234, 238);
    _label.textAlignment=NSTextAlignmentCenter;
    _label.font=[UIFont systemFontOfSize:13.0];
    _label.textColor=[UIColor blackColor];
    [self.contentView addSubview:_label];
    
    [self setBackgroundColor:[UIColor clearColor]];
    
}
-(void)configCellWithString:(NSString *)content{
    _label.text=content;
    CGSize size = [self sizeWithFont:[UIFont systemFontOfSize:13] string:content];
    CGRect frame = _label.frame;
    _label.frame = CGRectMake(ScreenWidth/2.0-size.width/2.0-15.f, frame.origin.y, size.width+30.f, frame.size.height);
    if([content isEqualToString:kYBCommentSuccessByOppositeString]){
        _label.textColor = YBColor(119, 167, 237);
    }else{
        _label.textColor = [UIColor blackColor];
    }
}
+(CGFloat)returnCellHeight{
    return 50.f;
}


- (CGSize)sizeWithFont:(UIFont *)font string:(NSString*)str {
    CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    
    return [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
