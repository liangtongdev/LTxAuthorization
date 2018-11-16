//
//  LTxEepMPopup.m
//  AFNetworking
//
//  Created by liangtong on 2018/8/29.
//

#import "LTxEepMPopup.h"

@implementation LTxEepMPopup

/**
 * TOAST
 * 导航栏上弹出提示框
 ***/
+(void)showToast:(NSString*)message{
    [LTxEepMPopup showToast:[UIImage imageNamed:@"ic_toast_info"] title:message message:nil autoDimiss:YES show:nil tap:nil dismiss:nil];
}

+(void)showToast:(NSString*)title message:(NSString*)message{
    [LTxEepMPopup showToast:nil title:title message:message autoDimiss:YES show:nil tap:nil dismiss:nil];
}

+(void)showToast:(UIImage*)image title:(NSString*)title message:(NSString*)message{
    [LTxEepMPopup showToast:image title:title message:message autoDimiss:YES show:nil tap:nil dismiss:nil];
}

+(void)showToast:(UIImage*)image title:(NSString*)title message:(NSString*)message show:(LTxPopupCallback)show tap:(LTxPopupCallback)tap dismiss:(LTxPopupCallback)dismiss{
    [LTxEepMPopup showToast:image title:title message:message autoDimiss:YES show:show tap:tap dismiss:dismiss];
}

+(void)showToast:(UIImage*)image title:(NSString*)title message:(NSString*)message autoDimiss:(BOOL)autoDismiss show:(LTxPopupCallback)show tap:(LTxPopupCallback)tap dismiss:(LTxPopupCallback)dismiss{
    LTxPopupToastConfiguration* configuration = [LTxPopupToastConfiguration defaultConfiguration];
    configuration.showDuration = 3.f;
    configuration.showAnimateDuration = 0.3f;
    configuration.image = image;
    configuration.title = title;
    configuration.message = message;
    configuration.autoDismiss = autoDismiss;
    
    if (!title) {
        configuration.messageFontSize = 17.f;
    }
    
    configuration.backgroundColor = [LTxCoreConfig sharedInstance].hintColor;
    
    [LTxPopupToast showLTxPopupToastWithConfiguration:configuration show:show tap:tap dismiss:dismiss];
}

@end
