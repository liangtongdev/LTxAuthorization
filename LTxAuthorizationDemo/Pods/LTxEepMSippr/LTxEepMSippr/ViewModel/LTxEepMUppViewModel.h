//
//  LTxEepMUppViewModel.h
//  AFNetworking
//
//  Created by liangtong on 2018/8/28.
//

#import <Foundation/Foundation.h>
#import <LTxCore/LTxCore.h>

/*消息相关接口*/
@interface LTxEepMUppViewModel : NSObject

/**
 * 推送定制 - 消息类别获取
 **/
+(void)pushTypeListFetchComplete:(LTxStringAndArrayCallbackBlock)complete;

/**
 * 推送定制 - 定制消息类别
 **/
+(void)diyPushTypeList:(NSSet*)pushTypeSet complete:(LTxStringCallbackBlock)complete;


/**
 * 消息 - 消息类别及该类别下未读的消息及数量
 **/
+(void)msgTypeOverviewListFetchComplete:(LTxStringAndArrayCallbackBlock)complete;

/**
 * 消息 - 消息类别下的所有消息置为已读
 **/
+(void)updateMsgTypeReadStateWithMsgType:(NSString*)messageType complete:(LTxCallbackBlock)complete;

/**
 * 消息 - 特定消息类别下的消息列表获取
 **/
+(void)msgListFetchWithMsgType:(NSString*)messageType currentPage:(NSInteger)currentPage maxResult:(NSInteger)maxResult complete:(LTxStringAndArrayCallbackBlock)complete;

/**
 * 消息 - 特定的消息获取
 **/

+(void)msgDetailWithMsgId:(NSString*)messageId userNumber:(NSString*)userNumber complete:(LTxStringAndDictionaryCallbackBlock)complete;

/**
 * 消息 - 将某一条消息的阅读状态置为已读
 **/
+(void)updateMsgReadStateWithMsgId:(NSString*)messageId complete:(LTxStringCallbackBlock)complete;

/**
 * 消息 - 将多条消息的阅读状态置为已读
 **/
+(void)updateMsgReadStateWithMsgIds:(NSString*)messageIds complete:(LTxStringCallbackBlock)complete;

/**
 * 消息 - 将某一条消息的阅读状态置为已读
 **/
+(void)updateMsgReadStateWithMsgGuid:(NSString*)guid complete:(LTxStringCallbackBlock)complete;

/**
 * 消息 - 根据业务编码获取消息详情
 **/
+(void)msgDetailWithMsgRowGuid:(NSString*)messageRowGuid complete:(LTxStringAndDictionaryCallbackBlock)complete;

/**
 * 消息 - 发送消息到服务器
 **/
+(void)msgSendToServer:(NSString*)msgs complete:(LTxStringCallbackBlock)complete;

#pragma mark - SMS
/**
 * 发送验证码
 **/
+(void)sendSmsCode:(NSString*)phoneNumber operateType:(NSInteger)operateType complete:(LTxStringCallbackBlock)complete;
/**
 * 发送验证码
 **/
+(void)validateSmsCode:(NSString*)phoneNumber authCode:(NSString*)authCode complete:(LTxStringCallbackBlock)complete;

@end
