//
//  YBChangeInfoResultCell.h
//  yb
//
//  Created by LRG on 2017/6/6.
//  Copyright © 2017年 wsb0617@foxmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBChangeInfoResultCell : UITableViewCell
@property(nonatomic,strong)UILabel *label;
-(void)configCellWithString:(NSString*)content;
+(CGFloat)returnCellHeight;
@end
