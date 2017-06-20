//
//  YBChatMessageText.h
//  yb
//
//  Created by LRG on 2017/6/7.
//  Copyright © 2017年 wsb0617@foxmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma mark ---病例消息字符串
extern NSString *const YBSendCaseMessageText;//发送病例的指令

#pragma mark ---微信消息字符串
extern NSString *const YBChangeWXMessageText;//请求交换微信
extern NSString *const YBAgreeChangeWXMessageText;//同意交换微信
extern NSString *const YBDisagreeChangeWXMessageText;//拒绝交换微信
extern NSString *const YBSendWXMessageText;//发送微信号


#pragma mark ---交换电话消息字符串
extern NSString *const YBChangePhoneNumberMessageText;//请求交换电话
extern NSString *const YBAgreeChangePhoneNumberMessageText;
extern NSString *const YBDisChangePhoneNumberMessageText;
extern NSString *const YBSendPhoneNumberText;


#pragma mark ---医生请求评价
extern NSString *const kYBRequestCommentMessageText;//医生请求评价
extern NSString *const kYBAgreeCommentMessageText;//病人同意评价
extern NSString *const kYBCommentSuccessMessageText;//病人评价成功
extern NSString *const kYBdisAgreeCommentMessageText;//病人拒绝评价



#pragma mark ---cell字符串
extern NSString *const YBChangeWXString;
extern NSString *const YBChangePhoneNumberString;

#pragma mark ---请求交换信息字符串
extern NSString *const YBChangePhoneMessageHaveSend;
extern NSString *const YBChangeWXMessageHaveSend;

#pragma mark ---请求交换结果信息字符串
extern NSString *const YBChangeWXYesByMeString;
extern NSString *const YBChangeWXNoByMeString;
extern NSString *const YBChangeWXYesByOppositeString;
extern NSString *const YBChangeWXNoByOppositeString;


extern NSString *const YBChangePhoneNumberYesByMeString;
extern NSString *const YBChangePhoneNumberNoByMeString;
extern NSString *const YBChangePhoneNumberYesByOppositeString;
extern NSString *const YBChangePhoneNumberNoByOppositeString;

#pragma mark ---附带信息key值
extern NSString *const YBisSendBack;//值：0-需要发回，1-不需发回
extern NSString *const YBMessageExtInfo;//值：放入手机号、微信号、病例id
extern NSString *const YBSendBackYES;
extern NSString *const YBSendBackNO;

#pragma mark ---消息编码再消息列表中的展示
extern NSString *const kYBRequestChangeWX;
extern NSString *const kYBRequestChangePhoneNumber;

extern NSString *const kYBHaveSendWXByMeString;
extern NSString *const kYBHaveSendWXByOppositeString;
extern NSString *const kYBHaveSendPhoneNumberByMeString ;
extern NSString *const kYBHaveSendPhoneNumberByOppositeString;
extern NSString *const kYBHaveSendCaseByMeString;
extern NSString *const kYBHaveSendCaseByOppositeString;

#pragma mark ---请求评价cell显示字符串
extern NSString *const kYBRequestCommentByMestring;
extern NSString *const kYBRequestCommentByOppositeString;
extern NSString *const kYBRequestCommentByOppositeShowInListString;
extern NSString *const kYBagreeCommentByOppositeString;
extern NSString *const kYBagreeCOmmentByMeString;

extern NSString *const kYBCommentSuccessByMeString;
extern NSString *const kYBCommentSuccessByOppositeString;

extern NSString *const kYBdisagreeCommentByMeString;
extern NSString *const kYBdisagreeCommentByOppositeString;

#pragma mark ---是否点击消息的键值、key值
extern NSString *const kYBHaveTouchChangeMessageKey; //是否点击扩展消息key值
extern NSString *const kYBNotTouchChangeMessageValue;
extern NSString *const kYBHaveTouchChangeMessageValue;
