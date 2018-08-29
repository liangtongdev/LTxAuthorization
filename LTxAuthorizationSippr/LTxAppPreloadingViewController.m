//
//  LTxAppPreloadingViewController.m
//  AFNetworking
//
//  Created by liangtong on 2018/8/29.
//

#import "LTxAppPreloadingViewController.h"

@interface LTxAppPreloadingViewController ()

//提示信息
@property (nonatomic, strong) UILabel* tipL;
@end

@implementation LTxAppPreloadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //界面初始化
    [self ltx_preloadingViewSetup];
    //添加约束
    [self ltx_addConstranintOnComponents];
    
    //启动第一步动作
    [self ltx_appHostFetch];
}

#pragma mark - 动作

/**
 * 第一步，获取HOST
 **/
-(void)ltx_appHostFetch{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tipL.text = LTxLocalizedString(@"text_auth_launch_host");
    });
    __weak __typeof(self) weakSelf = self;
    [LTxAppManageViewModel appHostFetchComplete:^(NSString* errorTips) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (errorTips) {
            dispatch_async(dispatch_get_main_queue(), ^{
                 strongSelf.tipL.text = [NSString stringWithFormat:@"%@：%@",LTxLocalizedString(@"text_auth_launch_host_failed"),errorTips];
            });
            [strongSelf performSelector:@selector(ltx_appHostFetch) withObject:nil afterDelay:4];
        }else{//存在host信息，可以检查更新
            [strongSelf ltx_appUpdateCheck];
        }
    }];
    
}
/**
 * 第二步，检查更新
 **/
-(void)ltx_appUpdateCheck{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tipL.text = LTxLocalizedString(@"text_auth_launch_update");
    });
    __weak __typeof(self) weakSelf = self;
    [LTxAppManageViewModel appUpdateCheckWithOpinion:NO callback:^(NSString *errorTips) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (errorTips) {
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.tipL.text = [NSString stringWithFormat:@"%@：%@",LTxLocalizedString(@"text_auth_launch_update_failed"),errorTips];
            });
        }
        [strongSelf ltx_userQuickLogin];
    }];
}
/**
 * 第三步，快速登录
 **/
-(void)ltx_userQuickLogin{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tipL.text = LTxLocalizedString(@"text_auth_launch_login");
    });
    __weak __typeof(self) weakSelf = self;
    [LTxAppManageViewModel userQuickLoginCallback:^(BOOL success) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (success) {//快速登录成功，切换root页面
            dispatch_async(dispatch_get_main_queue(), ^{
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *mainTab = [story instantiateViewControllerWithIdentifier:@"mainTab"];
                [UIApplication sharedApplication].keyWindow.rootViewController = mainTab;
            });
        }else{//登录失败，切换到登录界面
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.tipL.text = LTxLocalizedString(@"text_auth_launch_login_failed");
                UIViewController* loginVC = [strongSelf.storyboard instantiateViewControllerWithIdentifier:@"loginNavi"];
                [UIApplication sharedApplication].keyWindow.rootViewController = loginVC;
            });
        }
    }];
}

#pragma mark - UI
/**
 * 初始化UI设置
 **/
-(void)ltx_preloadingViewSetup{
    [self.view addSubview:self.tipL];
    
}

/**
 * 界面元素添加约束
 ***/
-(void)ltx_addConstranintOnComponents{
    NSLayoutConstraint* tipLeading = [NSLayoutConstraint constraintWithItem:_tipL attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.f constant:20];
    NSLayoutConstraint* tipTrailing = [NSLayoutConstraint constraintWithItem:_tipL attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.f constant:-20];
    NSLayoutConstraint* tipBottom = [NSLayoutConstraint constraintWithItem:_tipL attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.f constant:-20];
    [NSLayoutConstraint activateConstraints:@[tipLeading,tipTrailing,tipBottom]];
}


#pragma mark - Getter
-(UILabel*)tipL{
    if (!_tipL) {
        _tipL = [[UILabel alloc] init];
        _tipL.translatesAutoresizingMaskIntoConstraints = NO;
        _tipL.textAlignment = NSTextAlignmentCenter;
        _tipL.numberOfLines = 0;
        _tipL.font = [UIFont systemFontOfSize:12];
        _tipL.textColor = [UIColor lightGrayColor];
    }
    return _tipL;
}

@end
