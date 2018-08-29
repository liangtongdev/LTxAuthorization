//
//  LTxLoginChangePasswordViewController.m
//  AFNetworking
//
//  Created by liangtong on 2018/8/28.
//

#import "LTxLoginChangePasswordViewController.h"

@interface LTxLoginChangePasswordViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView* topView;
@property (nonatomic, strong) UIImageView* password1IV;
@property (nonatomic, strong) UITextField* password1TF;
@property (nonatomic, strong) UIView* line;
@property (nonatomic, strong) UIImageView* password2IV;
@property (nonatomic, strong) UITextField* password2TF;
@property (nonatomic, strong) UIButton* changeBtn;
@end

@implementation LTxLoginChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //界面初始化
    [self ltx_changePasswordSetup];
    //约束
    [self ltx_addConstranintOnComponents];
    //动作
    [self ltx_boundActionOnComponents];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Action
/**
 * 给控件绑定动作
 **/
-(void)ltx_boundActionOnComponents{
    //点击背景，隐藏键盘
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ltx_hideKeyboard)]];
    
    //密码锁
    _password1IV.userInteractionEnabled = YES;
    [_password1IV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ltx_secureTextEntryChange1)]];
    _password2IV.userInteractionEnabled = YES;
    [_password2IV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ltx_secureTextEntryChange2)]];
    
    //修改密码
    [_changeBtn addTarget:self action:@selector(ltx_changePasswordAction) forControlEvents:UIControlEventTouchUpInside];
    
}

/**
 * 隐藏键盘
 **/
-(void)ltx_hideKeyboard{
    [_password1TF resignFirstResponder];
    [_password2TF resignFirstResponder];
}

/**
 * 密码锁
 **/
-(void)ltx_secureTextEntryChange1{
    self.password1TF.secureTextEntry = !self.password1TF.secureTextEntry;
    if (self.password1TF.secureTextEntry) {
        self.password1IV.image = LTxImageWithName(@"ic_login_lock");
    }else{
        self.password1IV.image = LTxImageWithName(@"ic_login_unlock");
    }
    //点击的时候，密码框成为第一焦点。
    [self.password1TF becomeFirstResponder];
}
-(void)ltx_secureTextEntryChange2{
    self.password2TF.secureTextEntry = !self.password2TF.secureTextEntry;
    if (self.password2TF.secureTextEntry) {
        self.password2IV.image = LTxImageWithName(@"ic_login_lock");
    }else{
        self.password2IV.image = LTxImageWithName(@"ic_login_unlock");
    }
    //点击的时候，密码框成为第一焦点。
    [self.password2TF becomeFirstResponder];
}

/**
 * 修改密码
 **/
-(void)ltx_changePasswordAction{
    [self ltx_hideKeyboard];
    NSString* password = [self.password1TF.text ltx_trimmingWhitespace];
    [self ltx_changePasswordWithNewPassword:password];
}

/**
 * 用户登录 - 需要重写该方法
 **/
-(void)ltx_changePasswordWithNewPassword:(NSString*)newPassword{
    
}


#pragma mark - UI
/**
 * 初始化UI设置
 **/
-(void)ltx_changePasswordSetup{
    
    self.title = LTxLocalizedString(@"text_auth_set_new_password");
    
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.password1IV];
    [self.topView addSubview:self.password1TF];
    [self.topView addSubview:self.line];
    [self.topView addSubview:self.password2IV];
    [self.topView addSubview:self.password2TF];
    
    
    [self.view addSubview:self.changeBtn];
}

/**
 * 界面元素添加约束
 ***/
-(void)ltx_addConstranintOnComponents{
    /**
     * 用户名/密码
     **/
    NSLayoutConstraint* topLeading = [NSLayoutConstraint constraintWithItem:_topView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.f constant:40];
    NSLayoutConstraint* topTop = [NSLayoutConstraint constraintWithItem:_topView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.f constant:60];
    NSLayoutConstraint* topTrailing = [NSLayoutConstraint constraintWithItem:_topView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.f constant:-40];
    [NSLayoutConstraint activateConstraints:@[topLeading,topTop,topTrailing]];
    
    //password1 Image
    NSLayoutConstraint* password1IVLeading = [NSLayoutConstraint constraintWithItem:_password1IV attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeLeading multiplier:1.f constant:LTX_LOGIN_PADDING];
    NSLayoutConstraint* password1IVTop = [NSLayoutConstraint constraintWithItem:_password1IV attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeTop multiplier:1.f constant:LTX_LOGIN_PADDING];
    NSLayoutConstraint* password1IVWidth = [NSLayoutConstraint constraintWithItem:_password1IV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:20];
    NSLayoutConstraint* password1IVHeight = [NSLayoutConstraint constraintWithItem:_password1IV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_password1IV attribute:NSLayoutAttributeWidth multiplier:1.f constant:0];
    [NSLayoutConstraint activateConstraints:@[password1IVLeading,password1IVTop,password1IVWidth,password1IVHeight]];
    
    //password1 TextField
    NSLayoutConstraint* password1TFLeading = [NSLayoutConstraint constraintWithItem:_password1TF attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_password1IV attribute:NSLayoutAttributeTrailing multiplier:1.f constant:LTX_LOGIN_PADDING / 2];
    NSLayoutConstraint* password1TFTrailing = [NSLayoutConstraint constraintWithItem:_password1TF attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeTrailing multiplier:1.f constant:-LTX_LOGIN_PADDING];
    NSLayoutConstraint* password1TFCenterY = [NSLayoutConstraint constraintWithItem:_password1TF attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_password1IV attribute:NSLayoutAttributeCenterY multiplier:1.f constant:2];
    [NSLayoutConstraint activateConstraints:@[password1TFLeading,password1TFTrailing,password1TFCenterY]];
    
    //line
    NSLayoutConstraint* lineLeading = [NSLayoutConstraint constraintWithItem:_line attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeLeading multiplier:1.f constant:LTX_LOGIN_PADDING];
    NSLayoutConstraint* lineTrailing = [NSLayoutConstraint constraintWithItem:_line attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeTrailing multiplier:1.f constant:-LTX_LOGIN_PADDING];
    NSLayoutConstraint* lineTop = [NSLayoutConstraint constraintWithItem:_line attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_password1IV attribute:NSLayoutAttributeBottom multiplier:1.f constant:LTX_LOGIN_PADDING];
    NSLayoutConstraint* lineHeight = [NSLayoutConstraint constraintWithItem:_line attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:1.f];
    [NSLayoutConstraint activateConstraints:@[lineLeading,lineTrailing,lineTop,lineHeight]];
    
    //password2 Image
    NSLayoutConstraint* password2IVLeading = [NSLayoutConstraint constraintWithItem:_password2IV attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_password1IV attribute:NSLayoutAttributeLeading multiplier:1.f constant:0];
    NSLayoutConstraint* password2IVTop = [NSLayoutConstraint constraintWithItem:_password2IV attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_line attribute:NSLayoutAttributeTop multiplier:1.f constant:LTX_LOGIN_PADDING];
    NSLayoutConstraint* password2IVWidth = [NSLayoutConstraint constraintWithItem:_password2IV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_password1IV attribute:NSLayoutAttributeWidth multiplier:1.f constant:0];
    NSLayoutConstraint* password2IVHeight = [NSLayoutConstraint constraintWithItem:_password2IV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_password1IV attribute:NSLayoutAttributeHeight multiplier:1.f constant:0];
    [NSLayoutConstraint activateConstraints:@[password2IVLeading,password2IVTop,password2IVWidth,password2IVHeight]];
    
    //password2 TextField
    NSLayoutConstraint* password2TFLeading = [NSLayoutConstraint constraintWithItem:_password2TF attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_password1TF attribute:NSLayoutAttributeLeading multiplier:1.f constant:0];
    NSLayoutConstraint* password2TFTrailing = [NSLayoutConstraint constraintWithItem:_password2TF attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_password1TF attribute:NSLayoutAttributeTrailing multiplier:1.f constant:0];
    NSLayoutConstraint* password2TFCenterY = [NSLayoutConstraint constraintWithItem:_password2TF attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_password2IV attribute:NSLayoutAttributeCenterY multiplier:1.f constant:2];
    [NSLayoutConstraint activateConstraints:@[password2TFLeading,password2TFTrailing,password2TFCenterY]];
    
    //top - height
    NSLayoutConstraint* psdIVBottom = [NSLayoutConstraint constraintWithItem:_password2IV attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeBottom multiplier:1.f constant:-LTX_LOGIN_PADDING];
    [NSLayoutConstraint activateConstraints:@[psdIVBottom]];
    
    //change
    NSLayoutConstraint* changeLeading = [NSLayoutConstraint constraintWithItem:_changeBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeLeading multiplier:1.f constant:0];
    NSLayoutConstraint* changeTrailing = [NSLayoutConstraint constraintWithItem:_changeBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeTrailing multiplier:1.f constant:0];
    NSLayoutConstraint* changeTop = [NSLayoutConstraint constraintWithItem:_changeBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeBottom multiplier:1.f constant:LTX_LOGIN_PADDING * 1.5];
    NSLayoutConstraint* changeHeight = [NSLayoutConstraint constraintWithItem:_changeBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:44.f];
    [NSLayoutConstraint activateConstraints:@[changeLeading,changeTrailing,changeTop,changeHeight]];
    
}


#pragma mark - Getter
-(UIView*)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.translatesAutoresizingMaskIntoConstraints = NO;
        _topView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _topView.layer.borderWidth = 1.f;
    }
    
    return _topView;
}
-(UIImageView*)password1IV{
    if (!_password1IV) {
        _password1IV = [[UIImageView alloc] initWithImage:LTxImageWithName(@"ic_login_lock")];
        _password1IV.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _password1IV;
}
-(UITextField*)password1TF{
    if(!_password1TF){
        _password1TF = [[UITextField alloc] init];
        _password1TF.delegate = self;
        _password1TF.translatesAutoresizingMaskIntoConstraints = NO;
        _password1TF.placeholder = LTxLocalizedString(@"text_auth_set_new_password_placeholder_1");
        _password1TF.secureTextEntry = YES;
        _password1TF.returnKeyType = UIReturnKeyDone;
    }
    return _password1TF;
}
-(UIView*)line{
    if(!_line){
        _line = [[UIView alloc] init];
        _line.translatesAutoresizingMaskIntoConstraints = NO;
        _line.backgroundColor = [UIColor lightGrayColor];
    }
    return _line;
}
-(UIImageView*)password2IV{
    if (!_password2IV) {
        _password2IV = [[UIImageView alloc] initWithImage:LTxImageWithName(@"ic_login_lock")];
        _password2IV.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _password2IV;
}
-(UITextField*)password2TF{
    if(!_password2TF){
        _password2TF = [[UITextField alloc] init];
        _password2TF.delegate = self;
        _password2TF.translatesAutoresizingMaskIntoConstraints = NO;
        _password2TF.placeholder = LTxLocalizedString(@"text_auth_set_new_password_placeholder_2");
        _password2TF.secureTextEntry = YES;
        _password2TF.returnKeyType = UIReturnKeyDone;
    }
    return _password2TF;
}
-(UIButton*)changeBtn{
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_changeBtn setTitle:LTxLocalizedString(@"text_auth_set_new_password_action") forState:UIControlStateNormal];
        [_changeBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
        _changeBtn.backgroundColor = [LTxCoreConfig sharedInstance].skinColor;
        _changeBtn.layer.cornerRadius = 5.f;
        _changeBtn.layer.masksToBounds = YES;
    }
    return _changeBtn;
}

#pragma mark - TextFiled

//用户输入信息发生变更
- (void)textFieldChanged:(UITextField *)textField{
    NSString* psd1 = [self.password1TF.text ltx_trimmingWhitespace];
    NSString* psd2 = [self.password2TF.text ltx_trimmingWhitespace];
    BOOL enableChangeBtn = NO;
    if ([psd1 isEqualToString:psd2]) {
        if (![psd1 isEqualToString:@""]) {
            enableChangeBtn = YES;
        }
    }
    [self.changeBtn setEnabled:enableChangeBtn];
    if (enableChangeBtn) {
        self.changeBtn.backgroundColor = [LTxCoreConfig sharedInstance].skinColor;
    }else{
        self.changeBtn.backgroundColor = [UIColor lightGrayColor];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

@end
