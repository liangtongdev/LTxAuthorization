//
//  LTxLoginUI.h
//  Pods
//
//  Created by liangtong on 2018/8/28.
//

#ifndef LTxLoginUI_h
#define LTxLoginUI_h

#define LTX_LOGIN_PADDING 16

//短信验证类别。
typedef NS_ENUM(NSUInteger, LTxLoginSMSValidateType) {
    LTxLoginSMSValidateTypeQuickLogin,                // 快速登录
    LTxLoginSMSValidateTypeForgetPassword,            // 忘记密码
    LTxLoginSMSValidateTypeDefault,
};

#import "LTxLoginViewController.h"//普通登录页面
#import "LTxLoginSmsValidateViewController.h"//短信验证页面
#import "LTxLoginChangePasswordViewController.h"//修改密码页面


#endif /* LTxLoginUI_h */
