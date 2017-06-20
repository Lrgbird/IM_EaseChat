//
//  YBChangeInfoCell.h
//  yb
//
//  Created by LRG on 2017/6/6.
//  Copyright © 2017年 wsb0617@foxmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMessageModel.h"
@interface YBChangeInfoCell : UITableViewCell
@property(nonatomic,strong)UILabel  *label;
@property(nonatomic,strong)UIButton *agreeBtn;
@property(nonatomic,strong)UIButton *disagreeBtn;
@property(nonatomic,strong)UIButton *iconBtn;
@property(nonatomic,copy) void(^iconIsClickBlock)();
@property(nonatomic,copy) void(^isChangeInfoBtnIsClickBlock)(NSInteger);
-(void)configCellWithModel:(id<IMessageModel>)messageModel cotentString:(NSString *)content;
+(CGFloat)returnCellHeight;
@end
