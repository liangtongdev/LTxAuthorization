//
//  LTxLoginSipprSmsValidateViewController.m
//  AFNetworking
//
//  Created by liangtong on 2018/8/28.
//

#import "LTxLoginSipprSmsValidateViewController.h"

@interface LTxLoginSipprSmsValidateViewController ()

@end

@implementation LTxLoginSipprSmsValidateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**
 * 发送短信
 **/
-(void)ltx_sendSmsCodeWithPhone:(NSString*)phone{
    __weak __typeof(self) weakSelf = self;
    [weakSelf showAnimatingActivityView];
    [LTxEepMUppViewModel sendSmsCode:phone operateType:self.smsType complete:^(NSString *errorTips) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf hideAnimatingActivityView];
        if(errorTips){
            [LTxEepMPopup showToast:errorTips];
        }else{//发送成功
            [LTxEepMPopup showToast:@"短信已发送！"];
            [strongSelf ltx_startSmsSendTimer];
        }
    }];
}

/**
 * 短信验证
 **/
-(void)ltx_smsValidateWithPhone:(NSString*)phone smsCode:(NSString*)smsCode{
    __weak __typeof(self) weakSelf = self;
    [self showAnimatingActivityView];
    [LTxEepMUppViewModel validateSmsCode:phone authCode:smsCode complete:^(NSString *errorTips) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf hideAnimatingActivityView];
        if(errorTips){
            [LTxEepMPopup showToast:errorTips];
        }else{
            //验证成功 - hook：根据短信类别进行后续操作
        }
    }];
}

@end
