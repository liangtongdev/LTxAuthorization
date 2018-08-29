//
//  LTxEepMSettingViewModel.h
//  AFNetworking
//
//  Created by liangtong on 2018/8/28.
//

#import <Foundation/Foundation.h>
#import <LTxCore/LTxCore.h>

//检查更新回调代码
typedef void (^LTxSettingForSipprUpdateCallback)(BOOL,BOOL,NSDictionary*,NSString*);

@interface LTxEepMSettingViewModel : NSObject

///#begin
/**
 *    @brief    用户反馈
 */
///#end
+(void)userFeedbackWithOpinion:(NSString*)opinion
                      complete:(LTxStringCallbackBlock)complete;

///#begin
/**
 *    @brief    检查版本更新
 */
///#end
+(void)appUpdateCheckComplete:(LTxSettingForSipprUpdateCallback)complete;

///#begin
/**
 *    @brief    历史版本信息
 */
///#end
+(void)appUpdateHistoryFetchComplete:(LTxStringAndArrayCallbackBlock)complete;

@end
