//
//  LTxEepMBaseViewModel.h
//  AFNetworking
//
//  Created by liangtong on 2018/8/28.
//

#import <Foundation/Foundation.h>
#import <LTxCore/LTxCore.h>


//在修改密码和获取服务地址之后的回调中，需要做一些额外操作。比如存储和更新存储 密码，各种服务地址

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
+(void)changePasswordWithOldPassword:(NSString*)oldPassword newPassword:(NSString*)newPassword complete:(LTxStringCallbackBlock)complete;

/**
 * @brief 获取服务地址
 **/
+(void)appHostFetchComplete:(LTxStringAndArrayCallbackBlock)complete;

@end
