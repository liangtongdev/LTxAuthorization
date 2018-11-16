//
//  LTxLoginSmsValidateViewController.m
//  AFNetworking
//
//  Created by liangtong on 2018/8/28.
//

#import "LTxLoginSmsValidateViewController.h"

@interface LTxLoginSmsValidateViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView* topView;
@property (nonatomic, strong) UIImageView* phoneIV;
@property (nonatomic, strong) UITextField* phoneTF;
@property (nonatomic, strong) UIView* verticalLine;
@property (nonatomic, strong) UIButton* sendBtn;
@property (nonatomic, strong) UIView* horizontalLine;
@property (nonatomic, strong) UIImageView* smsIV;
@property (nonatomic, strong) UITextField* smsTF;
@property (nonatomic, strong) UIButton* validateBtn;


@property (nonatomic, strong) NSTimer* timer;

@end

@implementation LTxLoginSmsValidateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //界面初始化
    [self ltx_smsValidateSetup];
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

-(void)dealloc{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - Action
/**
 * 给控件绑定动作
 **/
-(void)ltx_boundActionOnComponents{
    //点击背景，隐藏键盘
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ltx_hideKeyboard)]];
    
    //短信验证
    [_sendBtn addTarget:self action:@selector(ltx_sendSmsCodeAction) forControlEvents:UIControlEventTouchUpInside];
    
    //短信验证
    [_validateBtn addTarget:self action:@selector(ltx_smsValidateAction) forControlEvents:UIControlEventTouchUpInside];
}

/**
 * 隐藏键盘
 **/
-(void)ltx_hideKeyboard{
    [_phoneTF resignFirstResponder];
    [_smsTF resignFirstResponder];
}

/**
 * 发送短信
 **/
-(void)ltx_sendSmsCodeAction{
    [self ltx_hideKeyboard];
    //删除空格
    NSString* phone = [self.phoneTF.text ltx_trimmingWhitespace];
    [self ltx_sendSmsCodeWithPhone:phone];
}

/**
 * 发送短信 - 需要重写该方法
 **/
-(void)ltx_sendSmsCodeWithPhone:(NSString*)phone{
    
}

/**
 * 启动重新发送短信计数器
 **/
-(void)ltx_startSmsSendTimer{
    if (!_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(ltx_updateSendTime) userInfo:nil repeats:YES];
    [self.smsTF becomeFirstResponder];
}

/**
 * 更新计数器时间
 **/
-(void)ltx_updateSendTime{
    --self.timeCount;
    if (_timeCount > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{//(秒)重新获取
            NSString* timeLeft = [NSString stringWithFormat:@"(%td)重发",self.timeCount];
            [self.sendBtn.titleLabel setText:[NSString stringWithFormat: @""]];//解决闪烁问题
            [self.sendBtn setTitle:timeLeft forState:UIControlStateNormal];
            self.sendBtn.enabled = NO;
            self.sendBtn.backgroundColor = [UIColor lightGrayColor];
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{//重新获取
            [self.sendBtn setTitle:@"重新发送" forState:UIControlStateNormal];
            self.sendBtn.enabled = YES;
            self.sendBtn.backgroundColor = [LTxCoreConfig sharedInstance].hintColor;
        });
        [self.timer invalidate];
        self.timer = nil;
    }
}


/**
 * 短信验证
 **/
-(void)ltx_smsValidateAction{
    [self ltx_hideKeyboard];
    //删除空格
    NSString* phone = [self.phoneTF.text ltx_trimmingWhitespace];
    NSString* smsCode = [self.smsTF.text ltx_trimmingWhitespace];
    [self ltx_smsValidateWithPhone:phone smsCode:smsCode];
}

/**
 * 短信验证 - 需要重写该方法
 **/
-(void)ltx_smsValidateWithPhone:(NSString*)phone smsCode:(NSString*)smsCode{
    
}
#pragma mark - UI
/**
 * 初始化UI设置
 **/
-(void)ltx_smsValidateSetup{
    
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.phoneIV];
    [self.topView addSubview:self.phoneTF];
    [self.topView addSubview:self.verticalLine];
    [self.topView addSubview:self.sendBtn];
    [self.topView addSubview:self.horizontalLine];
    [self.topView addSubview:self.smsIV];
    [self.topView addSubview:self.smsTF];
    
    [self.view addSubview:self.validateBtn];
    
    if (_smsType == LTxLoginSMSValidateTypeQuickLogin) {
        self.title = LTxLocalizedString(@"text_auth_sms_login_title");
        [_validateBtn setTitle:LTxLocalizedString(@"text_auth_sms_login") forState:UIControlStateNormal];
    }else if (_smsType == LTxLoginSMSValidateTypeForgetPassword) {
        self.title = LTxLocalizedString(@"text_auth_sms_forget_password_title");
        [_validateBtn setTitle:LTxLocalizedString(@"text_auth_sms_forget_password") forState:UIControlStateNormal];
    }else{
        self.title = LTxLocalizedString(@"text_auth_sms_validate_title");
        [_validateBtn setTitle:LTxLocalizedString(@"text_auth_sms_validate") forState:UIControlStateNormal];
    }
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
    
    //phone Image
    NSLayoutConstraint* phoneIVLeading = [NSLayoutConstraint constraintWithItem:_phoneIV attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeLeading multiplier:1.f constant:LTX_LOGIN_PADDING];
    NSLayoutConstraint* phoneIVTop = [NSLayoutConstraint constraintWithItem:_phoneIV attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeTop multiplier:1.f constant:LTX_LOGIN_PADDING];
    NSLayoutConstraint* phoneIVWidth = [NSLayoutConstraint constraintWithItem:_phoneIV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:20];
    NSLayoutConstraint* phoneIVHeight = [NSLayoutConstraint constraintWithItem:_phoneIV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_phoneIV attribute:NSLayoutAttributeWidth multiplier:1.f constant:0];
    [NSLayoutConstraint activateConstraints:@[phoneIVLeading,phoneIVTop,phoneIVWidth,phoneIVHeight]];
    
    //phoneTF TextField
    NSLayoutConstraint* phoneTFLeading = [NSLayoutConstraint constraintWithItem:_phoneTF attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_phoneIV attribute:NSLayoutAttributeTrailing multiplier:1.f constant:LTX_LOGIN_PADDING / 2];
    NSLayoutConstraint* phoneTFCenterY = [NSLayoutConstraint constraintWithItem:_phoneTF attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_phoneIV attribute:NSLayoutAttributeCenterY multiplier:1.f constant:2];
    [NSLayoutConstraint activateConstraints:@[phoneTFLeading,phoneTFCenterY]];
    
    //verticalLine
    NSLayoutConstraint* verticalLineLeading = [NSLayoutConstraint constraintWithItem:_verticalLine attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_phoneTF attribute:NSLayoutAttributeTrailing multiplier:1.f constant:0];
    NSLayoutConstraint* verticalLineTop = [NSLayoutConstraint constraintWithItem:_verticalLine attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeTop multiplier:1.f constant:0];
    NSLayoutConstraint* verticalLineWidth = [NSLayoutConstraint constraintWithItem:_verticalLine attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:1.f];
     NSLayoutConstraint* verticalLineBottom = [NSLayoutConstraint constraintWithItem:_verticalLine attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_horizontalLine attribute:NSLayoutAttributeTop multiplier:1.f constant:0];
    [NSLayoutConstraint activateConstraints:@[verticalLineLeading,verticalLineTop,verticalLineWidth,verticalLineBottom]];
    
    //sendBtn - 宽度80
    NSLayoutConstraint* sendBtnLeading = [NSLayoutConstraint constraintWithItem:_sendBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_phoneTF attribute:NSLayoutAttributeTrailing multiplier:1.f constant:LTX_LOGIN_PADDING / 2 ];
    NSLayoutConstraint* sendBtnTop = [NSLayoutConstraint constraintWithItem:_sendBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeTop multiplier:1.f constant:LTX_LOGIN_PADDING / 2];
    NSLayoutConstraint* sendBtnWidth = [NSLayoutConstraint constraintWithItem:_sendBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:80.f];
    NSLayoutConstraint* sendBtnBottom = [NSLayoutConstraint constraintWithItem:_sendBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_horizontalLine attribute:NSLayoutAttributeTop multiplier:1.f constant:-LTX_LOGIN_PADDING / 2];
    NSLayoutConstraint* sendBtnTrailing = [NSLayoutConstraint constraintWithItem:_sendBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeTrailing multiplier:1.f constant:-LTX_LOGIN_PADDING / 2 ];
    [NSLayoutConstraint activateConstraints:@[sendBtnLeading,sendBtnTop,sendBtnWidth,sendBtnBottom,sendBtnTrailing]];
    
    
    //horizontalLine
    NSLayoutConstraint* horizontalLineLeading = [NSLayoutConstraint constraintWithItem:_horizontalLine attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeLeading multiplier:1.f constant:LTX_LOGIN_PADDING];
    NSLayoutConstraint* horizontalLineTrailing = [NSLayoutConstraint constraintWithItem:_horizontalLine attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeTrailing multiplier:1.f constant:-LTX_LOGIN_PADDING];
    NSLayoutConstraint* horizontalLineTop = [NSLayoutConstraint constraintWithItem:_horizontalLine attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_phoneIV attribute:NSLayoutAttributeBottom multiplier:1.f constant:LTX_LOGIN_PADDING];
    NSLayoutConstraint* horizontalLineHeight = [NSLayoutConstraint constraintWithItem:_horizontalLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:1.f];
    [NSLayoutConstraint activateConstraints:@[horizontalLineLeading,horizontalLineTrailing,horizontalLineTop,horizontalLineHeight]];
    
    //smsIV Image
    NSLayoutConstraint* smsIVLeading = [NSLayoutConstraint constraintWithItem:_smsIV attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_phoneIV attribute:NSLayoutAttributeLeading multiplier:1.f constant:0];
    NSLayoutConstraint* smsIVTop = [NSLayoutConstraint constraintWithItem:_smsIV attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_horizontalLine attribute:NSLayoutAttributeTop multiplier:1.f constant:LTX_LOGIN_PADDING];
    NSLayoutConstraint* smsIVWidth = [NSLayoutConstraint constraintWithItem:_smsIV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_phoneIV attribute:NSLayoutAttributeWidth multiplier:1.f constant:0];
    NSLayoutConstraint* smsIVHeight = [NSLayoutConstraint constraintWithItem:_smsIV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_phoneIV attribute:NSLayoutAttributeHeight multiplier:1.f constant:0];
    [NSLayoutConstraint activateConstraints:@[smsIVLeading,smsIVTop,smsIVWidth,smsIVHeight]];
    
    //smsTF TextField
    NSLayoutConstraint* smsTFLeading = [NSLayoutConstraint constraintWithItem:_smsTF attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_phoneTF attribute:NSLayoutAttributeLeading multiplier:1.f constant:0];
    NSLayoutConstraint* smsTFTrailing = [NSLayoutConstraint constraintWithItem:_smsTF attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeTrailing multiplier:1.f constant:-LTX_LOGIN_PADDING];
    NSLayoutConstraint* smsTFCenterY = [NSLayoutConstraint constraintWithItem:_smsTF attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_smsIV attribute:NSLayoutAttributeCenterY multiplier:1.f constant:2];
    [NSLayoutConstraint activateConstraints:@[smsTFLeading,smsTFTrailing,smsTFCenterY]];
    
    //top - height
    NSLayoutConstraint* smsIVBottom = [NSLayoutConstraint constraintWithItem:_smsIV attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeBottom multiplier:1.f constant:-LTX_LOGIN_PADDING];
    [NSLayoutConstraint activateConstraints:@[smsIVBottom]];
    
    //validateBtn
    NSLayoutConstraint* validateBtnLeading = [NSLayoutConstraint constraintWithItem:_validateBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeLeading multiplier:1.f constant:0];
    NSLayoutConstraint* validateBtnTrailing = [NSLayoutConstraint constraintWithItem:_validateBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeTrailing multiplier:1.f constant:0];
    NSLayoutConstraint* validateBtnTop = [NSLayoutConstraint constraintWithItem:_validateBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeBottom multiplier:1.f constant:LTX_LOGIN_PADDING * 1.5];
    NSLayoutConstraint* validateBtnHeight = [NSLayoutConstraint constraintWithItem:_validateBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:44.f];
    [NSLayoutConstraint activateConstraints:@[validateBtnLeading,validateBtnTrailing,validateBtnTop,validateBtnHeight]];
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
-(UIImageView*)phoneIV{
    if (!_phoneIV) {
        _phoneIV = [[UIImageView alloc] initWithImage:LTxImageWithName(@"ic_login_phone")];
        _phoneIV.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _phoneIV;
}
-(UITextField*)phoneTF{
    if(!_phoneTF){
        _phoneTF = [[UITextField alloc] init];
        _phoneTF.delegate = self;
        _phoneTF.translatesAutoresizingMaskIntoConstraints = NO;
        _phoneTF.placeholder = LTxLocalizedString(@"text_auth_sms_phone_placeholder");
        _phoneTF.keyboardType = UIKeyboardTypeDecimalPad;
        _phoneTF.returnKeyType = UIReturnKeyDone;
    }
    return _phoneTF;
}
-(UIView*)verticalLine{
    if(!_verticalLine){
        _verticalLine = [[UIView alloc] init];
        _verticalLine.translatesAutoresizingMaskIntoConstraints = NO;
        _verticalLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _verticalLine;
}
-(UIButton*)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_sendBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
        _sendBtn.backgroundColor = [LTxCoreConfig sharedInstance].hintColor;
        [_sendBtn setTitle:LTxLocalizedString(@"发送") forState:UIControlStateNormal];
        _sendBtn.layer.cornerRadius = 5.f;
        _sendBtn.layer.masksToBounds = YES;
    }
    return _sendBtn;
}
-(UIView*)horizontalLine{
    if(!_horizontalLine){
        _horizontalLine = [[UIView alloc] init];
        _horizontalLine.translatesAutoresizingMaskIntoConstraints = NO;
        _horizontalLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _horizontalLine;
}
-(UIImageView*)smsIV{
    if (!_smsIV) {
        _smsIV = [[UIImageView alloc] initWithImage:LTxImageWithName(@"ic_login_sms_code")];
        _smsIV.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _smsIV;
}
-(UITextField*)smsTF{
    if(!_smsTF){
        _smsTF = [[UITextField alloc] init];
        _smsTF.delegate = self;
        _smsTF.translatesAutoresizingMaskIntoConstraints = NO;
        _smsTF.placeholder = LTxLocalizedString(@"text_auth_sms_code_placeholder");
        _smsTF.keyboardType = UIKeyboardTypeDecimalPad;
        _smsTF.returnKeyType = UIReturnKeyDone;
    }
    return _smsTF;
}
-(UIButton*)validateBtn{
    if (!_validateBtn) {
        _validateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _validateBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_validateBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
        _validateBtn.backgroundColor = [LTxCoreConfig sharedInstance].skinColor;
        _validateBtn.layer.cornerRadius = 5.f;
        _validateBtn.layer.masksToBounds = YES;
    }
    return _validateBtn;
}

-(NSInteger)timeCount{
    if (_timeCount == 0) {
        _timeCount = 60;
    }
    return _timeCount;
}

#pragma mark - TextFiled

//用户输入信息发生变更
- (void)textFieldChanged:(UITextField *)textField{
    BOOL isPhone = [[_phoneTF.text ltx_trimmingWhitespace] ltx_isPhoneNumber];
    if (isPhone) {
        if (self.timer) {
            [self.sendBtn setEnabled:NO];
            self.sendBtn.backgroundColor = [UIColor lightGrayColor];
        }else{
            [self.sendBtn setEnabled:YES];
            self.sendBtn.backgroundColor = [LTxCoreConfig sharedInstance].hintColor;
        }
        NSString* smsCode = [_smsTF.text ltx_trimmingWhitespace];
        if ([smsCode isEqualToString:@""]) {
            [self.validateBtn setEnabled:NO];
            self.validateBtn.backgroundColor = [UIColor lightGrayColor];
        }else{
            [self.validateBtn setEnabled:YES];
            self.validateBtn.backgroundColor = [LTxCoreConfig sharedInstance].skinColor;
        }
    }else{
        [self.sendBtn setEnabled:NO];
        self.sendBtn.backgroundColor = [UIColor lightGrayColor];
        [self.validateBtn setEnabled:NO];
        self.validateBtn.backgroundColor = [UIColor lightGrayColor];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

@end
