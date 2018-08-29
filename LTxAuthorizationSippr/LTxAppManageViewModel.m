//
//  LTxAppManageViewModel.m
//  AFNetworking
//
//  Created by liangtong on 2018/8/29.
//

#import "LTxAppManageViewModel.h"

@implementation LTxAppManageViewModel

/**
 * 单例模式
 **/
static LTxAppManageViewModel *_instance;
+ (instancetype)sharedInstance{
    static dispatch_once_t onceTokenLTxAppManageViewModel;
    dispatch_once(&onceTokenLTxAppManageViewModel, ^{
        _instance = [[LTxAppManageViewModel alloc] init];
    });
    
    return _instance;
}


//程序Host获取，如果获取失败且缓存中存在host信息，本步骤可以跳过去
+(void)appHostFetchComplete:(LTxStringCallbackBlock)complete{
    [LTxEepMBaseViewModel appHostFetchComplete:^(NSString* errorTips) {
        if (errorTips) {
            NSString* appUpdateHost = [NSUserDefaults lt_objectForKey:USERDEFAULT_APP_UPDATE_HOST];
            if (appUpdateHost) {//缓存中存在数据，则本次可以跳过去
                errorTips = nil;
            }
        }
        //更新全局变量
        [LTxCoreConfig sharedInstance].eepmHost = [NSUserDefaults lt_objectForKey:USERDEFAULT_APP_UPDATE_HOST];
        [LTxCoreConfig sharedInstance].serviceHost = [NSUserDefaults lt_objectForKey:USERDEFAULT_APP_SERVICE_HOST];
        [LTxCoreConfig sharedInstance].messageHost = [NSUserDefaults lt_objectForKey:USERDEFAULT_APP_MSG_HOST];
        [LTxCoreConfig sharedInstance].shareHost = [NSUserDefaults lt_objectForKey:USERDEFAULT_APP_SHARE_HOST];
        if (complete) {
            complete(errorTips);
        }
    }];
}
//检查更新
+(void)appUpdateCheckWithOpinion:(BOOL)showAlertOpinion callback:(LTxStringCallbackBlock)callback{
    [LTxEepMSettingViewModel appUpdateCheckComplete:^(BOOL newVersionExists, BOOL updateForced,NSDictionary* updateInfo, NSString *errorTips) {
        if (errorTips) {//检查更新失败了。
            if (callback) {
                callback(errorTips);
            }
        }else{//接口调用OK，查看是否有版本更新和强制更新信息
            [LTxAppManageViewModel sharedInstance].updateExists = newVersionExists;
            if(newVersionExists){
                BOOL showAlert = YES;
                if(!updateForced && !showAlertOpinion){//非强制更新时，检查是否有1天间隔
                    NSDate* remindToUpdateDate = [NSUserDefaults lt_objectForKey:USERDEFAULT_REMIND_UPDATE_TIME];
                    if (remindToUpdateDate && [[NSDate date] timeIntervalSinceDate:remindToUpdateDate] < 86400) {
                        showAlert = NO;
                    }
                }
                if (showAlert) {
                    NSString* updateContent = [updateInfo objectForKey:@"updateContent"];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"发现新版本" message:updateContent preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* updateAction = [UIAlertAction actionWithTitle:@"马上更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        NSString* updateLink = [updateInfo objectForKey:@"updateLink"];
                        NSURL* url = [NSURL URLWithString:updateLink];
                        if (url) {
                            [[UIApplication sharedApplication ] openURL:url];
                            exit(0);
                        }
                    }];
                    [alertController addAction:updateAction];
                    
                    if (!updateForced) {//非强制更新，添加一个「稍后更新」的按钮
                        UIAlertAction *laterAction = [UIAlertAction actionWithTitle:@"稍后再说" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                            [NSUserDefaults lt_setObject:[NSDate dateWithTimeIntervalSinceNow:86400] forKey:USERDEFAULT_REMIND_UPDATE_TIME];
                            if (callback) {//稍后更新
                                callback(nil);
                            }
                        }];
                        [alertController addAction:laterAction];
                    }
                    
                    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
                    if (popover) {
                        UIView* sourceView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
                        popover.sourceView = sourceView;
                        CGRect frame = sourceView.frame;
                        frame.origin = CGPointMake(80, 100);
                        frame.size.width -= 160;
                        frame.size.height -= 200;
                        popover.sourceRect = frame;
                        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{//展示提示框
                        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
                    });
                }else{//一天内已经提醒过这个非强制更新版本了
                    if (callback) {
                        callback(nil);
                    }
                }
            }else{
                if (callback) {//没有版本更新
                    callback(nil);
                }
            }
        }
    }];
}

//快速登录/认证
+(void)userQuickLoginCallback:(LTxBoolCallbackBlock)quickLoginCallback{
    //首先检查用户是否登录，如果没有登录，则直接回调NO；
    NSString* userNumber = [NSUserDefaults lt_objectForKey:USERDEFAULT_USER_NUMBER];
    if (!userNumber) {
        if(quickLoginCallback){
            quickLoginCallback(NO);
        }
    }else{
        
        //超时检查
        NSDate* authDate = [NSUserDefaults lt_objectForKey:@"USERDEFAULT_USER_AUTHENTICATION_DATE"];
        NSDate* now = [NSDate date];
        if (authDate && [now timeIntervalSinceDate:authDate] > 2592000){
            if(quickLoginCallback){
                quickLoginCallback(NO);
            }
            return;
        }else{
            [NSUserDefaults lt_setObject:now forKey:@"USERDEFAULT_USER_AUTHENTICATION_DATE"];
        }
        
        NSString* userLoginName = [NSUserDefaults lt_objectForKey:USERDEFAULT_USER_LOGIN_NAME];
        NSString* userPassword = [NSUserDefaults lt_objectForKey:USERDEFAULT_USER_LOGIN_PASSWORD];
        [LTxEepMBaseViewModel loginWithName:userLoginName password:userPassword complete:^(BOOL success, NSString * errorTips, NSDictionary *data) {
            
            if (data) {//登陆成功了，缓存各种登录数据即可
                [LTxAppManageViewModel cacheUserLoginInfo:data];
            }
            if (success) {
                [LTxCoreConfig sharedInstance].userId = [NSUserDefaults lt_objectForKey:USERDEFAULT_USER_NUMBER];//更新全局变量
            }
            if(quickLoginCallback){
                quickLoginCallback(success);
            }
        }];
    }
}


#pragma mark - 登录/认证
//用户登录
+(void)userLoginWithName:(NSString*)name password:(NSString*)password complete:(LTxStringCallbackBlock)complete{
    NSString* md5Password = [password ltx_md5String];
    [LTxEepMBaseViewModel loginWithName:name password:md5Password complete:^(BOOL success, NSString * errorTips, NSDictionary *data) {
        if (data) {//登陆成功了，缓存各种登录数据即可
            [LTxAppManageViewModel cacheUserLoginInfo:data];
            //存储密码
            [NSUserDefaults lt_setObject:md5Password forKey:USERDEFAULT_USER_LOGIN_PASSWORD];
        }
        if (complete) {
            complete(errorTips);
        }
    }];
}

+(void)cacheUserLoginInfo:(NSDictionary*)userInfo{
    if (userInfo) {
        
        [NSUserDefaults lt_setObject:[NSDate date] forKey:@"USERDEFAULT_USER_AUTHENTICATION_DATE"];
        
        NSDictionary* userBase = [userInfo objectForKey:@"user"];
        NSDictionary* extendData = [userInfo objectForKey:@"extendData"];
        if (userBase) {
            NSNumber* userId = [userBase objectForKey:@"id"];
            NSString* userNumber = [userBase objectForKey:@"number"];
            NSString* userName = [userBase objectForKey:@"name"];
            NSString* userLoginName = [userBase objectForKey:@"username"];
            NSString* loginPassword = [userBase objectForKey:@"loginPassword"];
            NSString* nickname = [userBase objectForKey:@"nickname"];
            NSString* userPic = [NSString stringWithFormat:@"%@/%@",[LTxCoreConfig sharedInstance].host, [userBase objectForKey:@"userPicRelativePath"]];
            NSNumber* sex = [userBase objectForKey:@"sex"];
            NSString* phoneNumber = [userBase objectForKey:@"phoneNumber"];
            
            //            NSString* departmentId = [userBase objectForKey:@"departmentId"];
            NSString* departmentName = [userBase objectForKey:@"departmentName"];
            //            NSString* enterpriseId = [userBase objectForKey:@"enterpriseId"];
            //            NSString* enterpriseName = [userBase objectForKey:@"enterpriseName"];
            //            NSString* enterpriseNumber = [userBase objectForKey:@"enterpriseNumber"];
            [NSUserDefaults lt_setObject:userId forKey:USERDEFAULT_USER_ID];
            [NSUserDefaults lt_setObject:userNumber forKey:USERDEFAULT_USER_NUMBER];
            [NSUserDefaults lt_setObject:userName forKey:USERDEFAULT_USER_NAME];
            [NSUserDefaults lt_setObject:userLoginName forKey:USERDEFAULT_USER_LOGIN_NAME];
            [NSUserDefaults lt_setObject:loginPassword forKey:USERDEFAULT_USER_LOGIN_PASSWORD];
            [NSUserDefaults lt_setObject:nickname forKey:USERDEFAULT_USER_NICKNAME];
            [NSUserDefaults lt_setObject:userPic forKey:USERDEFAULT_USER_AVATAR_IMAGE];
            [NSUserDefaults lt_setObject:sex forKey:USERDEFAULT_USER_SEX];
            [NSUserDefaults lt_setObject:phoneNumber forKey:USERDEFAULT_USER_PHONE_NUMBER];
            [NSUserDefaults lt_setObject:departmentName forKey:USERDEFAULT_USER_DEPARTMENT];
        }
        if (extendData) {
            
        }
    }
}

//退出登录
+(void)logout{
    [NSUserDefaults lt_removeDefaultAppObjects];//清除用户数据
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;//程序角标更新
}
@end
