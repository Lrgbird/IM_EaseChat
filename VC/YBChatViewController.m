//
//  YBChatViewController.m
//  yb
//
//  Created by LRG on 2017/6/5.
//  Copyright © 2017年 wsb0617@foxmail.com. All rights reserved.
//

#import "YBChatViewController.h"
//#import "yb-Swift.h"
#import "EaseBaseMessageCell.h"
#import "YBChangeInfoCell.h"
#import "YBChatMessageText.h"
#import "UIView+Extension.h"
#import "YBChangeInfoResultCell.h"
#import "YBCopyInfoCell.h"
#import "YBSendInfoCell.h"
#import "YBChatCommentPopUpView.h"
#import "YBChatCaseCell.h"
#import "YBIMAddPhoneNumberView.h"
#import "YBIMAddWXView.h"



static  NSString * const BaseCellReuseID = @"baseCellReuseID";
static  NSString * const ChangeInfoCellReuseID = @"changeInfoCellReuseID";
static  NSString * const ChangeInfoReusltCellReuseID = @"changeInfoResultCellReuseID";
static  NSString * const CopyInfoCellReuseID = @"copyInfoCellReuseID";
static  NSString * const SendInfoCellReuseID = @"sendInfoCellReuseID";
static  NSString * const SendCaseCellReuseID = @"sendCaseReuseID";

@interface YBChatViewController () <EaseMessageViewControllerDelegate,EaseMessageViewControllerDataSource,UIAlertViewDelegate,EMChatManagerDelegate>
{
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    UIMenuItem *_transpondMenuItem;
    NSString *_conversationId;
    EMConversationType _conversationType;
    NSString *_title;
}
@property (nonatomic) NSMutableDictionary *emotionDic;
@property (nonatomic, copy) EaseSelectAtTargetCallback selectedCallback;
@property (nonatomic) BOOL isPlayingAudio;
@property (nonatomic,strong) EaseMessageViewController *chatVC;
@end

static  CGFloat const TopBtnHeight = 60.0;
@implementation YBChatViewController

#pragma mark ---周期
-(instancetype)initWithConverSationID:(NSString*)conversationId conversationType:(EMConversationType)type title:(NSString *)title{
    if(self = [super init]){
        _conversationId = conversationId;
        _conversationType = type;
        _title = title;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [self configUI];
    
}
-(void)dealloc{
   [[EMClient sharedClient].chatManager removeDelegate:self];
}
#pragma mark ---界面
-(void)configUI{
    
    self.navigationItem.title = _title;
    
    NSArray *titleArray;
    NSArray *imgArray;
    NSString * chatName = [[EMClient sharedClient] currentUsername];
    if([chatName isEqualToString:@"wsp1"]){
        titleArray=@[@"交换电话",@"交换微信",@"发送病例",@"举报"];
        imgArray=@[@"IM_change_phone",@"IM_change_wx",@"IM_send_case",@"IM_report"];
    }else{
        titleArray=@[@"交换电话",@"交换微信",@"请求评价",@"举报"];
        imgArray=@[@"IM_change_phone",@"IM_change_wx",@"IM_comment",@"IM_report"];
    }
    
    
    CGFloat btnWidth = ScreenWidth/4.0;
    
    for (int i = 0; i < 4; i++) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(i*btnWidth, 64.0, btnWidth, TopBtnHeight)];
        bgView.tag = 1000+i;
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.userInteractionEnabled = YES;
        [self.view addSubview:bgView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topBtnIsClick:)];
        [bgView addGestureRecognizer:tap];
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10.f, btnWidth, 20.f)];
        img.image = [UIImage imageNamed:imgArray[i]];
        img.contentMode = UIViewContentModeScaleAspectFit;
        [bgView addSubview:img];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, img.maxY+7.f, btnWidth, 16.f)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = YBColor(130, 142, 152);
        label.text = titleArray[i];
        label.tag = 2000+i;
        [bgView addSubview:label];
    }
    self.chatVC.view.frame = CGRectMake(0,TopBtnHeight+64.f, ScreenWidth, ScreenHeight-TopBtnHeight-64.f);
    self.chatVC.showRefreshHeader=YES;
    self.chatVC.delegate=self;
    self.chatVC.dataSource=self;
    [self.view addSubview:self.chatVC.view];
    [self addChildViewController:self.chatVC];
    
    //移除不需要的底部功能
    [self.chatVC.chatBarMoreView removeItematIndex:1];
    [self.chatVC.chatBarMoreView removeItematIndex:2];
    [self.chatVC.chatBarMoreView removeItematIndex:2];
    
}
#pragma mark ---数据及初始化

-(EaseMessageViewController*)chatVC{
    if(!_chatVC){
        _chatVC = [[EaseMessageViewController alloc]initWithConversationChatter:_conversationId conversationType:_conversationType];
    }
    return _chatVC;
}


#pragma mark ---事件
-(void)topBtnIsClick:(UITapGestureRecognizer*)tap{
    BOOL isShowPopUpView = NO;
    
    NSString *messageText;
    switch (tap.view.tag-1000) {
        case 0:     //交换电话
        {
            messageText=YBChangePhoneNumberMessageText;
            if(isShowPopUpView){
                YBIMAddPhoneNumberView *addPhoneNumberView = [[YBIMAddPhoneNumberView alloc]init];
                [addPhoneNumberView show];
            }
            
        }
            break;
        case 1:      //交换微信
        {
            if(isShowPopUpView){
                YBIMAddWXView *addWXView = [[YBIMAddWXView alloc
                                             ]init];
                [addWXView show];
            }
            messageText=YBChangeWXMessageText;
            
        }
            break;
        case 2:     //发送病例或者请求评价
        {
            
            UILabel *label = [tap.view viewWithTag:2002];
            if([label.text isEqualToString:@"发送病例"]){
                messageText = YBSendCaseMessageText;
            }else{
                //请求评价
                messageText = kYBRequestCommentMessageText;
            }
        }
            break;
        case 3:    //举报
        {
            //处理举报的逻辑
            UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
            alterVC.title = @"确认举报该病人";
            UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alterVC addAction:cancel];
            UIAlertAction *upDate=[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //处理确认举报逻辑
            }];
            [alterVC addAction:upDate];
            [self presentViewController:alterVC animated:NO completion:nil];
            
        }
            break;
    }
    //将是否点击作为扩展属性添加到消息里
    NSDictionary *extDic = @{kYBHaveTouchChangeMessageKey:kYBNotTouchChangeMessageValue};
    [self sendMessageWithMessageText:messageText ext:extDic];
    
}
//手动发送消息
-(void)sendMessageWithMessageText:(NSString*)messageText ext:(NSDictionary *)extDic{
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:messageText];
    NSString *from = [[EMClient sharedClient] currentUsername];
    
    //生成Message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:self.chatVC.conversation.conversationId from:from to:@"wsp" body:body ext:extDic];
    message.chatType = EMChatTypeChat;// 设置为单聊消息
    [self.chatVC addMessageToDataSource:message progress:nil];
    __block typeof(self)weakSelf=self;
    
    [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
        
    } completion:^(EMMessage *message, EMError *error) {
        NSLog(@"%@---------%@",[self class],error);
        [weakSelf.chatVC.tableView reloadData];
    }];
}
//处理交换信息逻辑
-(UITableViewCell*)handleChangeInfoLogicWithTableView:(UITableView*)tableView
                                  cellForMessageModel:(id<IMessageModel>)messageModel{
    __weak typeof(self)weakSelf=self;
    //请求交换微信
    if((messageModel.bodyType==EMMessageBodyTypeText)&&[messageModel.text isEqualToString:YBChangeWXMessageText]){
        if(messageModel.isSender){
            NSLog(@"我是发送者,不做什么");
            YBChangeInfoResultCell *changeInfoResultCell=[tableView dequeueReusableCellWithIdentifier:ChangeInfoReusltCellReuseID];
            if(!changeInfoResultCell){
                changeInfoResultCell=[[YBChangeInfoResultCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ChangeInfoReusltCellReuseID];
            }
            [changeInfoResultCell configCellWithString:YBChangeWXMessageHaveSend];
            changeInfoResultCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return changeInfoResultCell;
        }else{
            NSLog(@"我是接受者,我要现实定制视图");
            YBChangeInfoCell *changeInfoCell=[tableView dequeueReusableCellWithIdentifier:ChangeInfoCellReuseID];
            if(!changeInfoCell){
                changeInfoCell=[[YBChangeInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ChangeInfoCellReuseID];
            }
            changeInfoCell.iconIsClickBlock=^(){
                NSLog(@"-----------查看个人资料");
            };
            changeInfoCell.isChangeInfoBtnIsClickBlock=^(NSInteger whichBtn){
                
                
                NSDictionary *dic = @{kYBHaveTouchChangeMessageKey:kYBHaveTouchChangeMessageValue};
                EMMessage *message = messageModel.message;
                message.ext = dic;
                [[EMClient sharedClient].chatManager updateMessage:message completion:^(EMMessage *aMessage, EMError *aError) {
                    if(!aError){
                        NSLog(@"更新消息成功");
                    }
                }];
                
                //0发送微信，1拒绝
                if(whichBtn==0){
                    [weakSelf sendMessageWithMessageText:YBAgreeChangeWXMessageText ext:nil];
                    
                    NSDictionary *dic=@{YBisSendBack:YBSendBackYES,
                                        YBMessageExtInfo:@"13016490684"};
                    [weakSelf sendMessageWithMessageText:YBSendWXMessageText ext:dic];
                }else{
                    [weakSelf sendMessageWithMessageText:YBDisagreeChangeWXMessageText ext:nil];
                }
                
            };
            [changeInfoCell configCellWithModel:messageModel cotentString:YBChangeWXString];
            changeInfoCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return changeInfoCell;
        }
    }
    //请求评价
    if((messageModel.bodyType==EMMessageBodyTypeText)&&[messageModel.text isEqualToString:kYBRequestCommentMessageText]){
        if(messageModel.isSender){
            NSLog(@"我是发送者,显示请求视图");
            YBChangeInfoResultCell *changeInfoResultCell=[tableView dequeueReusableCellWithIdentifier:ChangeInfoReusltCellReuseID];
            if(!changeInfoResultCell){
                changeInfoResultCell=[[YBChangeInfoResultCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ChangeInfoReusltCellReuseID];
            }
            [changeInfoResultCell configCellWithString:kYBRequestCommentByMestring];
            changeInfoResultCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return changeInfoResultCell;
        }else{
            NSLog(@"我是接受者,显示是否同意视图");
            YBChangeInfoCell *changeInfoCell=[tableView dequeueReusableCellWithIdentifier:ChangeInfoCellReuseID];
            if(!changeInfoCell){
                changeInfoCell=[[YBChangeInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ChangeInfoCellReuseID];
            }
            [changeInfoCell configCellWithModel:messageModel cotentString:kYBRequestCommentByOppositeString];
            changeInfoCell.iconIsClickBlock=^(){
                //处理点击头像逻辑
            };
            changeInfoCell.isChangeInfoBtnIsClickBlock=^(NSInteger whichBtn){
                NSDictionary *dic = @{kYBHaveTouchChangeMessageKey:kYBHaveTouchChangeMessageValue};
                EMMessage *message = messageModel.message;
                message.ext = dic;
                [[EMClient sharedClient].chatManager updateMessage:message completion:^(EMMessage *aMessage, EMError *aError) {
                    if(!aError){
                        NSLog(@"更新消息成功");
                    }
                }];
                
                if(whichBtn==0){
                    [weakSelf sendMessageWithMessageText:kYBAgreeCommentMessageText ext:nil];
                    YBChatCommentPopUpView *view = [[YBChatCommentPopUpView alloc]initWithDoctorID:nil];
                    view.commentFinishBlock=^(){
                        //发送评论完成消息
                        [weakSelf sendMessageWithMessageText:kYBCommentSuccessMessageText ext:nil
                         ];
                    };
                    [view show];
                }else{
                    [weakSelf sendMessageWithMessageText:kYBdisAgreeCommentMessageText ext:nil];
                }
            };
            changeInfoCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return changeInfoCell;
        }
    }
    //交换电话
    if((messageModel.bodyType==EMMessageBodyTypeText)&&[messageModel.text isEqualToString:YBChangePhoneNumberMessageText]){
        if(messageModel.isSender){
            NSLog(@"我是发送者,不做什么");
            YBChangeInfoResultCell *changeInfoResultCell=[tableView dequeueReusableCellWithIdentifier:ChangeInfoReusltCellReuseID];
            if(!changeInfoResultCell){
                changeInfoResultCell=[[YBChangeInfoResultCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ChangeInfoReusltCellReuseID];
            }
            [changeInfoResultCell configCellWithString:YBChangePhoneMessageHaveSend];
            changeInfoResultCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return changeInfoResultCell;
        }else{
            NSLog(@"我是接受者,我要现实定制视图");
            YBChangeInfoCell *changeInfoCell=[tableView dequeueReusableCellWithIdentifier:ChangeInfoCellReuseID];
            if(!changeInfoCell){
                changeInfoCell=[[YBChangeInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ChangeInfoCellReuseID];
            }
            [changeInfoCell configCellWithModel:messageModel cotentString:YBChangePhoneNumberString];
            changeInfoCell.iconIsClickBlock=^(){
                //处理头像点击逻辑
            };
            changeInfoCell.isChangeInfoBtnIsClickBlock=^(NSInteger whichBtn){
                NSDictionary *dic = @{kYBHaveTouchChangeMessageKey:kYBHaveTouchChangeMessageValue};
                EMMessage *message = messageModel.message;
                message.ext = dic;
                [[EMClient sharedClient].chatManager updateMessage:message completion:^(EMMessage *aMessage, EMError *aError) {
                    if(!aError){
                        NSLog(@"更新消息成功");
                    }
                }];
                if(whichBtn==0){
                    [weakSelf sendMessageWithMessageText:YBAgreeChangePhoneNumberMessageText ext:nil];
                    NSDictionary *dic=@{YBisSendBack:YBSendBackYES,
                                        YBMessageExtInfo:@"13016490684"};
                    [weakSelf sendMessageWithMessageText:YBSendPhoneNumberText ext:dic];
                }else{
                    [weakSelf sendMessageWithMessageText:YBDisChangePhoneNumberMessageText ext:nil];
                }
            };
            changeInfoCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return changeInfoCell;
        }
    }
    return nil;
}
//处理同意交换信息逻辑
-(UITableViewCell*)handleAgreeSendInfoMessageWithTableview:(UITableView*)tableView
                                      cellForMessageModel:(id<IMessageModel>)messageModel{
    NSString *cellContentText;
    
    BOOL isAgreeChangeWXMessage=(messageModel.bodyType==EMMessageBodyTypeText)&&[messageModel.text isEqualToString:YBAgreeChangeWXMessageText];//同意交换微信
    BOOL isAgreeChangePhoneNumberMessage=(messageModel.bodyType==EMMessageBodyTypeText)&&[messageModel.text isEqualToString:YBAgreeChangePhoneNumberMessageText];//同意交换电话
    BOOL isAgreeCommentMessage=(messageModel.bodyType==EMMessageBodyTypeText)&&[messageModel.text isEqualToString:kYBAgreeCommentMessageText];//同意评价
    BOOL isCommentSuccess = (messageModel.bodyType==EMMessageBodyTypeText)&&[messageModel.text isEqualToString:kYBCommentSuccessMessageText];//评价成功
    if(isCommentSuccess){
        if(messageModel.isSender){
            cellContentText = kYBCommentSuccessByMeString;
        }else{
            cellContentText = kYBCommentSuccessByOppositeString;
        }
    }
    
    if(isAgreeChangeWXMessage){
        if(messageModel.isSender){
            cellContentText=YBChangeWXYesByMeString;
        }else{
            cellContentText=YBChangeWXYesByOppositeString;
        }
    }
    if(isAgreeChangePhoneNumberMessage){
        if(messageModel.isSender){
            cellContentText=YBChangePhoneNumberYesByMeString;
        }else{
            cellContentText=YBChangePhoneNumberYesByOppositeString;
        }
    }
    if(isAgreeCommentMessage){
        if(messageModel.isSender){
            cellContentText=kYBagreeCOmmentByMeString;
        }else{
            cellContentText=kYBagreeCommentByOppositeString;
        }
    }
    if(isAgreeCommentMessage||isAgreeChangePhoneNumberMessage||isAgreeChangeWXMessage||isCommentSuccess){
        YBChangeInfoResultCell *changeInfoResultCell=[tableView dequeueReusableCellWithIdentifier:ChangeInfoReusltCellReuseID];
        if(!changeInfoResultCell){
            changeInfoResultCell=[[YBChangeInfoResultCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ChangeInfoReusltCellReuseID];
        }
        [changeInfoResultCell configCellWithString:cellContentText];
        changeInfoResultCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return changeInfoResultCell;
    }
    return nil;
}
//处理不同意交换信息逻辑
-(UITableViewCell*)handledisagreeSendInfoMessageWithTableview:(UITableView*)tableView
                                      cellForMessageModel:(id<IMessageModel>)messageModel{
    NSString *cellContentText;
    
    BOOL isDisagreeChangeWXMessage=(messageModel.bodyType==EMMessageBodyTypeText)&&[messageModel.text isEqualToString:YBDisagreeChangeWXMessageText];//不同意交换微信
    BOOL isDisagreeChangePhoneNumberMessage=(messageModel.bodyType==EMMessageBodyTypeText)&&[messageModel.text isEqualToString:YBDisChangePhoneNumberMessageText];//不同意交换电话
    BOOL isDisagreeCommentMessage=(messageModel.bodyType==EMMessageBodyTypeText)&&[messageModel.text isEqualToString:kYBdisAgreeCommentMessageText];//不同意评价
    
    if(isDisagreeChangeWXMessage){
        if(messageModel.isSender){
            cellContentText=YBChangeWXNoByMeString;
            
        }else{
            cellContentText=YBChangeWXNoByOppositeString;
            
        }
    }
    if(isDisagreeChangePhoneNumberMessage){
        if(messageModel.isSender){
            cellContentText=YBChangePhoneNumberNoByMeString;
        }else{
            cellContentText=YBChangePhoneNumberNoByOppositeString;
        }
    }
    if(isDisagreeCommentMessage){
        if(messageModel.isSender){
            cellContentText=kYBdisagreeCommentByMeString;
        }else{
            cellContentText=kYBdisagreeCommentByOppositeString;
        }
    }
    if(isDisagreeCommentMessage||isDisagreeChangePhoneNumberMessage||isDisagreeChangeWXMessage){
        YBChangeInfoResultCell *changeInfoResultCell=[tableView dequeueReusableCellWithIdentifier:ChangeInfoReusltCellReuseID];
        if(!changeInfoResultCell){
            changeInfoResultCell=[[YBChangeInfoResultCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ChangeInfoReusltCellReuseID];
        }
        [changeInfoResultCell configCellWithString:cellContentText];
        changeInfoResultCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return changeInfoResultCell;
    }
    return nil;
}
//处理发送消息逻辑
-(UITableViewCell*)handleSendInfoMessageWithTableview:(UITableView*)tableView
                                      cellForMessageModel:(id<IMessageModel>)messageModel{
    BOOL isSendWXMessage=(messageModel.bodyType==EMMessageBodyTypeText)&&[messageModel.text isEqualToString:YBSendWXMessageText];//发送微信
    BOOL isSendPhoneNumberMessage=(messageModel.bodyType==EMMessageBodyTypeText)&&[messageModel.text isEqualToString:YBSendPhoneNumberText];//发送手机号
    BOOL isSendCaseMessage=(messageModel.bodyType==EMMessageBodyTypeText)&&[messageModel.text isEqualToString:YBSendCaseMessageText];//发送病例
    
    if(isSendWXMessage){
        if(!messageModel.isSender){
            YBCopyInfoCell  *cell=[tableView dequeueReusableCellWithIdentifier:CopyInfoCellReuseID];
            if(!cell){
                cell=[[YBCopyInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CopyInfoCellReuseID];
            }
            [cell configCellWithString:YBInfoTypeWX];
            cell.btnIsClickBlock=^(){
                //处理拷贝微信逻辑
                UIPasteboard *pasteBoard=[UIPasteboard generalPasteboard];
                pasteBoard.string=@"110";
            };
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    if(isSendPhoneNumberMessage){
        if(!messageModel.isSender){ //收到对方发来的
            YBCopyInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:CopyInfoCellReuseID];
            if(!cell){
                cell=[[YBCopyInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CopyInfoCellReuseID];
            }
            [cell configCellWithString:YBInfoTypePhoneNumber];
            cell.btnIsClickBlock=^(){
                //处理拷贝电话号码逻辑
                UIPasteboard *pasteBoard=[UIPasteboard generalPasteboard];
                pasteBoard.string=@"110";
            };
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    //发送病例，需要做定制视图
    if(isSendCaseMessage){
        YBChatCaseCell *cell = [tableView dequeueReusableCellWithIdentifier:SendCaseCellReuseID];
        if(!cell){
            cell = [[YBChatCaseCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SendCaseCellReuseID];
        }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
    }
    if(isSendPhoneNumberMessage||isSendWXMessage){
        if (messageModel.isSender) {
            YBSendInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:SendInfoCellReuseID];
            if(!cell){
                cell=[[YBSendInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SendInfoCellReuseID];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    
    
    return nil;
}
#pragma mark ---数据


#pragma mark --- EaseMessageViewControllerDelegate
/*!
 @method
 @brief 获取消息自定义cell
 @discussion 用户根据messageModel判断是否显示自定义cell。返回nil显示默认cell，否则显示用户自定义cell
 @param tableView 当前消息视图的tableView
 @param messageModel 消息模型
 @result 返回用户自定义cell
 */
- (UITableViewCell *)messageViewController:(UITableView *)tableView
                       cellForMessageModel:(id<IMessageModel>)messageModel{
    
    UITableViewCell *cell=[self handleChangeInfoLogicWithTableView:tableView cellForMessageModel:messageModel];
    if(cell){
        return cell;
    }else{
        cell=[self handleAgreeSendInfoMessageWithTableview:tableView cellForMessageModel:messageModel];
        if(cell){
            return cell;
        }else{
            cell=[self handledisagreeSendInfoMessageWithTableview:tableView cellForMessageModel:messageModel];
            if(cell){
                return cell;
            }else{
                cell=[self handleSendInfoMessageWithTableview:tableView cellForMessageModel:messageModel];
                if (cell) {
                    return cell;
                }
            }
        }
    }
    return nil;
}
//返回cell高度
- (CGFloat)messageViewController:(EaseMessageViewController *)viewController
           heightForMessageModel:(id<IMessageModel>)messageModel
                   withCellWidth:(CGFloat)cellWidth{
    //交换信息
    if((messageModel.bodyType==EMMessageBodyTypeText)&&
       ([messageModel.text isEqualToString:YBChangePhoneNumberMessageText]||
        [messageModel.text isEqualToString:kYBRequestCommentMessageText]||
       [messageModel.text isEqualToString:YBChangeWXMessageText])){
        if(messageModel.isSender){
            return  [YBChangeInfoResultCell returnCellHeight];
        }else{
            return [YBChangeInfoCell returnCellHeight];
        }
    }
    //同意交换信息
    BOOL isAgreeChangeWXMessage=(messageModel.bodyType==EMMessageBodyTypeText)&&[messageModel.text isEqualToString:YBAgreeChangeWXMessageText];//同意交换微信
    BOOL isAgreeChangePhoneNumberMessage=(messageModel.bodyType==EMMessageBodyTypeText)&&[messageModel.text isEqualToString:YBAgreeChangePhoneNumberMessageText];//同意交换电话
    BOOL isAgreeCommentMessage=(messageModel.bodyType==EMMessageBodyTypeText)&&[messageModel.text isEqualToString:kYBAgreeCommentMessageText];//同意评价医生
    BOOL isCommentSuccess = (messageModel.bodyType==EMMessageBodyTypeText)&&[messageModel.text isEqualToString:kYBCommentSuccessMessageText];//评价成功
    if(isAgreeChangeWXMessage||isAgreeCommentMessage||isAgreeChangePhoneNumberMessage||isCommentSuccess){
        return [YBChangeInfoResultCell returnCellHeight];
    }
    
    //不同意交换
    BOOL isDisagreeChangeWXMessage=(messageModel.bodyType==EMMessageBodyTypeText)&&[messageModel.text isEqualToString:YBDisagreeChangeWXMessageText];//不同意交换微信
    BOOL isDisagreeChangePhoneNumberMessage=(messageModel.bodyType==EMMessageBodyTypeText)&&[messageModel.text isEqualToString:YBDisChangePhoneNumberMessageText];//不同意交换电话
    BOOL isDisagreeCommentMessage=(messageModel.bodyType==EMMessageBodyTypeText)&&[messageModel.text isEqualToString:kYBdisagreeCommentByOppositeString];//不同意评价医生
    if(isDisagreeChangeWXMessage||isDisagreeCommentMessage||isDisagreeChangePhoneNumberMessage){
        return [YBChangeInfoResultCell returnCellHeight];
    }
    
    //发送消息
    BOOL isSendWXMessage=(messageModel.bodyType==EMMessageBodyTypeText)&&[messageModel.text isEqualToString:YBSendWXMessageText];//发送微信
    BOOL isSendPhoneNumberMessage=(messageModel.bodyType==EMMessageBodyTypeText)&&[messageModel.text isEqualToString:YBSendPhoneNumberText];//发送手机号
    BOOL isCommentSuccessMessage = (messageModel.bodyType==EMMessageBodyTypeText)&&[messageModel.text isEqualToString:kYBCommentSuccessMessageText];
    if(isSendWXMessage||isSendPhoneNumberMessage||isCommentSuccessMessage){
        if(messageModel.isSender){
            return [YBSendInfoCell returnCellHeight];
        }else{
            return [YBCopyInfoCell returnCellHeight];
        }
    }
    BOOL isSendCaseMessage=(messageModel.bodyType==EMMessageBodyTypeText)&&[messageModel.text isEqualToString:YBSendCaseMessageText];//发送病例
    if(isSendCaseMessage){
        return [YBChatCaseCell returnCellHeight];
    }
    return 0.f;
}
#pragma mark ---EaseMessageViewControllerDataSource
/*!
 @method
 @brief 是否发送已读回执
 @param viewController 当前消息视图
 @param message 要发送已读回执的message
 @param read message是否已读
 */
- (BOOL)messageViewController:(EaseMessageViewController *)viewController
shouldSendHasReadAckForMessage:(EMMessage *)message
                         read:(BOOL)read{
    return YES;
}
//收到消息的代理
-(void)messagesDidReceive:(NSArray *)aMessages{
    for (EMMessage *message in aMessages) {
        NSDictionary *dic = message.ext;
        if(message.body.type==EMMessageBodyTypeText){
            EMTextMessageBody *body = (EMTextMessageBody*)(message.body);
            
            //发送微信
            if([body.text isEqualToString:YBSendWXMessageText]){
                //收到对方发送的微信，判断是否需要发送自己微信
                if([[dic objectForKey:YBisSendBack] isEqualToString:YBSendBackYES]){
                    NSDictionary *extDic=@{YBisSendBack:YBSendBackNO,
                                           YBMessageExtInfo:@"13016490684"};
                    [self sendMessageWithMessageText:YBSendWXMessageText ext:extDic];
                }
            }
            //发送电话号码
            if([body.text isEqualToString:YBSendPhoneNumberText]){
                if([[dic objectForKey:YBisSendBack] isEqualToString:YBSendBackYES]){
                    NSDictionary *extDic=@{YBisSendBack:YBSendBackNO,
                                           YBMessageExtInfo:@"13016490684"};
                    [self sendMessageWithMessageText:YBSendPhoneNumberText ext:extDic];
                }
            }
        }
    }
}
/*!
 @method
 @brief 选中消息的回调
 @discussion 用户根据messageModel判断，是否自定义处理消息选中时间。返回YES为自定义处理，返回NO为默认处理
 @param viewController 当前消息视图
 @param messageModel 消息模型
 @result 是否采用自定义处理
 */

//处理点击查看评价、点击查看病例逻辑
- (BOOL)messageViewController:(EaseMessageViewController *)viewController
        didSelectMessageModel:(id<IMessageModel>)messageModel
{
    BOOL flag = NO;
    //样例为如果消息是文件消息用户自定义处理选中逻辑
//    switch (messageModel.bodyType) {
//        case EMMessageBodyTypeImage:
//        case EMMessageBodyTypeLocation:
//        case EMMessageBodyTypeVideo:
//        case EMMessageBodyTypeVoice:
//            break;
//        case EMMessageBodyTypeFile:
//        {
//            flag = YES;
//            NSLog(@"用户自定义实现");
//        }
//            break;
//        default:
//            break;
//    }
    return flag;
}


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
