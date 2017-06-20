//
//  YBChatListViewController.m
//  yb
//
//  Created by LRG on 2017/6/6.
//  Copyright © 2017年 wsb0617@foxmail.com. All rights reserved.
//

#import "YBChatListViewController.h"
#import "YBChatViewController.h"
#import "IConversationModel.h"
#import "EaseConvertToCommonEmoticonsHelper.h"
#import "EaseEmotionManager.h"
#import "NSDate+Category.h"
#import "YBChatMessageText.h"
//#import "yb-Swift.h"




#define kHaveUnreadAtMessage    @"kHaveAtMessage"
#define kAtYouMessage           1
#define kAtAllMessage           2

@interface YBChatListViewController ()<EaseConversationListViewControllerDelegate,EaseConversationListViewControllerDataSource>
{
    UIView *_networkStateView;
}

@end

@implementation YBChatListViewController


#pragma mark ---周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    [self networkStateView];
    [self removeEmptyConversationsFromDB];
    [self confiUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self tableViewDidTriggerHeaderRefresh];
}

#pragma mark ---视图
-(void)confiUI{
    self.navigationItem.title=@"会话列表";
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"new chat" style:UIBarButtonItemStylePlain target:self action:@selector(createNewChat)];
}
#pragma mark ---事件
//新建一个会话
-(void)createNewChat{
    NSString *newChat=@"wsp";
    EMConversation* conversation = [[EMClient sharedClient].chatManager getConversation:newChat type:EMConversationTypeChat createIfNotExist:YES];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:@"你好"];
    NSString *from = [[EMClient sharedClient] currentUsername];
    
    //生成Message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:conversation.conversationId from:from to:@"wsp" body:body ext:nil];
    message.chatType = EMChatTypeChat;// 设置为单聊消息
    
    __block typeof(self)weakSelf=self;
    [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
        NSLog(@"Progress----------------%d",progress);
    } completion:^(EMMessage *message, EMError *error) {
        NSLog(@"Error--------------%@",error);
        [weakSelf.tableView reloadData];
    }];

}
//处理最后一条消息显示逻辑
-(NSString*)handleCustomMessageShowAsTheLastOneWith:(id<IConversationModel>)conversationModel{
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    
    //判断最后一条消息是否为空
    if(lastMessage){
        EMMessageBody *messageBody = lastMessage.body;
        //判断是否为单聊、文字消息
        BOOL isCustomMessage = (conversationModel.conversation.type == EMConversationTypeChat)&&
        (messageBody.type == EMMessageBodyTypeText);
        //处理特殊信息，其余按照默认处理
        if(isCustomMessage){
            NSString *text = ((EMTextMessageBody*)messageBody).text;
            //判断是否是自己发送
            BOOL isSender =[lastMessage.from isEqualToString:from];
            //请求评价
            if([text isEqualToString:kYBRequestCommentMessageText]){
                if(isSender){
                    return kYBRequestCommentByMestring;
                }else{
                    return kYBRequestCommentByOppositeShowInListString;
                }
                
            }
            //请求发送电话
            if([text isEqualToString:YBChangePhoneNumberMessageText]){
                return kYBRequestChangePhoneNumber;
            }
            //请求发送微信
            if([text isEqualToString:YBChangeWXMessageText]){
                return kYBRequestChangeWX;
            }
            //微信相关消息
            if([text isEqualToString:YBAgreeChangeWXMessageText]){
                if(isSender){
                    return YBChangeWXYesByMeString;
                }else{
                    return YBChangeWXYesByOppositeString;
                }
            }
            if([text isEqualToString:YBDisagreeChangeWXMessageText]){
                if(isSender){
                    return YBChangeWXNoByMeString;
                }else{
                    return YBChangeWXNoByOppositeString;
                }
            }
            if([text isEqualToString:YBSendWXMessageText]){
                if(isSender){
                    return kYBHaveSendWXByMeString;
                }else{
                    return kYBHaveSendWXByOppositeString;
                }
            }
            //电话相关消息
            if([text isEqualToString:YBAgreeChangePhoneNumberMessageText]){
                if(isSender){
                    return YBChangePhoneNumberYesByMeString;
                }else{
                    return YBChangePhoneNumberYesByOppositeString;
                }
            }
            if([text isEqualToString:YBDisChangePhoneNumberMessageText]){
                if(isSender){
                    return YBChangePhoneNumberNoByMeString;
                }else{
                    return YBChangePhoneNumberNoByOppositeString;
                }
            }
            if([text isEqualToString:YBSendPhoneNumberText]){
                if(isSender){
                    return kYBHaveSendPhoneNumberByMeString;
                }else{
                    return kYBHaveSendPhoneNumberByMeString;
                }
            }
            //病例相关消息
            if([text isEqualToString:YBSendCaseMessageText]){
                if(isSender){
                    return kYBHaveSendCaseByMeString;
                }else{
                    return kYBHaveSendCaseByOppositeString;
                }
            }
            //评价相关消息
            if([text isEqualToString:kYBAgreeCommentMessageText]){
                if(isSender){
                    return kYBagreeCOmmentByMeString;
                }else{
                    return kYBagreeCommentByOppositeString;
                }
            }
            if([text isEqualToString:kYBdisAgreeCommentMessageText]){
                if(isSender){
                    return kYBdisagreeCommentByMeString;
                }else{
                    return kYBdisagreeCommentByOppositeString;
                }
            }
            if([text isEqualToString:kYBCommentSuccessMessageText]){
                if(isSender){
                    return kYBdisagreeCommentByMeString;
                }else{
                    return kYBCommentSuccessByOppositeString;
                }
            }
        }

    }
    return nil;
}
#pragma mark ---聊天相关
- (UIView *)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = NSLocalizedString(@"network.disconnection", @"Network disconnection");
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}
- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.type == EMConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EMClient sharedClient].chatManager deleteConversations:needRemoveConversations isDeleteMessages:YES completion:nil];
    }
}

#pragma mark - EaseConversationListViewControllerDelegate
/*!
 @method
 @brief 获取点击会话列表的回调
 @discussion 获取点击会话列表的回调后,点击会话列表用户可以根据conversationModel自定义处理逻辑
 @param conversationListViewController 当前会话列表视图
 */
- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
            didSelectConversationModel:(id<IConversationModel>)conversationModel
{
    if (conversationModel) {
        EMConversation *conversation = conversationModel.conversation;
        if (conversation) {
            YBChatViewController *chatPageVC = [[YBChatViewController alloc]initWithConverSationID:conversation.conversationId conversationType:conversation.type title:conversationModel.title];
            
            
            [self.navigationController pushViewController:chatPageVC animated:NO];
            [self.tableView reloadData];
     }
    }
}

#pragma mark - EaseConversationListViewControllerDataSource
/*!
 @method
 @brief 构建实现协议IConversationModel的model
 @discussion 用户可以创建实现协议IConversationModel的自定义conversationModel对象，按照业务需要设置属性值
 @param conversationListViewController 当前会话列表视图
 @param conversation 会话对象
 @result 返回实现协议IConversationModel的model对象
 */
-(id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                                    modelForConversation:(EMConversation *)conversation
{
    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
    if (model.conversation.type == EMConversationTypeChat) {
//        if ([[RobotManager sharedInstance] isRobotWithUsername:conversation.conversationId]) {
//            model.title = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.conversationId];
//        } else {
////            UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:conversation.conversationId];
////            if (profileEntity) {
////                model.title = profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
////                model.avatarURLPath = profileEntity.imageUrl;
////            }
//        }
//    } else if (model.conversation.type == EMConversationTypeGroupChat) {
//        NSString *imageName = @"groupPublicHeader";
//        if (![conversation.ext objectForKey:@"subject"])
//        {
//            NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
//            for (EMGroup *group in groupArray) {
//                if ([group.groupId isEqualToString:conversation.conversationId]) {
//                    NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
//                    [ext setObject:group.subject forKey:@"subject"];
//                    [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
//                    conversation.ext = ext;
//                    break;
//                }
//            }
//        }
//        NSDictionary *ext = conversation.ext;
//        model.title = [ext objectForKey:@"subject"];
//        imageName = [[ext objectForKey:@"isPublic"] boolValue] ? @"groupPublicHeader" : @"groupPrivateHeader";
//        model.avatarImage = [UIImage imageNamed:imageName];
    }
    return model;
}
/*!
 @method
 @brief 获取最后一条消息显示的内容
 @discussion 用户根据conversationModel实现,实现自定义会话中最后一条消息文案的显示内容
 @param conversationListViewController 当前会话列表视图
 @result 返回用户最后一条消息显示的内容
 */
- (NSAttributedString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:@""];
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        NSString *latestMessageTitle = @"";
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case EMMessageBodyTypeText:{
                //自定义消息解析处理
                
                NSString *showString = [self handleCustomMessageShowAsTheLastOneWith:conversationModel];
                if(showString){
                    return [[NSAttributedString alloc]initWithString:showString];
                }
                
                // 表情映射。
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
                if ([lastMessage.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
                    latestMessageTitle = @"[动画表情]";
                }
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = NSLocalizedString(@"message.video1", @"[video]");
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = NSLocalizedString(@"message.file1", @"[file]");
            } break;
            default: {
            } break;
        }
        
        if (lastMessage.direction == EMMessageDirectionReceive) {
//            NSString *from = lastMessage.from;
//            UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:from];
//            if (profileEntity) {
//                from = profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
//            }
//            latestMessageTitle = [NSString stringWithFormat:@"%@: %@", from, latestMessageTitle];
        }
        
        NSDictionary *ext = conversationModel.conversation.ext;
        if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtAllMessage) {
            latestMessageTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"group.atAll", nil), latestMessageTitle];
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, NSLocalizedString(@"group.atAll", nil).length)];
            
        }
        else if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtYouMessage) {
            latestMessageTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"group.atMe", @"[Somebody @ me]"), latestMessageTitle];
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, NSLocalizedString(@"group.atMe", @"[Somebody @ me]").length)];
        }
        else {
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
        }
    }
    
    return attributedStr;
}
/*!
 @method
 @brief 获取最后一条消息显示的时间
 @discussion 用户可以根据conversationModel,自定义实现会话列表中时间文案的显示内容
 @param conversationListViewController 当前会话列表视图
 @result 返回用户最后一条消息时间的显示文案
 */
- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
       latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        latestMessageTime = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    return latestMessageTime;
}


#pragma mark - public

-(void)refresh
{
    [self refreshAndSortView];
}

-(void)refreshDataSource
{
    [self tableViewDidTriggerHeaderRefresh];
}

- (void)isConnect:(BOOL)isConnect{
    if (!isConnect) {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
    
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == EMConnectionDisconnected) {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
}

-(void)messagesDidReceive:(NSArray *)aMessages{
    [self.tableView reloadData];
}

#pragma mark ---tableview代理
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(editingStyle==UITableViewCellEditingStyleDelete){
//        //删除会话
//    }
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
