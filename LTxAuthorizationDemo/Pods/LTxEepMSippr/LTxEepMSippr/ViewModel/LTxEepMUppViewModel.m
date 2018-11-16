//
//  LTxEepMUppViewModel.m
//  AFNetworking
//
//  Created by liangtong on 2018/8/28.
//

#import "LTxEepMUppViewModel.h"

@implementation LTxEepMUppViewModel
/**
 * 推送定制 - 消息类别获取
 **/
+(void)pushTypeListFetchComplete:(LTxStringAndArrayCallbackBlock)complete{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    LTxCoreConfig* config = [LTxCoreConfig sharedInstance];
    if (config.userNumber) {
        [params setObject:config.userNumber forKey:@"userNumber"];
    }
    if (config.appId) {
        [params setObject:config.appId forKey:@"appId"];
    }
    NSString* url = [NSString stringWithFormat:@"%@/v1/api/mobile/getPushConfig",config.messageHost];
    //网络访问
    [LTxCoreHttpService doGetWithURL:url param:params complete:^(NSString *errorTips, id data) {
        if (complete) {
            complete(errorTips,data);
        }
    }];
}

/**
 * 推送定制 - 定制消息类别
 **/
+(void)diyPushTypeList:(NSSet*)pushTypeSet complete:(LTxStringCallbackBlock)complete{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    //消息类别
    NSString* configValues = @"";
    NSArray* setArray = pushTypeSet.allObjects;
    if (setArray) {
        configValues = [setArray componentsJoinedByString:@"|"];
    }
    if ([configValues isEqualToString:@""]) {
        configValues = @"none";
    }
    if (configValues) {
        [params setObject:configValues forKey:@"configValues"];
    }
    //配置信息
    LTxCoreConfig* config = [LTxCoreConfig sharedInstance];
    if (config.userNumber) {
        [params setObject:config.userNumber forKey:@"userNumber"];
    }
    if (config.appId) {
        [params setObject:config.appId forKey:@"appId"];
    }
    
    NSString* url = [NSString stringWithFormat:@"%@/v1/api/mobile/updatePushConfig",config.messageHost];
    //网络访问
    [LTxCoreHttpService doPostWithURL:url param:params complete:^(NSString *errorTips, id data) {
        if (complete) {
            complete(errorTips);
        }
    }];
}


/**
 * 消息 - 消息类别及该类别下未读的消息及数量
 **/
+(void)msgTypeOverviewListFetchComplete:(LTxStringAndArrayCallbackBlock)complete{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    LTxCoreConfig* config = [LTxCoreConfig sharedInstance];
    if (config.userNumber) {
        [params setObject:config.userNumber forKey:@"userRowGuid"];
    }
    if (config.appId) {
        [params setObject:config.appId forKey:@"appId"];
    }
    NSString* url = [NSString stringWithFormat:@"%@/v1/api/mobile/msg/unhandled",config.messageHost];
    //网络访问
    [LTxCoreHttpService doGetWithURL:url param:params complete:^(NSString *errorTips, id data) {
        NSArray* messageList = data;
        if (complete) {
            complete(errorTips, messageList);
        }
        //更新程序角标
        NSInteger unreadCount = 0;
        for (NSDictionary* messageDic in messageList) {
            unreadCount += [[messageDic objectForKey:@"unHandledCount"] intValue];
        }
        [UIApplication sharedApplication].applicationIconBadgeNumber = unreadCount;
    }];
}

/**
 * 消息 - 消息类别下的所有消息置为已读
 **/
+(void)updateMsgTypeReadStateWithMsgType:(NSString*)messageType complete:(LTxCallbackBlock)complete{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    //消息类别
    if (messageType) {
        [params setObject:messageType forKey:@"msgType"];
    }
    //配置信息
    LTxCoreConfig* config = [LTxCoreConfig sharedInstance];
    if (config.userNumber) {
        [params setObject:config.userNumber forKey:@"userRowGuid"];
    }
    if (config.appId) {
        [params setObject:config.appId forKey:@"appId"];
    }
    
    NSString* url = [NSString stringWithFormat:@"%@/v1/api/mobile/msg/clean",config.messageHost];
    //网络访问
    [LTxCoreHttpService doPostWithURL:url param:params complete:^(NSString *errorTips, id data) {
        if (complete) {
            complete();
        }
    }];
}

/**
 * 消息 - 特定消息类别下的消息列表获取
 **/
+(void)msgListFetchWithMsgType:(NSString*)messageType currentPage:(NSInteger)currentPage maxResult:(NSInteger)maxResult complete:(LTxStringAndArrayCallbackBlock)complete{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    LTxCoreConfig* config = [LTxCoreConfig sharedInstance];
    if (config.userNumber) {
        [params setObject:config.userNumber forKey:@"userRowGuid"];
    }
    if (config.appId) {
        [params setObject:config.appId forKey:@"appId"];
    }
    if (messageType) {
        [params setObject:messageType forKey:@"messageType"];
    }
    
    [params setObject:[NSNumber numberWithInteger:currentPage] forKey:@"currentPage"];
    [params setObject:[NSNumber numberWithInteger:maxResult] forKey:@"maxResult"];
    
    NSDate* date2000 = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    NSDate* tomorrow = [NSDate dateWithTimeInterval:86400 sinceDate:[NSDate date]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    [params setObject:[formatter stringFromDate:date2000] forKey:@"startTime"];
    [params setObject:[formatter stringFromDate:tomorrow] forKey:@"endTime"];
    
    NSString* url = [NSString stringWithFormat:@"%@/v1/api/mobile/msg/list",config.messageHost];
    //网络访问
    [LTxCoreHttpService doGetWithURL:url param:params complete:^(NSString *errorTips, id data) {
        if (complete) {
            complete(errorTips, data);
        }
    }];
    
    //业务需要，点开消息列表的时候，将该列表下的消息置为已读
    [LTxEepMUppViewModel updateMsgTypeReadStateWithMsgType:messageType complete:nil];
}

/**
 * 消息 - 特定的消息获取
 **/

+(void)msgDetailWithMsgId:(NSString*)messageId userNumber:(NSString*)userNumber complete:(LTxStringAndDictionaryCallbackBlock)complete{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    LTxCoreConfig* config = [LTxCoreConfig sharedInstance];
    if (config.userNumber) {
        [params setObject:config.userNumber forKey:@"userRowGuid"];
    }
    if (config.appId) {
        [params setObject:config.appId forKey:@"appId"];
    }
    if (messageId) {
        [params setObject:messageId forKey:@"messageId"];
    }
    
    NSString* url = [NSString stringWithFormat:@"%@/v1/api/mobile/msg/detail",config.messageHost];
    //网络访问
    [LTxCoreHttpService doGetWithURL:url param:params complete:^(NSString *errorTips, id data) {
        if (complete) {
            NSArray* msgList = data;
            if ([msgList count] > 0) {
                complete(errorTips, msgList.firstObject);
            }else{
                complete(errorTips, nil);
            }
        }
    }];
    
    //业务需要，点开消息的时候，将消息置为已读
    [LTxEepMUppViewModel updateMsgReadStateWithMsgId:messageId complete:nil];
}

/**
 * 消息 - 将某一条消息的阅读状态置为已读
 **/
+(void)updateMsgReadStateWithMsgId:(NSString*)messageId complete:(LTxStringCallbackBlock)complete{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    //消息
    if (messageId) {
        [params setObject:messageId forKey:@"id"];
    }
    //配置信息
    LTxCoreConfig* config = [LTxCoreConfig sharedInstance];
    if (config.userNumber) {
        [params setObject:config.userNumber forKey:@"userRowGuid"];
    }
    if (config.appId) {
        [params setObject:config.appId forKey:@"appId"];
    }
    
    NSString* url = [NSString stringWithFormat:@"%@/v1/api/mobile/msg/updateById",config.messageHost];
    //网络访问
    [LTxCoreHttpService doPostWithURL:url param:params complete:^(NSString *errorTips, id data) {
        if (complete) {
            complete(errorTips);
        }
    }];
}

/**
 * 消息 - 将多条消息的阅读状态置为已读
 **/
+(void)updateMsgReadStateWithMsgIds:(NSString*)messageIds complete:(LTxStringCallbackBlock)complete{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    //消息
    if (messageIds) {
        [params setObject:messageIds forKey:@"id"];
    }
    //配置信息
    LTxCoreConfig* config = [LTxCoreConfig sharedInstance];
    if (config.userNumber) {
        [params setObject:config.userNumber forKey:@"userRowGuid"];
    }
    if (config.appId) {
        [params setObject:config.appId forKey:@"appId"];
    }
    
    NSString* url = [NSString stringWithFormat:@"%@/v1/api/mobile/msg/updateByIds",config.messageHost];
    //网络访问
    [LTxCoreHttpService doPostWithURL:url param:params complete:^(NSString *errorTips, id data) {
        if (complete) {
            complete(errorTips);
        }
    }];
}

/**
 * 消息 - 将某一条消息的阅读状态置为已读
 **/
+(void)updateMsgReadStateWithMsgGuid:(NSString*)guid complete:(LTxStringCallbackBlock)complete{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    //消息
    if (guid) {
        [params setObject:guid forKey:@"guid"];
    }
    //配置信息
    LTxCoreConfig* config = [LTxCoreConfig sharedInstance];
    if (config.userNumber) {
        [params setObject:config.userNumber forKey:@"userRowGuid"];
    }
    if (config.appId) {
        [params setObject:config.appId forKey:@"appId"];
    }
    
    NSString* url = [NSString stringWithFormat:@"%@/v1/api/mobile/msg/update",config.messageHost];
    //网络访问
    [LTxCoreHttpService doPostWithURL:url param:params complete:^(NSString *errorTips, id data) {
        if (complete) {
            complete(errorTips);
        }
    }];
}

/**
 * 消息 - 根据业务编码获取消息详情
 **/
+(void)msgDetailWithMsgRowGuid:(NSString*)messageRowGuid complete:(LTxStringAndDictionaryCallbackBlock)complete{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    LTxCoreConfig* config = [LTxCoreConfig sharedInstance];
    if (config.userNumber) {
        [params setObject:config.userNumber forKey:@"userRowGuid"];
    }
    if (config.appId) {
        [params setObject:config.appId forKey:@"appId"];
    }
    if (messageRowGuid) {
        [params setObject:messageRowGuid forKey:@"messageRowGuid"];
    }
    
    NSString* url = [NSString stringWithFormat:@"%@/api/ProjectNotification/GetSpecifiedNotificationInfo",config.messageHost];
    //网络访问
    [LTxCoreHttpService doGetWithURL:url param:params complete:^(NSString *errorTips, id data) {
        if (complete) {
            NSArray* msgList = data;
            if ([msgList count] > 0) {
                complete(errorTips, msgList.firstObject);
            }else{
                complete(errorTips, nil);
            }
        }
    }];
}

/**
 * 消息 - 发送消息到服务器
 **/
+(void)msgSendToServer:(NSString*)msgs complete:(LTxStringCallbackBlock)complete{
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    //消息
    if (msgs) {
        [params setObject:msgs forKey:@"msgs"];
    }
    //配置信息
    LTxCoreConfig* config = [LTxCoreConfig sharedInstance];
    NSString* url = [NSString stringWithFormat:@"%@/v1/api/mobile/msg/send",config.messageHost];
    //网络访问
    [LTxCoreHttpService doPostWithURL:url param:params complete:^(NSString *errorTips, id data) {
        if (complete) {
            complete(errorTips);
        }
    }];
    
}
#pragma mark - SMS
/**
 * 发送验证码
 **/
+(void)sendSmsCode:(NSString*)phoneNumber operateType:(NSInteger)operateType complete:(LTxStringCallbackBlock)complete{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    NSString* deviceCode = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    LTxCoreConfig* config = [LTxCoreConfig sharedInstance];
    if (config.appId) {
        [params setObject:config.appId forKey:@"appId"];
    }
    if (phoneNumber) {
        [params setObject:phoneNumber forKey:@"phoneNumber"];
    }
    if (deviceCode) {
        [params setObject:deviceCode forKey:@"deviceCode"];
    }
    [params setObject:@"ios" forKey:@"platform"];
    [params setObject:[NSNumber numberWithInteger:operateType] forKey:@"operateType"];
    NSString* url = [NSString stringWithFormat:@"%@/v1/api/mobile/sms/send",config.messageHost];
    //网络访问
    [LTxCoreHttpService doPostWithURL:url param:params complete:^(NSString *errorTips, id data) {
        if (complete) {
            complete( errorTips);
        }
    }];
}
/**
 * 发送验证码
 **/
+(void)validateSmsCode:(NSString*)phoneNumber authCode:(NSString*)authCode complete:(LTxStringCallbackBlock)complete{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    NSString* deviceCode = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    LTxCoreConfig* config = [LTxCoreConfig sharedInstance];
    if (config.appId) {
        [params setObject:config.appId forKey:@"appId"];
    }
    if (phoneNumber) {
        [params setObject:phoneNumber forKey:@"phoneNumber"];
    }
    if (authCode) {
        [params setObject:authCode forKey:@"smsCode"];
    }
    if (deviceCode) {
        [params setObject:deviceCode forKey:@"deviceCode"];
    }
    [params setObject:@"ios" forKey:@"platform"];
    NSString* url = [NSString stringWithFormat:@"%@/v1/api/mobile/sms/check",config.messageHost];
    //网络访问
    [LTxCoreHttpService doPostWithURL:url param:params complete:^(NSString *errorTips, id data) {
        if (complete) {
            complete( errorTips);
        }
    }];
}

@end
