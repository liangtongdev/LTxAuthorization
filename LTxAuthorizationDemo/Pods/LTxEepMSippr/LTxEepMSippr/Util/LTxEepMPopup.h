//
//  LTxEepMPopup.h
//  AFNetworking
//
//  Created by liangtong on 2018/8/29.
//

#import <Foundation/Foundation.h>
#import <LTxPopup/LTxPopup.h>
#import <LTxCore/LTxCore.h>

@interface LTxEepMPopup : NSObject

/**
 * TOAST
 * 导航栏上弹出提示框
 ***/
+(void)showToast:(NSString*)message;

+(void)showToast:(NSString*)title message:(NSString*)message;

+(void)showToast:(UIImage*)image title:(NSString*)title message:(NSString*)message;

+(void)showToast:(UIImage*)image title:(NSString*)title message:(NSString*)message show:(LTxPopupCallback)show tap:(LTxPopupCallback)tap dismiss:(LTxPopupCallback)dismiss;

+(void)showToast:(UIImage*)image title:(NSString*)title message:(NSString*)message autoDimiss:(BOOL)autoDismiss show:(LTxPopupCallback)show tap:(LTxPopupCallback)tap dismiss:(LTxPopupCallback)dismiss;

@end
