//
//  LTxEepMSettingViewModel.m
//  AFNetworking
//
//  Created by liangtong on 2018/8/28.
//

#import "LTxEepMSettingViewModel.h"

@implementation LTxEepMSettingViewModel
///#begin
/**
 *    @brief    用户反馈
 */
///#end
+(void)userFeedbackWithOpinion:(NSString*)opinion
                      complete:(LTxStringCallbackBlock)complete{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    LTxCoreConfig* config = [LTxCoreConfig sharedInstance];
    if (config.userId) {
        [params setObject:config.userId forKey:@"feedbackUserNumber"];
    }
    if (config.appId) {
        [params setObject:config.appId forKey:@"appId"];
    }
    [params setObject:@"iOS" forKey:@"platform"];
    
    id appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    if (appVersion) {
        [params setObject:appVersion forKey:@"appVer"];
    }
    if (opinion) {
        [params setObject:opinion forKey:@"feedbackContent"];
    }
    NSString* url = [NSString stringWithFormat:@"%@/v1/api/mobile/feedback",config.eepmHost];
    //网络访问
    [LTxCoreHttpService doPostWithURL:url param:params complete:^(NSString *errorTips, id data) {
        if (complete) {
            complete(errorTips);
        }
    }];
}

///#begin
/**
 *    @brief    检查版本更新
 */
///#end
+(void)appUpdateCheckComplete:(LTxSettingForSipprUpdateCallback)complete{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    LTxCoreConfig* config = [LTxCoreConfig sharedInstance];
    if (config.userId) {
        [params setObject:config.userId forKey:@"userNumber"];
    }
    if (config.appId) {
        [params setObject:config.appId forKey:@"appId"];
    }
    [params setObject:@"iOS" forKey:@"platform"];
    
    id appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    if (appVersion) {
        [params setObject:appVersion forKey:@"currentVer"];
    }
    
    NSString* url = [NSString stringWithFormat:@"%@/v1/api/mobile/update",config.eepmHost];
    //网络访问
    [LTxCoreHttpService doGetWithURL:url param:params complete:^(NSString *errorTips, id data) {
        if (complete) {
            NSDictionary* updateInfo = nil;
            if ([data isKindOfClass:[NSArray class]]) {
                updateInfo = [data objectAtIndex:0];
            }
            BOOL newVersionExists = [[updateInfo objectForKey:@"needUpdate"] boolValue];
            BOOL updateForced = false;
            if (newVersionExists){
                updateForced = [[updateInfo objectForKey:@"forceUpdate"] boolValue];
            }
            complete(newVersionExists,updateForced,updateInfo,errorTips);
        }
    }];
}

///#begin
/**
 *    @brief    历史版本信息
 */
///#end
+(void)appUpdateHistoryFetchComplete:(LTxStringAndArrayCallbackBlock)complete{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    LTxCoreConfig* config = [LTxCoreConfig sharedInstance];
    if (config.userId) {
        [params setObject:config.userId forKey:@"userNumber"];
    }
    if (config.appId) {
        [params setObject:config.appId forKey:@"appId"];
    }
    [params setObject:@"iOS" forKey:@"platform"];
    
    id appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    if (appVersion) {
        [params setObject:appVersion forKey:@"currentVer"];
    }
    
    NSString* url = [NSString stringWithFormat:@"%@/v1/api/updateHistory",config.eepmHost];
    //网络访问
    [LTxCoreHttpService doGetWithURL:url param:params complete:^(NSString *errorTips, id data) {
        if (complete) {
            complete(errorTips,data);
        }
    }];
}
@end
