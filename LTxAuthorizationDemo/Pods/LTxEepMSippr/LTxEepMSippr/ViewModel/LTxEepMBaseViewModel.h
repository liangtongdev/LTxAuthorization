//
//  LTxEepMBaseViewModel.h
//  AFNetworking
//
//  Created by liangtong on 2018/8/28.
//

#import <Foundation/Foundation.h>
#import <LTxCore/LTxCore.h>


typedef void (^LTxAuthorizationCallbackBlock)(BOOL, NSString*, NSDictionary*);


@interface LTxEepMBaseViewModel : NSObject

/**
 * @brief 用户名认证登录
 **/
+(void)loginWithName:(NSString*)username password:(NSString*)password complete:(LTxAuthorizationCallbackBlock)complete;

/**
 * @brief 手机号认证登录
 **/
+(void)loginWithPhone:(NSString*)phoneNumber smsCode:(NSString*)smsCode complete:(LTxAuthorizationCallbackBlock)complete;

///#begin
/**
 *@brief 修改登录密码
 */
///#end
+(void)changePasswordWithNewPassword:(NSString*)newPassword complete:(LTxStringCallbackBlock)complete;

/**
 * @brief 获取服务地址
 **/
+(void)appHostFetchComplete:(LTxStringCallbackBlock)complete;

@end
