//
//  ViewController.m
//  Stone
//
//  Created by xlong on 15-01-22.
//  Copyright (c) 2014年 xlong. All rights reserved.
//

#import "LoginViewController.h"
#import "mainViewController.h"
#import "MBProgressHUD+Add.h"
#import "STNetwork.h"

@interface LoginViewController () <UITextFieldDelegate>

//view
@property (nonatomic, strong) UILabel *Stone;
@property (nonatomic, strong) UIButton *forget_password;
@property (nonatomic, strong) UIButton *login;
@property (nonatomic, strong) UIButton *regist;
@property (nonatomic, strong) UIButton *loginning;
@property (nonatomic, strong) UITextField *user;
@property (nonatomic, strong) UITextField *password;
@property (nonatomic, strong) UITextField *repassword;
//tag
@property (nonatomic, assign) BOOL isRegist;
@property (nonatomic, assign) BOOL loginSuccess;
@property (nonatomic, assign) BOOL registSuccess;
@property (nonatomic, strong) NSURLConnection *loginConnection;
@property (nonatomic, strong) NSURLConnection *registConnection;

//data store
@property (strong, nonatomic) NSUserDefaults *userDefault;

@end


@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:188.0/255 green:210.0/255 blue:210.0/255 alpha:1];
    [self.view endEditing:NO];
    
    //view
    self.Stone = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2-50, CGRectGetHeight(self.view.frame)/2-180, 100, 50)];
    self.Stone.text = @"Stone";
    self.Stone.font = [UIFont systemFontOfSize:60];
    self.Stone.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:self.Stone];
    
    _login = [UIButton buttonWithType:UIButtonTypeCustom];
    _login.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-120, CGRectGetHeight(self.view.frame)/2-70, 120, 40);
    _login.layer.cornerRadius = 2.5f;
    _login.tag = 1;
    [_login setTitle:@"登录" forState:UIControlStateNormal];
    [_login setBackgroundColor:[UIColor grayColor]];
    [_login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_login addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_login];
    
    _regist = [UIButton buttonWithType:UIButtonTypeCustom];
    _regist.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2, CGRectGetHeight(self.view.frame)/2-70, 120, 40);
    _regist.layer.cornerRadius = 2.5f;
    _regist.tag = 2;
    [_regist setTitle:@"注册" forState:UIControlStateNormal];
    [_regist setBackgroundColor:[UIColor whiteColor]];
    [_regist setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_regist addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_regist];

    _user = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2-120, CGRectGetHeight(self.view.frame)/2, 240, 40)];
    _user.placeholder = @"请输入邮箱/手机号";
    _user.backgroundColor = [UIColor whiteColor];
    _user.keyboardType = UIKeyboardTypeASCIICapable;
    _user.delegate = self;
    _user.returnKeyType = UIReturnKeyDone;
    _user.clearButtonMode = UITextFieldViewModeAlways;
    
//    _user.rightView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user"]];
//    _repassword.rightViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_user];
    
    _password = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2-120, CGRectGetHeight(self.view.frame)/2+55, 240, 40)];
    _password.placeholder = @"请输入密码";
    _password.secureTextEntry = TRUE;
    _password.backgroundColor = [UIColor whiteColor];
    _password.delegate = self;
    _password.returnKeyType = UIReturnKeyDone;
    _password.clearButtonMode = UITextFieldViewModeAlways;
//    _password.rightView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password"]];
//    _password.rightViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_password];
    
    _repassword = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2-120, CGRectGetHeight(self.view.frame)/2+110, 240, 40)];
    _repassword.placeholder = @"再次输入密码";
    _repassword.secureTextEntry = TRUE;
    _repassword.backgroundColor = [UIColor whiteColor];
    _repassword.delegate = self;
    _repassword.returnKeyType = UIReturnKeyDone;
    _repassword.clearButtonMode = UITextFieldViewModeAlways;
//    _repassword.rightView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password"]];
//    _repassword.rightViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_repassword];
    _repassword.hidden = YES;   //一开始就隐藏
    
    _loginning = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginning.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-80, CGRectGetHeight(self.view.frame)/2+130, 120, 40);
    _loginning.layer.cornerRadius = 2.0f;
    _loginning.tag = 3;
    [_loginning setTitle:@"登录" forState:UIControlStateNormal];
    [_loginning setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginning setBackgroundColor:[UIColor blackColor]];
    [_loginning addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginning];
    
    _forget_password = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2+60, CGRectGetHeight(self.view.frame)/2+145, 60, 30)];
    [_forget_password setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [_forget_password.titleLabel setFont:[UIFont systemFontOfSize:13]];
    _forget_password.tag = 4;
    [_forget_password addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_forget_password];
    
    _isRegist = NO;   //判断是不是注册信息
    _loginSuccess = NO;
    _registSuccess = NO;
    _userDefault = [NSUserDefaults standardUserDefaults]; //初始化沙盒存储
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//编辑框VIEW处理
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    //view
    [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(titleShow) userInfo:nil repeats:NO];
    [UIView animateWithDuration:0.35 animations:^{_login.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-120, CGRectGetHeight(self.view.frame)/2-70, 120, 40);}completion:^(BOOL finished){}];
    [UIView animateWithDuration:0.35 animations:^{_regist.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2, CGRectGetHeight(self.view.frame)/2-70, 120, 40);}completion:^(BOOL finished){}];
    if(_isRegist){
        [UIView animateWithDuration:0.25 animations:^{_user.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-120, CGRectGetHeight(self.view.frame)/2, 240, 40);}completion:^(BOOL finished){}];
        [UIView animateWithDuration:0.25 animations:^{_password.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-120, CGRectGetHeight(self.view.frame)/2+55, 240, 40);}completion:^(BOOL finished){}];
        [UIView animateWithDuration:0.13 animations:^{_repassword.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-120, CGRectGetHeight(self.view.frame)/2+110, 240, 40);}completion:^(BOOL finished){}];
        [UIView animateWithDuration:0.03 animations:^{
            _loginning.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-65, CGRectGetHeight(self.view.frame)/2+170, 120, 40);
//            _loginning.transform = CGAffineTransformIdentity;
        }completion:^(BOOL finished){}];
    }else{
        [UIView animateWithDuration:0.25 animations:^{_user.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-120, CGRectGetHeight(self.view.frame)/2, 240, 40);}completion:^(BOOL finished){}];
        [UIView animateWithDuration:0.15 animations:^{_password.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-120, CGRectGetHeight(self.view.frame)/2+55, 240, 40);}completion:^(BOOL finished){}];
        [UIView animateWithDuration:0.05 animations:^{_forget_password.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2+60, CGRectGetHeight(self.view.frame)/2+145, 60, 30);}completion:^(BOOL finished){}];
        [UIView animateWithDuration:0.05 animations:^{_loginning.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-80, CGRectGetHeight(self.view.frame)/2+130, 120, 40);}completion:^(BOOL finished){}];
    }
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _Stone.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{_login.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-120, CGRectGetHeight(self.view.frame)/2-220, 120, 40);}completion:^(BOOL finished){}];
    [UIView animateWithDuration:0.25 animations:^{_regist.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2, CGRectGetHeight(self.view.frame)/2-220, 120, 40);}completion:^(BOOL finished){}];
    if (_isRegist) {
        [UIView animateWithDuration:0.25 animations:^{_user.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-120, CGRectGetHeight(self.view.frame)/2-150, 240, 40);}completion:^(BOOL finished){}];
        [UIView animateWithDuration:0.25 animations:^{_password.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-120, CGRectGetHeight(self.view.frame)/2-95, 240, 40);}completion:^(BOOL finished){}];
        [UIView animateWithDuration:0.25 animations:^{_repassword.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-120, CGRectGetHeight(self.view.frame)/2-40, 240, 40);}completion:^(BOOL finished){}];
        [UIView animateWithDuration:0.25 animations:^{
            _loginning.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-65, CGRectGetHeight(self.view.frame)/2+20, 120, 40);
//            _loginning.transform = CGAffineTransformMakeTranslation(0, -150);
        }completion:^(BOOL finished){}];
    }else{
        [UIView animateWithDuration:0.25 animations:^{_user.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-120, CGRectGetHeight(self.view.frame)/2-150, 240, 40);}completion:^(BOOL finished){}];
        [UIView animateWithDuration:0.25 animations:^{_password.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-120, CGRectGetHeight(self.view.frame)/2-95, 240, 40);}completion:^(BOOL finished){}];
        [UIView animateWithDuration:0.25 animations:^{
            _loginning.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-80, CGRectGetHeight(self.view.frame)/2-20, 120, 40);
            
        }completion:^(BOOL finished){}];
        [UIView animateWithDuration:0.25 animations:^{_forget_password.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2+60, CGRectGetHeight(self.view.frame)/2-5, 60, 30);}completion:^(BOOL finished){}];
    }
    return YES;
}
- (void)titleShow{
    _Stone.hidden = NO;
}

//btn deal
- (void)btnClicked:(id)sender{
    UIButton *button = (UIButton *)sender;

    if (1 == button.tag) {
        if (!_isRegist) {
            return;
        }
        [UIView animateWithDuration:0.3 animations:^{
            _loginning.transform = CGAffineTransformIdentity;
        }];
        
        _isRegist = NO;
        _repassword.hidden = YES;
        _forget_password.hidden = NO;
        _regist.backgroundColor = [UIColor whiteColor];
        [_regist setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _login.backgroundColor = [UIColor grayColor];
        [_login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginning setTitle:@"登录" forState:UIControlStateNormal];
        
        //clear text
        _user.text = @"";
        _password.text = @"";
        [_user resignFirstResponder];
        [_password resignFirstResponder];
        [_repassword resignFirstResponder];
        
        //view change
        [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(titleShow) userInfo:nil repeats:NO];
        [UIView animateWithDuration:0.25 animations:^{_login.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-120, CGRectGetHeight(self.view.frame)/2-70, 120, 40);}completion:^(BOOL finished){}];
        [UIView animateWithDuration:0.25 animations:^{_regist.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2, CGRectGetHeight(self.view.frame)/2-70, 120, 40);}completion:^(BOOL finished){}];
        [UIView animateWithDuration:0.25 animations:^{_user.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-120, CGRectGetHeight(self.view.frame)/2, 240, 40);}completion:^(BOOL finished){}];
        [UIView animateWithDuration:0.25 animations:^{_password.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-120, CGRectGetHeight(self.view.frame)/2+55, 240, 40);}completion:^(BOOL finished){}];
        [UIView animateWithDuration:0.05 animations:^{_forget_password.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2+60, CGRectGetHeight(self.view.frame)/2+145, 60, 30);}completion:^(BOOL finished){}];
        [UIView animateWithDuration:0.25 animations:^{_loginning.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-80, CGRectGetHeight(self.view.frame)/2+130, 120, 40);}completion:^(BOOL finished){}];
        
    }else if (2 == button.tag) {
        [self textFieldShouldReturn:nil];
        if (_isRegist) {
            return;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            _loginning.transform = CGAffineTransformIdentity;
        }];
        
        _isRegist = YES;
        _repassword.hidden = NO;
        _forget_password.hidden = YES;
        _regist.backgroundColor = [UIColor grayColor];
        [_regist setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _login.backgroundColor = [UIColor whiteColor];
        [_login setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_loginning setTitle:@"注册" forState:UIControlStateNormal];
        
        //clear something
        _user.text = @"";
        _password.text = @"";
        _repassword.text = @"";
        [_user resignFirstResponder];
        [_password resignFirstResponder];
        [_repassword resignFirstResponder];
        
        //view change
        [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(titleShow) userInfo:nil repeats:NO];
        [UIView animateWithDuration:0.25 animations:^{_login.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-120, CGRectGetHeight(self.view.frame)/2-70, 120, 40);}completion:^(BOOL finished){}];
        [UIView animateWithDuration:0.25 animations:^{_regist.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2, CGRectGetHeight(self.view.frame)/2-70, 120, 40);}completion:^(BOOL finished){}];
        [UIView animateWithDuration:0.25 animations:^{_user.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-120, CGRectGetHeight(self.view.frame)/2, 240, 40);}completion:^(BOOL finished){}];
        [UIView animateWithDuration:0.25 animations:^{_password.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-120, CGRectGetHeight(self.view.frame)/2+55, 240, 40);}completion:^(BOOL finished){}];
        [UIView animateWithDuration:0.03 animations:^{_repassword.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-120, CGRectGetHeight(self.view.frame)/2+110, 240, 40);}completion:^(BOOL finished){}];
        [UIView animateWithDuration:0.13 animations:^{_loginning.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-65, CGRectGetHeight(self.view.frame)/2+170, 120, 40);}completion:^(BOOL finished){}];
        
    }else if (3 == button.tag){
        [self textFieldShouldReturn:nil];
        NSString *userMsg = _user.text;
        NSString *pswMsg = _password.text;
        NSString *repswMsg = _repassword.text;
        NSString *token = @"";
        
        if (!_isRegist) {
            MBProgressHUD *progressHub = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:progressHub];
            [progressHub show:YES];
            
            [[STNetwork alloc] loginUid:userMsg password:pswMsg token:token handler:^(NSString *domain, NSDictionary *dic) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [progressHub removeFromSuperview];
                    if (domain != nil) {
                        [MBProgressHUD showSuccess:domain toView:self.view];
                    } else {
                        [self successLogin];
                    }
                });
            }];
        } else {
            // 账号类型验证
//            NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
//            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
//            NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
//            NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
//            if (!([emailTest evaluateWithObject:userMsg] || [phoneTest evaluateWithObject:userMsg])) {
//                [MBProgressHUD showSuccess:@"请输入手机号或者邮箱号" toView:self.view];
//                return;
//            }
            if ([pswMsg length] == 0) {
                [MBProgressHUD showSuccess:@"请输入密码" toView:self.view];
                return;
            }
            if (![pswMsg isEqual:repswMsg]) {
                [MBProgressHUD showSuccess:@"两次输入密码不一样" toView:self.view];
                return;
            }
            
            MBProgressHUD *progressHub = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:progressHub];
            [progressHub show:YES];
            [[STNetwork alloc] registUid:userMsg password:pswMsg handler:^(NSString *domain) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [progressHub removeFromSuperview];
                    if (domain != nil) {
                        [MBProgressHUD showSuccess:domain toView:self.view];
                    } else {
                        [self successLogin];
                    }
                });
            }];
        }
    }
}

- (void)successLogin {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
