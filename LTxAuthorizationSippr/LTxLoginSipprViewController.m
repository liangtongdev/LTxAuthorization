//
//  LTxLoginSipprViewController.m
//  AFNetworking
//
//  Created by liangtong on 2018/8/28.
//

#import "LTxLoginSipprViewController.h"
#import "LTxSipprAppViewModel.h"

@interface LTxLoginSipprViewController ()

@end

@implementation LTxLoginSipprViewController

- (void)viewDidLoad {
    
    self.hideRegisterBtn = true;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = nil;
}

-(void)ltx_userLoginWithName:(NSString*)loginName password:(NSString*)password{
    __weak __typeof(self) weakSelf = self;
    [self showAnimatingActivityView];
    [[LTxSipprAppViewModel sharedInstance] userLoginWithName:loginName password:password complete:^(NSString * errorTips) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf hideAnimatingActivityView];
        if(errorTips){
            [LTxEepMPopup showToast:errorTips];
        }else{
            //登录成功 - 跳转到特定页面，比如：
            [[LTxSipprAppViewModel sharedInstance] showMainViewAction];
            
        }
    }];
}


/**
 * 短信验证页面
 **/
-(void)ltx_showSmsValidateWithType:(LTxLoginSMSValidateType)smsType{
    LTxLoginSipprSmsValidateViewController* smsValidateVC = [[LTxLoginSipprSmsValidateViewController alloc] init];
    smsValidateVC.smsType = smsType;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:smsValidateVC animated:YES];
    });
}


@end
