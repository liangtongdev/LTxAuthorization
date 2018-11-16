//
//  LTxLoginViewController.m
//  AFNetworking
//
//  Created by liangtong on 2018/8/27.
//

#import "LTxLoginViewController.h"

@interface LTxLoginViewController ()<UITextFieldDelegate>

//UI部分
@property (nonatomic, strong) UIView* topView;
@property (nonatomic, strong) UIImageView* userNameIV;
@property (nonatomic, strong) UITextField* userNameTF;
@property (nonatomic, strong) UIView* line;
@property (nonatomic, strong) UIImageView* passwordIV;
@property (nonatomic, strong) UITextField* passwordTF;
@property (nonatomic, strong) UIButton* loginBtn;
@property (nonatomic, strong) UIButton* forgetBtn;
@property (nonatomic, strong) UIButton* quickLoginBtn;
@property (nonatomic, strong) UIButton* registerBtn;//新访客注册
@property (nonatomic, strong) UILabel* tipL;

@end

@implementation LTxLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //界面初始化
    [self ltx_loginSetup];
    //约束
    [self ltx_addConstranintOnComponents];
    //动作
    [self ltx_boundActionOnComponents];
    
    //校验
    [self textFieldChanged:nil];
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
    _passwordIV.userInteractionEnabled = YES;
    [_passwordIV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ltx_secureTextEntryChange)]];
    
    //登录
    [_loginBtn addTarget:self action:@selector(ltx_userLoginAction) forControlEvents:UIControlEventTouchUpInside];
    
    //忘记密码
    [_forgetBtn addTarget:self action:@selector(ltx_forgetPasswordAction) forControlEvents:UIControlEventTouchUpInside];
    
    //快速登录
    [_quickLoginBtn addTarget:self action:@selector(ltx_quickLoginAction) forControlEvents:UIControlEventTouchUpInside];
    
    //新访客注册
    [_registerBtn addTarget:self action:@selector(ltx_registerAction) forControlEvents:UIControlEventTouchUpInside];
    
}

/**
 * 隐藏键盘
 **/
-(void)ltx_hideKeyboard{
    [_userNameTF resignFirstResponder];
    [_passwordTF resignFirstResponder];
}

/**
 * 密码锁
 **/
-(void)ltx_secureTextEntryChange{
    self.passwordTF.secureTextEntry = !self.passwordTF.secureTextEntry;
    if (self.passwordTF.secureTextEntry) {
        self.passwordIV.image = LTxImageWithName(@"ic_login_lock");
    }else{
        self.passwordIV.image = LTxImageWithName(@"ic_login_unlock");
    }
    //点击的时候，密码框成为第一焦点。
    [self.passwordTF becomeFirstResponder];
}

/**
 * 用户登录
 **/
-(void)ltx_userLoginAction{
    [self ltx_hideKeyboard];
    NSString* userName = [self.userNameTF.text ltx_trimmingWhitespace];
    NSString* password = [self.passwordTF.text ltx_trimmingWhitespace];
    [self ltx_userLoginWithName:userName password:password];
}

/**
 * 用户登录 - 需要重写该方法
 **/
-(void)ltx_userLoginWithName:(NSString*)loginName password:(NSString*)password{
    
}

/**
 * 忘记密码
 **/
-(void)ltx_forgetPasswordAction{
    [self ltx_hideKeyboard];
    [self ltx_showSmsValidateWithType:LTxLoginSMSValidateTypeForgetPassword];
}

/**
 * 快速登录动作
 **/
-(void)ltx_quickLoginAction{
    [self ltx_hideKeyboard];
    [self ltx_showSmsValidateWithType:LTxLoginSMSValidateTypeQuickLogin];
}

/**
 * 新访客注册
 **/
-(void)ltx_registerAction{
    [self ltx_hideKeyboard];
    
}

/**
 * 短信验证页面
 **/
-(void)ltx_showSmsValidateWithType:(LTxLoginSMSValidateType)smsType{
    LTxLoginSmsValidateViewController* smsValidateVC = [[LTxLoginSmsValidateViewController alloc] init];
    smsValidateVC.smsType = smsType;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:smsValidateVC animated:YES];
    });
}

#pragma mark - UI
/**
 * 初始化UI设置
 **/
-(void)ltx_loginSetup{
    
    self.title = LTxLocalizedString(@"text_auth_login");
    
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.userNameIV];
    [self.topView addSubview:self.userNameTF];
    [self.topView addSubview:self.line];
    [self.topView addSubview:self.passwordIV];
    [self.topView addSubview:self.passwordTF];
    
    [self.view addSubview:self.loginBtn];
    if (!self.hideForgetBtn) {
        [self.view addSubview:self.forgetBtn];
    }
    if (!self.hideQuickLoginBtn) {
        [self.view addSubview:self.quickLoginBtn];
    }
    if (!self.hideRegisterBtn) {
        [self.view addSubview:self.registerBtn];
    }
    
    [self.view addSubview:self.tipL];
}

/**
 * 界面元素添加约束
 ***/
-(void)ltx_addConstranintOnComponents{
    /**
     * 用户名/密码
     **/
    NSLayoutConstraint* topLeading = [NSLayoutConstraint constraintWithItem:_topView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.f constant:40];
    NSLayoutConstraint* topTop = [NSLayoutConstraint constraintWithItem:_topView attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:60];
    NSLayoutConstraint* topTrailing = [NSLayoutConstraint constraintWithItem:_topView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.f constant:-40];
    [NSLayoutConstraint activateConstraints:@[topLeading,topTop,topTrailing]];
    
    //userName Image
    NSLayoutConstraint* userIVLeading = [NSLayoutConstraint constraintWithItem:_userNameIV attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeLeading multiplier:1.f constant:LTX_LOGIN_PADDING];
    NSLayoutConstraint* userIVTop = [NSLayoutConstraint constraintWithItem:_userNameIV attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeTop multiplier:1.f constant:LTX_LOGIN_PADDING];
    NSLayoutConstraint* userIVWidth = [NSLayoutConstraint constraintWithItem:_userNameIV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:20];
    NSLayoutConstraint* userIVHeight = [NSLayoutConstraint constraintWithItem:_userNameIV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_userNameIV attribute:NSLayoutAttributeWidth multiplier:1.f constant:0];
    [NSLayoutConstraint activateConstraints:@[userIVLeading,userIVTop,userIVWidth,userIVHeight]];
    
    //userName TextField
    NSLayoutConstraint* userTFLeading = [NSLayoutConstraint constraintWithItem:_userNameTF attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_userNameIV attribute:NSLayoutAttributeTrailing multiplier:1.f constant:LTX_LOGIN_PADDING / 2];
    NSLayoutConstraint* userTFTrailing = [NSLayoutConstraint constraintWithItem:_userNameTF attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeTrailing multiplier:1.f constant:-LTX_LOGIN_PADDING];
    NSLayoutConstraint* userTFCenterY = [NSLayoutConstraint constraintWithItem:_userNameTF attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_userNameIV attribute:NSLayoutAttributeCenterY multiplier:1.f constant:2];
    [NSLayoutConstraint activateConstraints:@[userTFLeading,userTFTrailing,userTFCenterY]];
    
    //line
    NSLayoutConstraint* lineLeading = [NSLayoutConstraint constraintWithItem:_line attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeLeading multiplier:1.f constant:LTX_LOGIN_PADDING];
    NSLayoutConstraint* lineTrailing = [NSLayoutConstraint constraintWithItem:_line attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeTrailing multiplier:1.f constant:-LTX_LOGIN_PADDING];
    NSLayoutConstraint* lineTop = [NSLayoutConstraint constraintWithItem:_line attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_userNameIV attribute:NSLayoutAttributeBottom multiplier:1.f constant:LTX_LOGIN_PADDING];
    NSLayoutConstraint* lineHeight = [NSLayoutConstraint constraintWithItem:_line attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:1.f];
    [NSLayoutConstraint activateConstraints:@[lineLeading,lineTrailing,lineTop,lineHeight]];
    
    //password Image
    NSLayoutConstraint* psdIVLeading = [NSLayoutConstraint constraintWithItem:_passwordIV attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_userNameIV attribute:NSLayoutAttributeLeading multiplier:1.f constant:0];
    NSLayoutConstraint* psdIVTop = [NSLayoutConstraint constraintWithItem:_passwordIV attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_line attribute:NSLayoutAttributeTop multiplier:1.f constant:LTX_LOGIN_PADDING];
    NSLayoutConstraint* psdIVWidth = [NSLayoutConstraint constraintWithItem:_passwordIV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_userNameIV attribute:NSLayoutAttributeWidth multiplier:1.f constant:0];
    NSLayoutConstraint* psdIVHeight = [NSLayoutConstraint constraintWithItem:_passwordIV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_userNameIV attribute:NSLayoutAttributeHeight multiplier:1.f constant:0];
    [NSLayoutConstraint activateConstraints:@[psdIVLeading,psdIVTop,psdIVWidth,psdIVHeight]];
    
    //userName TextField
    NSLayoutConstraint* psdTFLeading = [NSLayoutConstraint constraintWithItem:_passwordTF attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_userNameTF attribute:NSLayoutAttributeLeading multiplier:1.f constant:0];
    NSLayoutConstraint* psdTFTrailing = [NSLayoutConstraint constraintWithItem:_passwordTF attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_userNameTF attribute:NSLayoutAttributeTrailing multiplier:1.f constant:0];
    NSLayoutConstraint* psdTFCenterY = [NSLayoutConstraint constraintWithItem:_passwordTF attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_passwordIV attribute:NSLayoutAttributeCenterY multiplier:1.f constant:2];
    [NSLayoutConstraint activateConstraints:@[psdTFLeading,psdTFTrailing,psdTFCenterY]];
    
    //top - height
    NSLayoutConstraint* psdIVBottom = [NSLayoutConstraint constraintWithItem:_passwordIV attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeBottom multiplier:1.f constant:-LTX_LOGIN_PADDING];
    [NSLayoutConstraint activateConstraints:@[psdIVBottom]];
    
    //Login
    NSLayoutConstraint* loginLeading = [NSLayoutConstraint constraintWithItem:_loginBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeLeading multiplier:1.f constant:0];
    NSLayoutConstraint* loginTrailing = [NSLayoutConstraint constraintWithItem:_loginBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeTrailing multiplier:1.f constant:0];
    NSLayoutConstraint* loginTop = [NSLayoutConstraint constraintWithItem:_loginBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeBottom multiplier:1.f constant:LTX_LOGIN_PADDING * 1.5];
    NSLayoutConstraint* loginHeight = [NSLayoutConstraint constraintWithItem:_loginBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:44.f];
    [NSLayoutConstraint activateConstraints:@[loginLeading,loginTrailing,loginTop,loginHeight]];
    
    //forget
    if (_forgetBtn) {
        NSLayoutConstraint* forgetLeading = [NSLayoutConstraint constraintWithItem:_forgetBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeLeading multiplier:1.f constant:0];
        NSLayoutConstraint* forgetTop = [NSLayoutConstraint constraintWithItem:_forgetBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_loginBtn attribute:NSLayoutAttributeBottom multiplier:1.f constant:LTX_LOGIN_PADDING / 2];
        NSLayoutConstraint* forgetHeight = [NSLayoutConstraint constraintWithItem:_forgetBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:30.f];
        [NSLayoutConstraint activateConstraints:@[forgetLeading,forgetTop,forgetHeight]];
    }
    
    //quicklogin
    if (_quickLoginBtn) {
        NSLayoutConstraint* quickLoginLeading = [NSLayoutConstraint constraintWithItem:_quickLoginBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeLeading multiplier:1.f constant:0];
        NSLayoutConstraint* quickLoginTrailing = [NSLayoutConstraint constraintWithItem:_quickLoginBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeTrailing multiplier:1.f constant:0];
        NSLayoutConstraint* quickLoginTop = [NSLayoutConstraint constraintWithItem:_quickLoginBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_forgetBtn attribute:NSLayoutAttributeBottom multiplier:1.f constant:LTX_LOGIN_PADDING * 1.5];
        NSLayoutConstraint* quickLoginHeight = [NSLayoutConstraint constraintWithItem:_quickLoginBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:44.f];
        [NSLayoutConstraint activateConstraints:@[quickLoginLeading,quickLoginTrailing,quickLoginTop,quickLoginHeight]];
    }
    
    //registerBtn
    if (_registerBtn) {
        NSLayoutConstraint* registerLeading = [NSLayoutConstraint constraintWithItem:_registerBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeLeading multiplier:1.f constant:0];
        NSLayoutConstraint* registerTrailing = [NSLayoutConstraint constraintWithItem:_registerBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeTrailing multiplier:1.f constant:0];
        NSLayoutConstraint* registerTop = [NSLayoutConstraint constraintWithItem:_registerBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_quickLoginBtn attribute:NSLayoutAttributeBottom multiplier:1.f constant:LTX_LOGIN_PADDING * 1.5];
        NSLayoutConstraint* registerHeight = [NSLayoutConstraint constraintWithItem:_registerBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:44.f];
        [NSLayoutConstraint activateConstraints:@[registerLeading,registerTrailing,registerTop,registerHeight]];
    }
    
    //tip
    if (_tipL) {
        NSLayoutConstraint* tipLeading = [NSLayoutConstraint constraintWithItem:_tipL attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.f constant:LTX_LOGIN_PADDING];
        NSLayoutConstraint* tipTrailing = [NSLayoutConstraint constraintWithItem:_tipL attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.f constant:-LTX_LOGIN_PADDING];
        NSLayoutConstraint* tipBottom = [NSLayoutConstraint constraintWithItem:_tipL attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.f constant:-LTX_LOGIN_PADDING];
        [NSLayoutConstraint activateConstraints:@[tipLeading,tipTrailing,tipBottom]];
    }
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
-(UIImageView*)userNameIV{
    if (!_userNameIV) {
        _userNameIV = [[UIImageView alloc] initWithImage:LTxImageWithName(@"ic_login_person")];
        _userNameIV.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _userNameIV;
}
-(UITextField*)userNameTF{
    if(!_userNameTF){
        _userNameTF = [[UITextField alloc] init];
        _userNameTF.delegate = self;
        _userNameTF.translatesAutoresizingMaskIntoConstraints = NO;
        _userNameTF.placeholder = LTxLocalizedString(@"text_auth_login_username_placeholder");
        _userNameTF.returnKeyType = UIReturnKeyDone;
    }
    return _userNameTF;
}
-(UIView*)line{
    if(!_line){
        _line = [[UIView alloc] init];
        _line.translatesAutoresizingMaskIntoConstraints = NO;
        _line.backgroundColor = [UIColor lightGrayColor];
    }
    return _line;
}
-(UIImageView*)passwordIV{
    if (!_passwordIV) {
        _passwordIV = [[UIImageView alloc] initWithImage:LTxImageWithName(@"ic_login_lock")];
        _passwordIV.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _passwordIV;
}
-(UITextField*)passwordTF{
    if(!_passwordTF){
        _passwordTF = [[UITextField alloc] init];
        _passwordTF.delegate = self;
        _passwordTF.translatesAutoresizingMaskIntoConstraints = NO;
        _passwordTF.placeholder = LTxLocalizedString(@"text_auth_login_password_placeholder");
        _passwordTF.secureTextEntry = YES;
        _passwordTF.clearsOnBeginEditing = YES;
        _passwordTF.returnKeyType = UIReturnKeyDone;
    }
    return _passwordTF;
}
-(UIButton*)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_loginBtn setTitle:LTxLocalizedString(@"text_auth_login_action") forState:UIControlStateNormal];
        [_loginBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
        _loginBtn.backgroundColor = [LTxCoreConfig sharedInstance].skinColor;
        _loginBtn.layer.cornerRadius = 5.f;
        _loginBtn.layer.masksToBounds = YES;
    }
    return _loginBtn;
}

-(UIButton*)forgetBtn{
    if (!_forgetBtn) {
        _forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgetBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_forgetBtn setTitle:LTxLocalizedString(@"text_auth_login_forget_action") forState:UIControlStateNormal];
        [_forgetBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
        [_forgetBtn setTitleColor:[LTxCoreConfig sharedInstance].skinColor forState:UIControlStateNormal];
    }
    return _forgetBtn;
}
-(UIButton*)quickLoginBtn{
    if (!_quickLoginBtn) {
        _quickLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _quickLoginBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_quickLoginBtn setTitle:LTxLocalizedString(@"text_auth_sms_login_title") forState:UIControlStateNormal];
        [_quickLoginBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
        _quickLoginBtn.backgroundColor = [LTxCoreConfig sharedInstance].hintColor;
        _quickLoginBtn.layer.cornerRadius = 5.f;
        _quickLoginBtn.layer.masksToBounds = YES;
    }
    return _quickLoginBtn;
}
-(UIButton*)registerBtn{
    if (!_registerBtn) {
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_registerBtn setTitle:LTxLocalizedString(@"text_auth_sms_login_register") forState:UIControlStateNormal];
        [_registerBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
        _registerBtn.backgroundColor = [LTxCoreConfig sharedInstance].hintColor;
        _registerBtn.layer.cornerRadius = 5.f;
        _registerBtn.layer.masksToBounds = YES;
    }
    return _registerBtn;
}
-(UILabel*)tipL{
    if (!_tipL) {
        _tipL = [[UILabel alloc] init];
        _tipL.translatesAutoresizingMaskIntoConstraints = NO;
        _tipL.textAlignment = NSTextAlignmentCenter;
        _tipL.numberOfLines = 0;
        _tipL.text = [LTxCoreConfig sharedInstance].loginTip;
    }
    return _tipL;
}

#pragma mark - Setter

-(void)setHideForgetBtn:(BOOL)hideForgetBtn{
    _hideForgetBtn = hideForgetBtn;
    _forgetBtn.hidden = hideForgetBtn;
}

-(void)setHideRegisterBtn:(BOOL)hideRegisterBtn{
    _hideRegisterBtn = hideRegisterBtn;
    _registerBtn.hidden = hideRegisterBtn;
}

#pragma mark - TextFiled

//用户输入信息发生变更
- (void)textFieldChanged:(UITextField *)textField{
    if ([self validateInputData]) {
        [self.loginBtn setEnabled:true];
        self.loginBtn.backgroundColor = [LTxCoreConfig sharedInstance].skinColor;
    }else{
        [self.loginBtn setEnabled:false];
        self.loginBtn.backgroundColor = [UIColor lightGrayColor];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

//验证输入格式是否合法
-(BOOL)validateInputData{
    if ( [[self.userNameTF.text ltx_trimmingWhitespace] isEqualToString:@""] || [[self.passwordTF.text ltx_trimmingWhitespace] isEqualToString:@""]) {
        return false;
    }
    return true;
}


@end
