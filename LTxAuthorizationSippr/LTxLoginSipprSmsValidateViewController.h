//
//  LTxLoginSipprSmsValidateViewController.h
//  AFNetworking
//
//  Created by liangtong on 2018/8/28.
//

#import "LTxAuthorizationSippr.h"

/**
 * 短信验证这块，目前只做一部分。因为现在UUP提供的短信验证功能还比较低级，仅仅返回的是验证成功/失败。
 * 这些数据无法满足后续的动作（比如后续怎么获取用户信息？用户未登录情况下根据什么修改密码）。
 *
 **/

@interface LTxLoginSipprSmsValidateViewController : LTxLoginSmsValidateViewController

@end
