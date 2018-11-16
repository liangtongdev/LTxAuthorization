//
//  LTxAppManageViewModel.h
//  AFNetworking
//
//  Created by liangtong on 2018/8/29.
//

#import <Foundation/Foundation.h>
#import <LTxCore/LTxCore.h>
#import <LTxEepMSippr/LTxEepMSippr.h>

#import "LTxLoginSipprViewController.h"

#define USERDEFAULT_APP_SERVICE_HOST @"USERDEFAULT_APP_SERVICE_HOST"//业务相关地址
#define USERDEFAULT_APP_MSG_HOST @"USERDEFAULT_APP_MSG_HOST"//消息服务业务地址
#define USERDEFAULT_APP_UPDATE_HOST @"USERDEFAULT_APP_UPDATE_HOST"//更新相关地址
#define USERDEFAULT_APP_SHARE_HOST @"USERDEFAULT_APP_SHARE_HOST"//分享相关地址
#define USERDEFAULT_REMIND_UPDATE_TIME @"USERDEFAULT_REMIND_UPDATE_TIME"//提醒更新时间
#define USERDEFAULT_USER_AUTHENTICATION_DATE @"USERDEFAULT_USER_AUTHENTICATION_DATE"//授权验证时间


#define USERDEFAULT_USER_ID @"USERDEFAULT_USER_ID"
#define USERDEFAULT_USER_LOGIN_NAME @"USERDEFAULT_USER_LOGIN_NAME"
#define USERDEFAULT_USER_LOGIN_PASSWORD @"USERDEFAULT_USER_LOGIN_PASSWORD"
#define USERDEFAULT_USER_NUMBER @"USERDEFAULT_USER_NUMBER"
#define USERDEFAULT_USER_NAME @"USERDEFAULT_USER_NAME"
#define USERDEFAULT_USER_NICKNAME @"USERDEFAULT_USER_NICKNAME"
#define USERDEFAULT_USER_AVATAR_IMAGE @"USERDEFAULT_USER_AVATAR_IMAGE"
#define USERDEFAULT_USER_SEX @"USERDEFAULT_USER_SEX"
#define USERDEFAULT_USER_DEPARTMENT @"USERDEFAULT_USER_DEPARTMENT"
#define USERDEFAULT_USER_PHONE_NUMBER @"USERDEFAULT_USER_PHONE_NUMBER"


#define USERDEFAULT_USER_EXTEND @"USERDEFAULT_USER_EXTEND"

/***
 * 程序管理模块
 **/
@interface LTxSipprAppViewModel : NSObject

@property (nonatomic, assign) BOOL updateExists;//是否有新版本需要更新
@property (nonatomic, assign) BOOL smsEnable;//短信验证服务是否开启
//单例
+ (instancetype)sharedInstance;

//程序Host获取，如果获取失败且缓存中存在host信息，本步骤可以跳过去
-(void)appHostFetchComplete:(LTxStringCallbackBlock)complete;
//检查更新
-(void)appUpdateCheckWithOpinion:(BOOL)showAlert callback:(LTxStringCallbackBlock)callback;
//快速登录/认证
-(void)userQuickLoginCallback:(LTxBoolCallbackBlock)quickLoginCallback;
//用户登录
-(void)userLoginWithName:(NSString*)loginName password:(NSString*)password complete:(LTxStringCallbackBlock)complete;
//手机号认证登录
-(void)userLoginWithPhone:(NSString*)phoneNumber smsCode:(NSString*)smsCode complete:(LTxStringCallbackBlock)complete;

//修改密码
-(void)userChangePassword:(NSString*)newPassword complete:(LTxStringCallbackBlock)complete;

//退出登录
-(void)userLogout;
//用户是否登陆
+(BOOL)isUserLogin;

#pragma mark - 主程序
//展示主页面
-(void)showMainViewAction;
//展示登录界面
-(void)showLoginViewAction;
@end
