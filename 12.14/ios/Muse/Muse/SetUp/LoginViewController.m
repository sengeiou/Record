//
//  LoginViewController.m
//  Muse
//
//  Created by jiangqin on 16/4/14.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "LoginViewController.h"
#import "SearchDeviceViewController.h"

#import "NSString+FastKit.h"
#import "CALayer+FastKit.h"
#import "UIColor+FastKit.h"

#import "DoubleProgressView.h"

#import "MSRequestLogin.h"
#import "MSRequestVerificationCode.h"
#import "MuseUser.h"
#import "MSConstantDefines.h"

#import <SMS_SDK/Extend/SMSSDK+ExtexdMethods.h>
#import <SMS_SDK/Extend/SMSSDKCountryAndAreaCode.h>
#import <MOBFoundation/MOBFoundation.h>

#import "YTKNetworkConfig.h"

@interface LoginViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate> {
    BOOL _preNavHidden;
    
    NSMutableArray *countryArray;
}

@property (weak, nonatomic) IBOutlet UIButton    *mobileButton;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;

@property (weak, nonatomic) IBOutlet UIButton *getVerferButton;

@property (weak, nonatomic) IBOutlet UIButton  *pwdButton;

@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet DoubleProgressView *progressView;
@property IBOutlet NSLayoutConstraint *progressViewTopCons;
@property IBOutlet NSLayoutConstraint *loginBtnBottomCons;

@property IBOutlet UITableView *countryListTbv;
@property IBOutlet UIView *listBgView;

@property IBOutlet UIButton *areaBtn;

@property NSTimer *circleAnimatedTimer;

@property float animatedCount;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.mobileTextField.text = [MuseUser currentUser].phone;
    _isAllowEnterCode = YES;
    
    
    _listBgView.hidden = YES;
    _countryListTbv.hidden = YES;
    _countryListTbv.layer.cornerRadius = 6;
    
//    _areaBtn.layer.cornerRadius = 15;
//    _areaBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    _areaBtn.layer.borderWidth = 1;
    
    [_areaBtn setBackgroundImage:[UIImage imageNamed:@"btn_loading_1"] forState:UIControlStateNormal];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:USERAREACODE]) {
        [_areaBtn setTitle:[[NSUserDefaults standardUserDefaults] valueForKey:USERAREACODE] forState:UIControlStateNormal];
    } else if([CURRENTLANGUAGE hasPrefix:@"zh-"]) {
        [_areaBtn setTitle:@"中国+86" forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setValue:@"中国+86" forKey:USERAREACODE];
    } else {
        [_areaBtn setTitle:@"China+86" forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setValue:@"China+86" forKey:USERAREACODE];
    }
    
    
    [_mobileButton setTitle:NSLocalizedString(@"enterPhoneNumBtn", nil) forState:UIControlStateNormal];
    [_getVerferButton setTitle:NSLocalizedString(@"getVerferBtn", nil) forState:UIControlStateNormal];
    [_pwdButton setTitle:NSLocalizedString(@"pwdBtn", nil) forState:UIControlStateNormal];
    [_loginButton setTitle:NSLocalizedString(@"loginBtn", nil) forState:UIControlStateNormal];
    
    _mobileTextField.placeholder = NSLocalizedString(@"phonePlace", nil);
    _pwdTextField.placeholder = NSLocalizedString(@"verferPlace", nil);
   
    
    countryArray = [[NSMutableArray alloc] init];
    NSString *plistPath;
    
    
    if ([CURRENTLANGUAGE hasPrefix:@"zh-"]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"country-cn" ofType:@"plist"];
    } else {
        plistPath = [[NSBundle mainBundle] pathForResource:@"country-en" ofType:@"plist"];
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    
    NSArray *keyArr = [self getCountryKeyArray];
    
    for (NSInteger i = 0; i < keyArr.count; i ++) {
        NSArray *tempArr = dic[keyArr[i]];
        for (NSInteger i = 0; i < tempArr.count; i ++) {
            [countryArray addObject:tempArr[i]];
        }
    }
    [_countryListTbv reloadData];
    
    
    if ([kUserDefaults valueForKey:UserDefaultKey_DefaultPhone]) {
        _mobileTextField.text = [kUserDefaults valueForKey:UserDefaultKey_DefaultPhone];
    }
    
    
    if (kScreenWidth == 320) {
        self.progressViewTopCons.constant = 24;
        self.loginBtnBottomCons.constant = 32;
    }
    
    
    self.animatedCount = 0.f;
    self.circleAnimatedTimer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(playAnimated) userInfo:nil repeats:YES];
}

- (void)playAnimated {
    if (self.animatedCount > 1) {
        [self.circleAnimatedTimer setFireDate:[NSDate distantFuture]];
    }
    self.animatedCount += 0.001;
    [_progressView setOuterProgress:self.animatedCount animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _preNavHidden = self.navigationController.navigationBarHidden;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if (_isLoginFailed) {
        [MBProgressHUD showHUDWithMessageOnly:NSLocalizedString(@"Login Failed", nil)];
    }
    
  //  [_progressView setOuterProgress:0.50f animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:_preNavHidden animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Touch Evens

- (IBAction)hideTbv {
    _listBgView.hidden = YES;
    _countryListTbv.hidden = YES;
}

- (IBAction)prepareInputMoblie:(UIButton *)sender {
    sender.hidden = YES;
    _mobileTextField.hidden = NO;
    [_mobileTextField becomeFirstResponder];
}

- (IBAction)getVerificationCode:(UIButton *)sender {
    
    
    [self.view endEditing:YES];
    

    
    
    NSString *phone = _mobileTextField.text;
    if (phone.length == 0) {
//        [_mobileTextField.layer shakeLayer];
//        [MBProgressHUD showMessage:PHONENUMBERCOUNT toView:self.view hideAfterDelay:2];
        [MBProgressHUD showMessage:NSLocalizedString(@"phoneNumberLim", nil) toView:self.view hideAfterDelay:2];

        return;
    }
    
    
    MSRequestVerificationCode *req = [[MSRequestVerificationCode alloc] initWithPhone:phone];
    req.phone = phone;
    

    
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:USERAREACODE] == nil) {
        [MBProgressHUD showMessage:NSLocalizedString(@"PleaseSelectAreaCode", nil) toView:self.view hideAfterDelay:2];
        return;
    }
    
    
    if (_isAllowEnterCode == YES) {
        
        _isAllowEnterCode = NO;
        //        _getVerferButton.enabled = NO;
        
        _timeCount = 60;
        _cdTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(cdTimeCount) userInfo:nil repeats:YES];
//        [_cdTimer fire];
    } else {
        
        return;
    }
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *zoneStr;
    if ([[NSUserDefaults standardUserDefaults] valueForKey:USERAREACODE]) {
         zoneStr = [[[[NSUserDefaults standardUserDefaults] valueForKey:USERAREACODE] componentsSeparatedByString:@"+"] lastObject];

    } else {
        zoneStr = @"86";
    }
    

    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phone zone:zoneStr customIdentifier:nil result:^(NSError *error) {
        
        
        
        if (!error) {
            [hud hide:YES];
            [MBProgressHUD showSuccess:NSLocalizedString(@"smsCodeHadSend", nil) toView:self.view];
        } else {
            [hud hide:YES];
            [MBProgressHUD showMessage:NSLocalizedString(@"smsCodeHadSendF", nil) toView:self.view hideAfterDelay:2];
        }

    }];
    
    
    
//    [req startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        [hud hide:YES];
//        
//        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
//        if (MSRequestIsSuccess(responseData)) {
//            [MBProgressHUD showSuccess:NSLocalizedString(@"smsCodeHadSend", nil) toView:self.view];
//            
//            if (_isAllowEnterCode == YES) {
//                _timeCount = 60;
//                _cdTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(cdTimeCount) userInfo:nil repeats:YES];
//            }
//            
//        
//            
//        } else {
//            
//        }
//    } failure:^(__kindof YTKBaseRequest *request) {
//        [hud hide:YES];
//        
////        [MBProgressHUD showMessage:LOGINERROR toView:self.view hideAfterDelay:2];
//       [MBProgressHUD showMessage:NSLocalizedString(@"loginFailn", nil) toView:self.view hideAfterDelay:2];
//
//    }];
}

- (IBAction)prepareInputVerificationCode:(UIButton *)sender {
    sender.hidden = YES;
    [_pwdTextField becomeFirstResponder];
}

- (IBAction)login:(UIButton *)sender {
//    _mobileTextField.text = @"15321810042";
    
   
    
    NSString *phone = _mobileTextField.text;
    

//    if(![_pwdTextField.text isAuthCode]) {
////        [_pwdTextField.layer shakeLayer];
//        [MBProgressHUD showMessage:@"" toView:self.view hideAfterDelay:2];
//        return;
//    }
    
     
//     此处, 测试免输验证码
    
    if(![_pwdTextField.text length]) {
        //        [_pwdTextField.layer shakeLayer];
      //  [MBProgressHUD showMessage:@"验证码不能为空" toView:self.view hideAfterDelay:2];
         [MBProgressHUD showMessage:NSLocalizedString(@"pleaseEnterSMSCode", nil) toView:self.view hideAfterDelay:2];
        return;
    }

    NSString *zoneStr = [[[[NSUserDefaults standardUserDefaults] valueForKey:USERAREACODE] componentsSeparatedByString:@"+"] lastObject];

    
    /*
    [SMSSDK commitVerificationCode:_pwdTextField.text phoneNumber:phone zone:zoneStr result:^(SMSSDKUserInfo *userInfo, NSError *error) {
        NSLog(@"注册提交验证:%@", userInfo);
        NSLog(@"错误为:%@", error);
        if (error) {
            [MBProgressHUD showMessage:NSLocalizedString(@"checkCodeError", nil) toView:self.view hideAfterDelay:2];
            return ;
        } else {
            
            [MuseUser currentUser].phone = phone;
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            __weak typeof(self) weakSelf = self;
            MSRequestLogin *req = [[MSRequestLogin alloc] initWithPhone:phone];
            req.phone = phone;
            req.verificationCode = _pwdTextField.text;
            req.device_token = [MuseUser currentUser].device_token;
            
            [req startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
                [hud hide:YES];
                
                NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
                if (MSRequestIsSuccess(responseData)) {
                    NSDictionary *data = MSResponseData(responseData);
                    [MuseUser currentUser].user_id = data[@"user_id"];
                    [MSRequest setAccessToken:data[@"access_token"]];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:UserDefaultKey_LastUserPhone];
                    [[NSUserDefaults standardUserDefaults] setObject:[MuseUser currentUser].user_id forKey:UserDefaultKey_LastUserID];
                    [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:USERMILOCATIONSTATE];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:MonitorCallEvent];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:USERLOSTSTATE];
                    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:UserDefaultKey_DefaultPhone];

     
                    SearchDeviceViewController *vc = [[SearchDeviceViewController alloc] init];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                } else {
                    [MBProgressHUD showError:MSResponseMessage(responseData) toView:self.view];
                }
            } failure:^(__kindof YTKBaseRequest *request) {
                [hud hide:YES];
                
                [MBProgressHUD showMessage:NSLocalizedString(@"loginFailn", nil) toView:self.view hideAfterDelay:2];
            }];

            

        }
        
        
    }];
    */
    
    if ([[[[[NSUserDefaults standardUserDefaults] valueForKey:USERAREACODE] componentsSeparatedByString:@"+"] lastObject] isEqualToString:@"86"]) {
        [YTKNetworkConfig sharedInstance].baseUrl = MuseBaseURL;
    } else {
        [YTKNetworkConfig sharedInstance].baseUrl = MuseBaseURL_HK;
    }

   
    [MuseUser currentUser].phone = phone;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    MSRequestLogin *req = [[MSRequestLogin alloc] initWithPhone:phone];
    req.phone = phone;
    req.verificationCode = _pwdTextField.text;
    req.device_token = [MuseUser currentUser].device_token;
    
    [req startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [hud hide:YES];
        
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
        if (MSRequestIsSuccess(responseData)) {
            NSDictionary *data = MSResponseData(responseData);
            [MuseUser currentUser].user_id = data[@"user_id"];
            [MSRequest setAccessToken:data[@"access_token"]];
            
            [[NSUserDefaults standardUserDefaults] setObject:phone forKey:UserDefaultKey_LastUserPhone];
            [[NSUserDefaults standardUserDefaults] setObject:[MuseUser currentUser].user_id forKey:UserDefaultKey_LastUserID];
            [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:USERMILOCATIONSTATE];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:MonitorCallEvent];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:USERLOSTSTATE];
            [[NSUserDefaults standardUserDefaults] setObject:phone forKey:UserDefaultKey_DefaultPhone];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.circleAnimatedTimer invalidate];
            self.circleAnimatedTimer = nil;
            
            [CloudPushSDK bindAccount:[kUserDefaults valueForKey:UserDefaultKey_LastUserID] withCallback:^(CloudPushCallbackResult *res) {
                MSLog(@"阿里云推送账号绑定成功!");
            }];
            
            SearchDeviceViewController *vc = [[SearchDeviceViewController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:NO];
        } else {
            [MBProgressHUD showError:MSResponseMessage(responseData) toView:self.view];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        [hud hide:YES];
        
        [MBProgressHUD showMessage:NSLocalizedString(@"loginFailn", nil) toView:self.view hideAfterDelay:2];
    }];
    
  }

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self textFieldShouldReturn:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    if (textField.text.length > 0) {
        if ([textField isEqual:_mobileTextField]) {
           // textField.hidden = YES;
           // _mobileButton.hidden = NO;
            [_mobileButton setTitle:textField.text forState:UIControlStateNormal];
//            [_mobileButton setTitleColor:[[UIColor colorWithHex:0xC9CACA] colorWithAlphaComponent:0.1f]
//                                forState:UIControlStateNormal];
           

        } else {
//            [_loginButton setTitleColor:[UIColor colorWithHex:0xE1D2AF] forState:UIControlStateNormal];
            
//            [_getVerferButton setTitleColor:[[UIColor colorWithHex:0xC9CACA] colorWithAlphaComponent:0.1f]
//                                   forState:UIControlStateNormal];
//            [_pwdButton setTitleColor:[[UIColor colorWithHex:0xC9CACA] colorWithAlphaComponent:0.1f]
//                             forState:UIControlStateNormal];
        }
    } else {
        if ([textField isEqual:_mobileTextField]) {
            _mobileButton.hidden = NO;
            [_mobileButton setTitle:NSLocalizedString(@"enterPhoneNumber", nil) forState:UIControlStateNormal];
//            [_mobileButton setTitleColor:[UIColor colorWithHex:0xC9CACA] forState:UIControlStateNormal];
        }
        
//        [_getVerferButton setTitleColor:[UIColor colorWithHex:0xC9CACA] forState:UIControlStateNormal];
        _pwdButton.hidden = NO;
        _pwdTextField.text = nil;
//        [_loginButton setTitleColor:[UIColor colorWithHex:0xC9CACA] forState:UIControlStateNormal];
    }
    
    return YES;
}



#pragma mark - private method

- (void)cdTimeCount {
    _timeCount --;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_getVerferButton setTitle:[NSString stringWithFormat:@"%ld %@", (long)_timeCount, NSLocalizedString(@"Sec Retry", nil)] forState:UIControlStateNormal];
        [_getVerferButton setTitleColor:[[UIColor colorWithHex:0xC9CACA] colorWithAlphaComponent:0.1f]
                               forState:UIControlStateNormal];
    });
    
  
    
    if (_timeCount == 0) {
        [_cdTimer invalidate];
        _isAllowEnterCode = YES;
        _getVerferButton.enabled = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_getVerferButton setTitle:NSLocalizedString(@"getVerferBtn", nil) forState:UIControlStateNormal];
            [_getVerferButton setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];

        });

    } else {
       
    }
}


//------  TableView ------//

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  countryArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CountryCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CountryCodeCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CountryCodeCell" owner:self options:nil] firstObject];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", countryArray[indexPath.row]];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[NSUserDefaults standardUserDefaults] setValue:countryArray[indexPath.row] forKey:USERAREACODE];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_areaBtn setTitle:countryArray[indexPath.row] forState:UIControlStateNormal];
    
    _listBgView.hidden = YES;
    _countryListTbv.hidden = YES;
}

- (IBAction)areaBtn:(id)sender {
    if (_listBgView.hidden == NO) {
        
        return;
    } else {
        _countryListTbv.hidden = NO;
        _listBgView.hidden = NO;

//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//
//        [SMSSDK getCountryZone:^(NSError *error, NSArray *zonesArray) {
//            [hud hide:YES];
//            if (!error)
//            {
//                NSLog(@"get the area code sucessfully");
//                //区号数据
//                if ([zonesArray isKindOfClass:[NSArray class]])
//                {
//                    [countryArray setArray: zonesArray];
//                    [_countryListTbv reloadData];
//                    _listBgView.hidden = NO;
//
//                }
//                //获取到国家列表数据后对进行缓存
//                //            [[MOBFDataService sharedInstance] setCacheData:zonesArray forKey:@"countryCodeArray" domain:nil];
//                //设置缓存时间
//                //            NSDate *saveDate = [NSDate date];
//                //            [[NSUserDefaults standardUserDefaults] setObject:[MOBFDate stringByDate:saveDate withFormat:@"yyyy-MM-dd"] forKey:@"saveDate"];
//                
//                
//                
//            }
//            else
//            {
//                NSLog(@"failed to get the area code _%@______error_%@",[error.userInfo objectForKey:@"getZone"],error);
//            }
//        }];

        
    }
    
}

- (NSArray *)getCountryKeyArray {
    return @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", ];
}


@end
