//
//  LTxAppManageViewModel.m
//  AFNetworking
//
//  Created by liangtong on 2018/8/29.
//

#import "LTxSipprAppViewModel.h"

@implementation LTxSipprAppViewModel

/**
 * 单例模式
 **/
static LTxSipprAppViewModel *_instance;
+ (instancetype)sharedInstance{
    static dispatch_once_t onceTokenLTxSipprAppViewModel;
    dispatch_once(&onceTokenLTxSipprAppViewModel, ^{
        _instance = [[LTxSipprAppViewModel alloc] init];
        [_instance setupDefaultValues];
    });
    
    return _instance;
}

/**
 * 默认初始化
 **/
-(void)setupDefaultValues{
    _updateExists = NO;
    _smsEnable = NO;
}

//程序Host获取，如果获取失败且缓存中存在host信息，本步骤可以跳过去
-(void)appHostFetchComplete:(LTxStringCallbackBlock)complete{
    [LTxEepMBaseViewModel appHostFetchComplete:^(NSString *errorTips, NSArray *hostArray) {
        if (!errorTips) {
            for (NSDictionary* hostDic in hostArray) {
                NSString* configKey = [hostDic objectForKey:@"configKey"];
                NSString* configValue = [hostDic objectForKey:@"configValue"];
                if (configKey && configValue) {
                    if ([configKey isEqualToString:@"app_update_host"]) {
                        [NSUserDefaults ltx_setObject:configValue forKey:USERDEFAULT_APP_UPDATE_HOST];
                        [LTxCoreConfig sharedInstance].eepmHost = configValue;
                    }else if ([configKey isEqualToString:@"app_service_host"]) {
                        [NSUserDefaults ltx_setObject:configValue forKey:USERDEFAULT_APP_SERVICE_HOST];
                        [LTxCoreConfig sharedInstance].serviceHost = configValue;
                    }else if ([configKey isEqualToString:@"app_share_host"]) {
                        [NSUserDefaults ltx_setObject:configValue forKey:USERDEFAULT_APP_SHARE_HOST];
                        [LTxCoreConfig sharedInstance].shareHost = configValue;
                    }else if ([configKey isEqualToString:@"app_message_host"]) {
                        [NSUserDefaults ltx_setObject:configValue forKey:USERDEFAULT_APP_MSG_HOST];
                        [LTxCoreConfig sharedInstance].messageHost = configValue;
                    }
                }
            }
        }
        if (complete) {
            if (errorTips) {
                NSString* updateHost = [NSUserDefaults ltx_objectForKey:USERDEFAULT_APP_UPDATE_HOST];
                if (updateHost) {
                    complete(nil);
                }else{
                    complete(errorTips);
                }
            }else{
                complete(nil);
            }
        }
        
    }];
}
-(void)appUpdateCheckWithOpinion:(BOOL)showAlertOpinion callback:(LTxStringCallbackBlock)callback{
    [LTxEepMSettingViewModel appUpdateCheckComplete:^(BOOL newVersionExists, BOOL updateForced, NSDictionary * updateInfo, NSString * errorTips) {
        if (errorTips) {
            if(callback){
                callback(errorTips);
            }
        }else{//接口调用OK，查看是否有版本更新和强制更新信息
            [LTxSipprAppViewModel sharedInstance].updateExists = newVersionExists;
            if (newVersionExists) {
                BOOL showAlert = YES;
                //是否需要显示弹出框
                if(!updateForced && !showAlertOpinion){//非强制更新时，检查是否有1天间隔
                    NSDate* remindToUpdateDate = [NSUserDefaults ltx_objectForKey:USERDEFAULT_REMIND_UPDATE_TIME];
                    if (remindToUpdateDate && [[NSDate date] timeIntervalSinceDate:remindToUpdateDate] < 86400) {
                        showAlert = NO;
                    }
                }
                //需要展示更新提示框
                if (showAlert) {
                    NSString* updateContent = [updateInfo objectForKey:@"updateContent"];
                    //马上更新按钮
                    UIAlertAction* updateAction = [UIAlertAction actionWithTitle:@"马上更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        NSString* updateLink = [updateInfo objectForKey:@"updateLink"];
                        NSURL* url = [NSURL URLWithString:updateLink];
                        if (url) {
                            [[UIApplication sharedApplication ] openURL:url];
                            exit(0);
                        }
                    }];
                    
                    UIView* sourceView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
                    CGRect frame = sourceView.frame;
                    frame.size.width -= 160;
                    frame.size.height -= 200;
                    UIAlertController* alertController = [UIAlertController ltxAlertControllerWithTitle:@"发现新版本" message:updateContent style:UIAlertControllerStyleAlert sourceView:sourceView];
                    [alertController addAction:updateAction];
                    if (!updateForced) {//非强制更新，添加个稍后更新按钮
                        //稍后更新
                        UIAlertAction *laterAction = [UIAlertAction actionWithTitle:@"稍后再说" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                            [NSUserDefaults ltx_setObject:[NSDate dateWithTimeIntervalSinceNow:86400] forKey:USERDEFAULT_REMIND_UPDATE_TIME];
                            if (callback) {//稍后更新
                                callback(nil);
                            }
                        }];
                        [alertController addAction:laterAction];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{//展示提示框
                        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
                    });
                }else{//一天内已经提醒过这个非强制更新版本了
                    if (callback) {
                        callback(nil);
                    }
                }
            }else{//没有版本更新
                if (callback) {
                    callback(nil);
                }
            }
        }
    }];
}
//快速登录/认证
-(void)userQuickLoginCallback:(LTxBoolCallbackBlock)quickLoginCallback{
    //首先检查用户是否登录，如果没有登录
    NSString* userNumber = [NSUserDefaults ltx_objectForKey:USERDEFAULT_USER_NUMBER];
    if (!userNumber) {
        if(quickLoginCallback){
            quickLoginCallback(NO);
        }
    }else{
        //超时检查
        NSDate* authDate = [NSUserDefaults ltx_objectForKey:USERDEFAULT_USER_AUTHENTICATION_DATE];
        NSDate* now = [NSDate date];
        if (authDate && [now timeIntervalSinceDate:authDate] > 2592000){
            [self userLogout];
            if(quickLoginCallback){
                quickLoginCallback(NO);
            }
        }else{
            [NSUserDefaults ltx_setObject:now forKey:USERDEFAULT_USER_AUTHENTICATION_DATE];
            NSString* userLoginName = [NSUserDefaults ltx_objectForKey:USERDEFAULT_USER_LOGIN_NAME];
            NSString* userPassword = [NSUserDefaults ltx_objectForKey:USERDEFAULT_USER_LOGIN_PASSWORD];
            __weak __typeof(self) weakSelf = self;
            [LTxEepMBaseViewModel loginWithName:userLoginName password:userPassword complete:^(BOOL success, NSString *errorTips, NSDictionary *userInfoDic) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if (!errorTips) {
                    [strongSelf cacheUserLoginInfo:userInfoDic];
                }
                if(quickLoginCallback){
                    quickLoginCallback(success);
                }
            }];
        }
    }
}

//用户登录
-(void)userLoginWithName:(NSString*)loginName password:(NSString*)password complete:(LTxStringCallbackBlock)complete{
    __weak __typeof(self) weakSelf = self;
    NSString* md5_pwd = [password ltx_md5String];
    [LTxEepMBaseViewModel loginWithName:loginName password:md5_pwd complete:^(BOOL success, NSString *errorTips, NSDictionary *userInfoDic) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (!errorTips) {
            [strongSelf cacheUserLoginInfo:userInfoDic];
        }
        if(complete){
            complete(errorTips);
        }
        //用户名+密码认证的时候，不返密码「返回的字段为空」
        [NSUserDefaults ltx_setObject:md5_pwd forKey:USERDEFAULT_USER_LOGIN_PASSWORD];
    }];
}

//手机号认证登录
-(void)userLoginWithPhone:(NSString*)phoneNumber smsCode:(NSString*)smsCode complete:(LTxStringCallbackBlock)complete{
    __weak __typeof(self) weakSelf = self;
    [LTxEepMBaseViewModel loginWithPhone:phoneNumber smsCode:smsCode complete:^(BOOL success, NSString *errorTips, NSDictionary *userInfoDic) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (!errorTips) {
            [strongSelf cacheUserLoginInfo:userInfoDic];
        }
        if(complete){
            complete(errorTips);
        }
    }];
}

//修改密码
-(void)userChangePassword:(NSString*)newPassword complete:(LTxStringCallbackBlock)complete{
    __weak __typeof(self) weakSelf = self;
    NSString* oldPwd = [NSUserDefaults ltx_objectForKey:USERDEFAULT_USER_LOGIN_PASSWORD];
    NSString* newMd5Pwd = [newPassword ltx_md5String];
    [LTxEepMBaseViewModel changePasswordWithOldPassword:oldPwd newPassword:newMd5Pwd  complete:^( NSString *errorTips) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (!errorTips) {
            [NSUserDefaults ltx_setObject:newMd5Pwd forKey:USERDEFAULT_USER_LOGIN_PASSWORD];
        }
        if(complete){
            complete(errorTips);
        }
    }];
}

//退出登录
-(void)userLogout{
    
    /**
     * 用户信息
     **/
    [NSUserDefaults ltx_removeObjectForKey:USERDEFAULT_USER_ID];
    [NSUserDefaults ltx_removeObjectForKey:USERDEFAULT_USER_LOGIN_NAME];
    [NSUserDefaults ltx_removeObjectForKey:USERDEFAULT_USER_LOGIN_PASSWORD];
    [NSUserDefaults ltx_removeObjectForKey:USERDEFAULT_USER_NUMBER];
    [NSUserDefaults ltx_removeObjectForKey:USERDEFAULT_USER_NAME];
    [NSUserDefaults ltx_removeObjectForKey:USERDEFAULT_USER_NICKNAME];
    [NSUserDefaults ltx_removeObjectForKey:USERDEFAULT_USER_AVATAR_IMAGE];
    [NSUserDefaults ltx_removeObjectForKey:USERDEFAULT_USER_SEX];
    [NSUserDefaults ltx_removeObjectForKey:USERDEFAULT_USER_DEPARTMENT];
    [NSUserDefaults ltx_removeObjectForKey:USERDEFAULT_USER_PHONE_NUMBER];
    //扩展信息
    [NSUserDefaults ltx_removeObjectForKey:USERDEFAULT_USER_EXTEND];
    
    /**
     * 当前使用
     **/
    [LTxCoreConfig sharedInstance].userId = nil;
    [LTxCoreConfig sharedInstance].userNumber = nil;
    
    
}
//用户是否登陆
+(BOOL)isUserLogin{
    NSString* userNumber = [NSUserDefaults ltx_objectForKey:USERDEFAULT_USER_NUMBER];
    if (userNumber) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - 主程序
//展示主页面
-(void)showMainViewAction{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *mainTab = [story instantiateViewControllerWithIdentifier:@"mainTab"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].keyWindow.rootViewController = mainTab;
    });
}

//展示登录界面
-(void)showLoginViewAction{
    LTxLoginSipprViewController* loginVC = [[LTxLoginSipprViewController alloc] init];
    LTxCoreBaseNavi* loginNavi = [[LTxCoreBaseNavi alloc] initWithRootViewController:loginVC];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].keyWindow.rootViewController = loginNavi;
    });
}


#pragma mark - Private
-(void)cacheUserLoginInfo:(NSDictionary*)userInfo{
    //更新认证时间
    [NSUserDefaults ltx_setObject:[NSDate date] forKey:USERDEFAULT_USER_AUTHENTICATION_DATE];
    
    //基本信息和扩展信息
    NSDictionary* basic = [userInfo objectForKey:@"user"];
    NSDictionary* extend = [userInfo objectForKey:@"extendData"];
    /**
     * 基本信息
     **/
    NSNumber* userId = [basic objectForKey:@"id"];
    NSString* loginName = [basic objectForKey:@"loginName"];
    NSString* loginPassword = [basic objectForKey:@"loginPassword"];
    NSString* userNumber = [basic objectForKey:@"number"];
    NSString* userName = [basic objectForKey:@"name"];
    NSString* userNickname = [basic objectForKey:@"nickname"];
    NSString* avatar = [NSString stringWithFormat:@"%@/%@",[LTxCoreConfig sharedInstance].serviceHost,[basic objectForKey:@"userPicRelativePath"]];
    NSString* sex = [basic objectForKey:@"sex"];
    NSString* departmentName = [basic objectForKey:@"departmentName"];
    NSString* phoneNumber = [basic objectForKey:@"phoneNumber"];
    
    [NSUserDefaults ltx_setObject:userId forKey:USERDEFAULT_USER_ID];
    [NSUserDefaults ltx_setObject:loginName forKey:USERDEFAULT_USER_LOGIN_NAME];
    [NSUserDefaults ltx_setObject:loginPassword forKey:USERDEFAULT_USER_LOGIN_PASSWORD];
    [NSUserDefaults ltx_setObject:userNumber forKey:USERDEFAULT_USER_NUMBER];
    [NSUserDefaults ltx_setObject:userName forKey:USERDEFAULT_USER_NAME];
    [NSUserDefaults ltx_setObject:userNickname forKey:USERDEFAULT_USER_NICKNAME];
    [NSUserDefaults ltx_setObject:avatar forKey:USERDEFAULT_USER_AVATAR_IMAGE];
    [NSUserDefaults ltx_setObject:sex forKey:USERDEFAULT_USER_SEX];
    [NSUserDefaults ltx_setObject:departmentName forKey:USERDEFAULT_USER_DEPARTMENT];
    [NSUserDefaults ltx_setObject:phoneNumber forKey:USERDEFAULT_USER_PHONE_NUMBER];
    
    /**
     * 扩展信息
     **/
    [NSUserDefaults ltx_setObject:extend forKey:USERDEFAULT_USER_EXTEND];
    
    /**
     * 当前使用
     **/
    [LTxCoreConfig sharedInstance].userId = userId;
    [LTxCoreConfig sharedInstance].userNumber = userNumber;
}
@end
