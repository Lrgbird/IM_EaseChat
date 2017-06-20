//
//  YBSendInfoCell.m
//  yb
//
//  Created by LRG on 2017/6/8.
//  Copyright © 2017年 wsb0617@foxmail.com. All rights reserved.
//

#import "YBSendInfoCell.h"

@implementation YBSendInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}
+(CGFloat)returnCellHeight{
    return 1.f;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
