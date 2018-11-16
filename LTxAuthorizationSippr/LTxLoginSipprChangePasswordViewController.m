//
//  LTxLoginSipprChangePasswordViewController.m
//  AFNetworking
//
//  Created by liangtong on 2018/8/28.
//

#import "LTxLoginSipprChangePasswordViewController.h"

@interface LTxLoginSipprChangePasswordViewController ()

@end

@implementation LTxLoginSipprChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**
 * 用户登录 - 需要重写该方法
 **/
-(void)ltx_changePasswordWithNewPassword:(NSString*)newPassword{
    __weak __typeof(self) weakSelf = self;
    [self showAnimatingActivityView];
    [[LTxSipprAppViewModel sharedInstance] userChangePassword:newPassword complete:^(NSString *errorTips) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf hideAnimatingActivityView];
        if(errorTips){
            [LTxEepMPopup showToast:errorTips];
        }else{
            [[LTxSipprAppViewModel sharedInstance] showMainViewAction];
        }
    }];
}

@end
