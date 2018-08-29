//
//  ViewController.m
//  LTxLoginDemo
//
//  Created by liangtong on 2018/8/27.
//  Copyright © 2018年 LIANGTONG. All rights reserved.
//

#import "ViewController.h"
#import "LTxAuthorizationUI.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)showLoginVC:(UIButton *)sender {
    
    LTxLoginViewController* loginVC = [[LTxLoginViewController alloc] init];
    
    [self.navigationController pushViewController:loginVC animated:true];
}
- (IBAction)showSmsValidateVC:(UIButton *)sender {
    LTxLoginSmsValidateViewController* smsVC = [[LTxLoginSmsValidateViewController alloc] init];
    smsVC.smsType = LTxLoginSMSValidateTypeForgetPassword;
    [self.navigationController pushViewController:smsVC animated:true];
    
}
- (IBAction)showChangePasswordVC:(UIButton *)sender {
    LTxLoginChangePasswordViewController* changeVC = [[LTxLoginChangePasswordViewController alloc] init];
    
    [self.navigationController pushViewController:changeVC animated:true];
}


@end
