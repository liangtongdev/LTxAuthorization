//
//  LTxLoginSmsValidateViewController.h
//  AFNetworking
//
//  Created by liangtong on 2018/8/28.
//

#import <LTxCore/LTxCore.h>
#import "LTxAuthorizationUI.h"
/**
 * 短信验证
 * --------------------
 * 手机号 | 发送
 *     验证码
 *    验证按钮
 * --------------------
 **/
@interface LTxLoginSmsValidateViewController : LTxCoreBaseViewController

//短信验证类别
@property (nonatomic, assign) LTxLoginSMSValidateType smsType;

//短信计数器时间，默认60秒
@property (nonatomic, assign) NSInteger timeCount;

/**
 * 发送短信
 **/
-(void)ltx_sendSmsCodeWithPhone:(NSString*)phone;

/**
 * 启动重新发送短信计数器
 **/
-(void)ltx_startSmsSendTimer;

/**
 * 短信验证
 **/
-(void)ltx_smsValidateWithPhone:(NSString*)phone smsCode:(NSString*)smsCode;
@end
