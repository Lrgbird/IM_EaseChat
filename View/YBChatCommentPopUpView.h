//
//  YBChatCommentPopUpView.h
//  yb
//
//  Created by LRG on 2017/6/9.
//  Copyright © 2017年 wsb0617@foxmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBChatCommentPopUpView : UIView
@property(nonatomic,copy) void(^commentFinishBlock)();
-(instancetype)initWithDoctorID:(NSString*)ID;
-(void)show;
@end
