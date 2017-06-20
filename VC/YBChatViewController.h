//
//  YBChatViewController.h
//  yb
//
//  Created by LRG on 2017/6/5.
//  Copyright © 2017年 wsb0617@foxmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseMessageViewController.h"
@interface YBChatViewController : UIViewController;
-(instancetype)initWithConverSationID:(NSString*)conversationId conversationType:(EMConversationType)type title:(NSString *)title;
@property(nonatomic,copy)NSString *name;
@end
