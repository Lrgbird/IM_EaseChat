//
//  YBChatMessageText.m
//  yb
//
//  Created by LRG on 2017/6/7.
//  Copyright © 2017年 wsb0617@foxmail.com. All rights reserved.
//

#import "YBChatMessageText.h"

#pragma mark ---病例消息字符串
NSString *const YBSendCaseMessageText = @"#sendCase#";//发送病例的指令


#pragma mark ---微信消息字符串
NSString *const YBChangeWXMessageText = @"#changeWX#";
NSString *const YBAgreeChangeWXMessageText = @"#agreeChangeWX#";
NSString *const YBDisagreeChangeWXMessageText = @"#disagreeChangeWX#";
NSString *const YBSendWXMessageText = @"#sendWX#";





#pragma mark ---交换电话消息字符串
NSString *const YBChangePhoneNumberMessageText =@"#changePhoneNumber#";
NSString *const YBAgreeChangePhoneNumberMessageText = @"#agreeChangePhoneNumber#";
NSString *const YBDisChangePhoneNumberMessageText = @"#disagreeChangePhoneNumber#";
NSString *const YBSendPhoneNumberText = @"#sendPhoneNumber#";

#pragma mark ---医生请求评价
NSString *const kYBRequestCommentMessageText = @"#requestComment#";//医生请求评价
NSString *const kYBAgreeCommentMessageText = @"#agreeComment#";//病人同意评价
NSString *const kYBCommentSuccessMessageText = @"#commentSuccess#";//病人评价成功
NSString *const kYBdisAgreeCommentMessageText = @"#disagreeComment#";//病人拒绝评价

#pragma mark ---cell上字符串
NSString *const YBChangeWXString = @"我想要与您交换微信号\n您是否同意";
NSString *const YBChangePhoneNumberString = @"我想要与您交换手机号\n您是否同意";


#pragma mark ---请求交换信息字符串
NSString *const YBChangePhoneMessageHaveSend = @"交换手机号请求已发送";
NSString *const YBChangeWXMessageHaveSend = @"交换微信号请求已发送";

#pragma mark ---请求交换结果信息字符串
NSString *const YBChangeWXYesByMeString = @"我已同意交换微信";
NSString *const YBChangeWXNoByMeString = @"我已拒绝交换微信";
NSString *const YBChangeWXYesByOppositeString = @"对方同意交换微信";
NSString *const YBChangeWXNoByOppositeString = @"对方拒绝交换微信";

NSString *const YBChangePhoneNumberYesByMeString = @"我已同意交换手机号";
NSString *const YBChangePhoneNumberNoByMeString = @"我已拒绝交换手机号";
NSString *const YBChangePhoneNumberYesByOppositeString = @"对方同意交换手机号";
NSString *const YBChangePhoneNumberNoByOppositeString = @"对方拒绝交换手机号";


#pragma mark ---附带信息key值
NSString *const YBisSendBack = @"shouldSendBack";//值：0-需要发回，1-不需发回
NSString *const YBMessageExtInfo = @"info";//值：放入手机号、微信号、病例id
NSString *const YBSendBackYES = @"1";
NSString *const YBSendBackNO = @"0";


#pragma mark ---消息编码再消息列表中的展示
NSString *const kYBRequestChangeWX = @"请求交换微信";
NSString *const kYBRequestChangePhoneNumber = @"请求交换电话";
NSString *const kYBRequestChangeCase = @"请求发送病例";

NSString *const kYBHaveSendWXByMeString = @"我已发送微信号";
NSString *const kYBHaveSendWXByOppositeString = @"对方已发送微信号";
NSString *const kYBHaveSendPhoneNumberByMeString = @"我已发送电话号";
NSString *const kYBHaveSendPhoneNumberByOppositeString = @"对方已发送电话号";
NSString *const kYBHaveSendCaseByMeString = @"我已发送病例";
NSString *const kYBHaveSendCaseByOppositeString = @"对方已发送病例";


#pragma mark ---请求评价cell显示字符串
NSString *const kYBRequestCommentByMestring = @"请求评价已发送";
NSString *const kYBRequestCommentByOppositeString = @"请您为本次问诊服务评价\n您是否同意";
NSString *const kYBRequestCommentByOppositeShowInListString = @"对方请您评价此次问诊服务";

NSString *const kYBagreeCommentByOppositeString = @"对方已接受您的评价请求";
NSString *const kYBagreeCOmmentByMeString = @"我已同意评价";

NSString *const kYBCommentSuccessByMeString = @"我已评价成功";
NSString *const kYBCommentSuccessByOppositeString =@"评价成功,请前问诊评价查看";
NSString *const kYBdisagreeCommentByMeString = @"我已拒绝评价对方";
NSString *const kYBdisagreeCommentByOppositeString = @"对方已拒绝评价我";

#pragma mark ---是否点击消息的键值、key值
NSString *const kYBHaveTouchChangeMessageKey = @"isHaveTouchMessageKey"; //是否点击扩展消息key值
NSString *const kYBNotTouchChangeMessageValue = @"notTouch";
NSString *const kYBHaveTouchChangeMessageValue = @"haveTouch";


