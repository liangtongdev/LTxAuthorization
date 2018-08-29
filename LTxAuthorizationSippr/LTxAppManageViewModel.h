//
//  LTxAppManageViewModel.h
//  AFNetworking
//
//  Created by liangtong on 2018/8/29.
//

#import <Foundation/Foundation.h>
#import <LTxCore/LTxCore.h>
#import <LTxEepMSippr/LTxEepMSippr.h>


#define USERDEFAULT_REMIND_UPDATE_TIME @"USERDEFAULT_REMIND_UPDATE_TIME"

/***
 * 程序管理模块
 **/
@interface LTxAppManageViewModel : NSObject

@property (nonatomic, assign) BOOL updateExists;//是否有新版本需要更新
//单例
+ (instancetype)sharedInstance;

//程序Host获取，如果获取失败且缓存中存在host信息，本步骤可以跳过去
+(void)appHostFetchComplete:(LTxStringCallbackBlock)complete;
//检查更新
+(void)appUpdateCheckWithOpinion:(BOOL)showAlert callback:(LTxStringCallbackBlock)callback;
//快速登录/认证
+(void)userQuickLoginCallback:(LTxBoolCallbackBlock)quickLoginCallback;

#pragma mark - 登录/认证
//用户登录
+(void)userLoginWithName:(NSString*)name password:(NSString*)password complete:(LTxStringCallbackBlock)complete;

//退出登录
+(void)logout;
@end
