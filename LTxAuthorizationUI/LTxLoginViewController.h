//
//  LTxLoginViewController.h
//  AFNetworking
//
//  Created by liangtong on 2018/8/27.
//

#import <LTxCore/LTxCore.h>
#import "LTxAuthorizationUI.h"
/**
 * 登录界面
 * 纯代码工作
 **/
@interface LTxLoginViewController : LTxCoreBaseViewController

@property (nonatomic, assign) BOOL hideForgetBtn;
@property (nonatomic, assign) BOOL hideQuickLoginBtn;
@property (nonatomic, assign) BOOL hideRegisterBtn;

/**
 * 用户登录
 * 可重写该方法
 **/
-(void)ltx_userLoginWithName:(NSString*)loginName password:(NSString*)password;

/**
 * 短信验证页面
 **/
-(void)ltx_showSmsValidateWithType:(LTxLoginSMSValidateType)smsType;

/**
 * 新访客注册
 **/
-(void)ltx_registerAction;
@end
