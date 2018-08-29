//
//  LTxLoginChangePasswordViewController.h
//  AFNetworking
//
//  Created by liangtong on 2018/8/28.
//

#import <LTxCore/LTxCore.h>

/**
 * 修改密码
 * --------------------
 * 新密码
 * 再次输入新密码
 * 提交新密码
 * --------------------
 ***/
@interface LTxLoginChangePasswordViewController : LTxCoreBaseViewController
/**
 * 用户登录 - 需要重写该方法
 **/
-(void)ltx_changePasswordWithNewPassword:(NSString*)newPassword;
@end
