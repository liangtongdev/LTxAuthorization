//
//  LTxLoginSipprViewController.m
//  AFNetworking
//
//  Created by liangtong on 2018/8/28.
//

#import "LTxLoginSipprViewController.h"
#import "LTxAppManageViewModel.h"

@interface LTxLoginSipprViewController ()

@end

@implementation LTxLoginSipprViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)ltx_userLoginWithName:(NSString*)loginName password:(NSString*)password{
    __weak __typeof(self) weakSelf = self;
    [self showAnimatingActivityView];
    [LTxAppManageViewModel userLoginWithName:loginName password:password complete:^(NSString * errorTips) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf hideAnimatingActivityView];
        if(errorTips){
            [LTxEepMPopup showToast:errorTips];
        }else{
            //登录成功 - 跳转到特定页面，比如：
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *mainTab = [story instantiateViewControllerWithIdentifier:@"mainTab"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].keyWindow.rootViewController = mainTab;
            });
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
