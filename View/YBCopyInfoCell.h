//
//  YBCopyInfoCell.h
//  yb
//
//  Created by LRG on 2017/6/6.
//  Copyright © 2017年 wsb0617@foxmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,YBInfoType){
    YBInfoTypePhoneNumber,
    YBInfoTypeWX
};


@interface YBCopyInfoCell : UITableViewCell
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,copy) void(^btnIsClickBlock)();
-(void)configCellWithString:(YBInfoType)type;
+(CGFloat)returnCellHeight;
@end
