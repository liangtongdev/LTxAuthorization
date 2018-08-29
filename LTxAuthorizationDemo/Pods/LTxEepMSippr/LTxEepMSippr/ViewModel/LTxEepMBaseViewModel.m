//
//  LTxEepMBaseViewModel.m
//  AFNetworking
//
//  Created by liangtong on 2018/8/28.
//

#import "LTxEepMBaseViewModel.h"

@implementation LTxEepMBaseViewModel
/**
 * @brief 用户名认证登录
 **/
+(void)loginWithName:(NSString*)username password:(NSString*)password complete:(LTxAuthorizationCallbackBlock)complete{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    LTxCoreConfig* config = [LTxCoreConfig sharedInstance];
    if (username) {
        [params setObject:username forKey:@"username"];
    }
    if (password) {
        [params setObject:password forKey:@"password"];
    }
    if (config.appId) {
        [params setObject:config.appId forKey:@"appId"];
    }
    NSString* url = [NSString stringWithFormat:@"%@/v1/api/mobile/user/authentication",config.host];
    //网络访问
    [LTxCoreHttpService doPostWithURL:url param:params complete:^(NSString *errorTips, id data) {
        if (complete) {
            BOOL success;
            if (!errorTips) {
                success = YES;
            }else{
                if (data) {//实际上是认证失败了
                    success = NO;
                }else{
                    success = YES;
                }
            }
            NSDictionary* firstItem;
            if ([data count] > 0) {
                firstItem = [data objectAtIndex:0];
            }
            complete(success,errorTips,firstItem);
        }
    }];
}

/**
 * @brief 手机号认证登录
 **/
+(void)loginWithPhone:(NSString*)phoneNumber smsCode:(NSString*)smsCode complete:(LTxAuthorizationCallbackBlock)complete{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    LTxCoreConfig* config = [LTxCoreConfig sharedInstance];
    NSString* deviceCode = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    if (config.appId) {
        [params setObject:config.appId forKey:@"appId"];
    }
    if (phoneNumber) {
        [params setObject:phoneNumber forKey:@"phoneNumber"];
    }
    if (deviceCode) {
        [params setObject:deviceCode forKey:@"deviceCode"];
    }
    if (smsCode) {
        [params setObject:smsCode forKey:@"smsCode"];
    }
    
    NSString* url = [NSString stringWithFormat:@"%@/v1/api/mobile/user/authentication/%@",config.host,phoneNumber];
    //网络访问
    [LTxCoreHttpService doPostWithURL:url param:params complete:^(NSString *errorTips, id data) {
        if (complete) {
            BOOL success;
            if (!errorTips) {
                success = YES;
            }else{
                if (data) {//实际上是认证失败了
                    success = NO;
                }else{
                    success = YES;
                }
            }
            NSDictionary* firstItem;
            if ([data count] > 0) {
                firstItem = [data objectAtIndex:0];
            }
            complete(success,errorTips,firstItem);
        }
    }];
}

///#begin
/**
 *@brief 修改登录密码
 */
///#end
+(void)changePasswordWithNewPassword:(NSString*)newPassword complete:(LTxStringCallbackBlock)complete{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    LTxCoreConfig* config = [LTxCoreConfig sharedInstance];
    if (config.userId) {
        [params setObject:config.userId forKey:@"userId"];
    }
    if (newPassword) {
        [params setObject:newPassword forKey:@"newPassword"];
    }
    NSString* oldPassword = [NSUserDefaults lt_objectForKey:USERDEFAULT_USER_LOGIN_PASSWORD];
    if (oldPassword) {
        [params setObject:oldPassword forKey:@"oldPassword"];
    }
    
    NSString* url = [NSString stringWithFormat:@"%@/v1/api/mobile/user/password",config.host];
    //网络访问
    [LTxCoreHttpService doPostWithURL:url param:params complete:^(NSString *errorTips, id data) {
        if (complete) {
            complete(errorTips);
        }
        if (!errorTips) {
            [NSUserDefaults lt_setObject:newPassword forKey:USERDEFAULT_USER_LOGIN_PASSWORD];
        }
    }];
}

/**
 * @brief 获取服务地址
 **/
+(void)appHostFetchComplete:(LTxStringCallbackBlock)complete{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    LTxCoreConfig* config = [LTxCoreConfig sharedInstance];
    if (config.userId) {
        [params setObject:config.userId forKey:@"userId"];
    }
    
    
    NSString* url = [NSString stringWithFormat:@"%@/v1/api/mobile/app/host/%@",config.host,config.appId];
    //网络访问
    [LTxCoreHttpService doGetWithURL:url param:params complete:^(NSString *errorTips, id data) {
        NSArray* hostArray = (NSArray*)data;
        if ([hostArray count] > 0) {
            for (NSDictionary* hostDic in hostArray) {
                NSString* configKey = [hostDic objectForKey:@"configKey"];
                NSString* configValue = [hostDic objectForKey:@"configValue"];
                if (configKey && configValue) {
                    if ([configKey isEqualToString:@"app_update_host"]) {
                        [NSUserDefaults lt_setObject:configValue forKey:USERDEFAULT_APP_UPDATE_HOST];
                    }else if ([configKey isEqualToString:@"app_service_host"]) {
                        [NSUserDefaults lt_setObject:configValue forKey:USERDEFAULT_APP_SERVICE_HOST];
                    }else if ([configKey isEqualToString:@"app_share_host"]) {
                        [NSUserDefaults lt_setObject:configValue forKey:USERDEFAULT_APP_SHARE_HOST];
                    }else if ([configKey isEqualToString:@"app_message_host"]) {
                        [NSUserDefaults lt_setObject:configValue forKey:USERDEFAULT_APP_MSG_HOST];
                    }
                }
            }
            if (complete) {
                complete(errorTips);
            }
        }else{
            if (complete) {
                complete(errorTips);
            }
        }
        
        
    }];
}
@end
