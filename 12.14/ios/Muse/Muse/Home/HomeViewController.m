//
//  HomeViewController.m
//  Muse
//
//  Created by pg on 16/5/13.
//  Copyright © 2016年 Muse. All rights reserved.
//
#import "UpdateVersonViewController.h"


#import "HomeViewController.h"
#import "HeartViewController.h"
#import "DeviceSelectionViewController.h"

#import "MusePageControl.h"

#import "HeartRatePopHelpView.h"
#import "ShareView.h"

#import "AppDelegate.h"
#import "UIView+FastKit.h"

#import "HomeViewCollectModel.h"

#import "BlueToothHelper.h"

#import "NewsNoticeViewController.h"

#import "HeartRatePopHelpView.h"
#import "LocationServer.h"
#import "LCSOSHandler.h"
#import "AddressBookManager.h"

#import "PublicNumberView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVCaptureDevice.h>

#import "HeartRateDataManager.h"

#import "ContactManager.h"


@interface HomeViewController ()<UIScrollViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    HeartRateDataManager *_dataManager;
    
    HeartTestManager *testManager;
    
}

@property (nonatomic,strong) UICollectionView *mycollectionView;
@property (nonatomic,assign) NSInteger selectType;

@property (nonatomic,strong) HomeViewCollectModel *collectModel;

@property (nonatomic,weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic,weak) IBOutlet MusePageControl *pageControll;

@property (nonatomic,strong) UIView *rightView;
/**  */
@property (nonatomic, strong) NSMutableArray *friendPartnershipArray;

@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property ContactManager *manager;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    
    [self setupHeaderView:ControllerHeaderTypeDefault];
    self.headerView.backButton.hidden = YES;
    
    self.collectModel = [[HomeViewCollectModel alloc] init];
    self.collectModel.fatherVC = self;
    
    [self getContact];

    
    [self addUIs];
    [self searchDevice];
    [self registerNotification];
    
    _dataManager = [[HeartRateDataManager alloc] init];
    
    
    testManager = [HeartTestManager sharedInstance];
    [testManager initManager];
}


- (void)getContact {
    _manager = [ContactManager sharedInstance];
    [_manager getAllContact];
    
}

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayMessageRedView:) name:ReceiveFriendAskforNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getaddressAndSendMessage) name:SendSecretNotification object:nil];
}

- (void)displayMessageRedView:(NSNotification *)notification {
    
    [[BlueToothHelper sharedInstance]lightingWithColor:LightColorGreen duration:1];
    
    NSDictionary *dict = notification.userInfo;
    NSDictionary *message = dict[@"message"];
    NSString *mes = message[@"message"];
    
    
    
    _manager.currentAddFriendPhone = message[@"from_phone"];
    if (_manager.allContacts.count > 0) {
        
        for (AddressPerson *person in _manager.allContacts) {
            if ([person.phone containsString:message[@"from_phone"]]) {
                mes = [NSString stringWithFormat:@"%@%@", person.name, NSLocalizedString(@"wantbeyourfriend", nil)];
                _manager.currentAddFriendName = person.name;
                break;
            }
        }
    }
    
// 亲友邀请提示
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:mes delegate:self cancelButtonTitle:NSLocalizedString(@"addfriendlater", nil) otherButtonTitles:NSLocalizedString(@"addfriendnow", nil), nil];
        [alertView show];
    });
}

- (void)displayMiYuRedView {
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [AppDelegate appDelegate].floatingWindow.hidden = NO;
    [AppDelegate appDelegate].messageFloatingWindow.hidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [AppDelegate appDelegate].floatingWindow.hidden = YES;
    [AppDelegate appDelegate].messageFloatingWindow.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
#pragma mark --<UIAlertViewDelegate>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.friendPartnershipArray = [[[NSUserDefaults standardUserDefaults] objectForKey:FriendListPartishipKey] mutableCopy];
    NSDictionary *dict = [self.friendPartnershipArray lastObject];
    NSString *from_id = dict[@"from_id"];
//    [MBProgressHUD showHUDWithMessageOnly:@"处理中"];
    if (buttonIndex == 0) { // 取消
//        [DisposeFriendPartnershipRequest startWithFromID:from_id agree:NO completionBlockSuccess:^(id request) {
//            [self.friendPartnershipArray removeLastObject];
//            [[NSUserDefaults standardUserDefaults] setObject:self.friendPartnershipArray forKey:FriendListPartishipKey];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        } failure:^(id request) {
//            NSString *message = request[@"message"];
//            if (message) {
//                [MBProgressHUD showError:message toView:self.view];
//            }else {
//                [MBProgressHUD showError:NSLocalizedString(@"Network Error", nil) toView:self.view];
//            }
//        }];

    }else if (buttonIndex == 1) {
        
        [DisposeFriendPartnershipRequest startWithFromID:from_id agree:YES completionBlockSuccess:^(id request) {
            [self.friendPartnershipArray removeLastObject];
            [[NSUserDefaults standardUserDefaults] setObject:self.friendPartnershipArray forKey:FriendListPartishipKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [kNotificationCenter postNotificationName:Refresh_FriendAskforMessageAgreeNotification object:nil];
            
        } failure:^(id request) {
            NSString *message = request[@"message"];
            if (message) {
                [MBProgressHUD showError:message toView:self.view];
            }else {
                [MBProgressHUD showError:NSLocalizedString(@"Network Error", nil) toView:self.view];
            }
        }];
    }
}
#pragma mark - Private

- (void)addUIs {
    
    [[AppDelegate appDelegate] floatingWindow];
    
    [self addRoundView];
    [self addCollectionView];
    
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 2, [UIScreen mainScreen].bounds.size.height-self.headerView.height);
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    
    [self setPageControll];
    
    [self.headerView.rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)addCollectionView {
    self.rightView = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - self.headerView.height)];
    
    [self.scrollView addSubview:self.rightView];
    
    self.mycollectionViewArr = @[
                                 @{@"name":NSLocalizedString(@"Notification", nil),@"image":[UIImage imageNamed:@"icon_homepage_notice"]},
                                 //                                 @{@"name":NSLocalizedString(@"拍照", nil),@"image":[UIImage imageNamed:@"icon_homepage_photo"]},
                                 @{@"name":NSLocalizedString(@"M  you", nil),@"image":[UIImage imageNamed:@"icon_homepage_mini"]},
                                 @{@"name":NSLocalizedString(@"Anti-lost", nil),@"image":[UIImage imageNamed:@"icon_homepage_close"]},
                                 @{@"name":NSLocalizedString(@"Help", nil),@"image":[UIImage imageNamed:@"icon_homepage_sos"]},
                                 @{@"name":NSLocalizedString(@"Morse", nil),@"image":[UIImage imageNamed:@"icon_homepage_argot"]},
                                 @{@"name":NSLocalizedString(@"Settings", nil),@"image":[UIImage imageNamed:@"icon_homepage_set"]}];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    //        flowLayout.headerReferenceSize = CGSizeMake(MainScreenSize.width, 22);  //设置head大小
    
    self.mycollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(50, 40, self.rightView.width - 100, self.rightView.height - 160) collectionViewLayout:flowLayout];
    self.mycollectionView.backgroundColor = nil;
    
    self.mycollectionView.delegate = self.collectModel;
    self.mycollectionView.dataSource = self.collectModel;
    self.mycollectionView.scrollEnabled = NO;
    
    [self.mycollectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    
    [self.rightView addSubview:self.mycollectionView];
}

- (void)addRoundView {
    //    self.progressItems = @[@{@"top_image":[UIImage imageNamed:@"icon_homepage_heartrate"],
    //                             @"unit":NSLocalizedString(@"次/分", nil),
    //                             @"bottom_image":[UIImage imageNamed:@"icon_disk_health"],
    //                             @"progess":@0.5f,
    //                             @"dataNum":@"105"},
    //
    ////                            @{@"top_image":[UIImage imageNamed:@"icon_homepage_steps"],
    ////                              @"unit":NSLocalizedString(@"步", nil),
    ////                              @"progess":@0.5f,
    ////                              @"bottomContent":@"5.7公里｜345.1千卡"},
    //
    //                            @{@"top_image":[UIImage imageNamed:@"icon_homepage_sleep"],
    //                              @"unit":NSLocalizedString(@"小时", nil),
    //                              @"bottom_image":@"",
    //                              @"progess":@0.5f,
    //                              @"bottomContent":@"睡眠质量：良",
    //                              @"dataNum":@"2.05"}];
    //
    //    CGFloat contentHeight = [UIScreen mainScreen].bounds.size.height - self.headerView.height - 6 - 80;//80是下面部分的高度
    //    self.carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 6, [UIScreen mainScreen].bounds.size.width, contentHeight)];
    //    self.carousel.delegate = self.tableModel;
    //    self.carousel.dataSource = self.tableModel;
    //    self.carousel.vertical = YES;
    //    self.carousel.clipsToBounds = YES;
    //    [self.scrollView addSubview:self.carousel];
    
    CGFloat contentHeight = [UIScreen mainScreen].bounds.size.height - self.headerView.height - 6 - 80;//80是下面部分的高度
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 6, [UIScreen mainScreen].bounds.size.width, contentHeight)];
    [self.scrollView addSubview:mainView];
    
    
    UIImage *heart = [UIImage imageNamed:@"btn_homepage_heart"];
    CGRect frame = CGRectZero;
    frame.origin = CGPointMake((mainView.width - heart.size.width)/2, 86);
    frame.size = heart.size;
    UIButton *heartButton = [[UIButton alloc] initWithFrame:frame];
    [heartButton setImage:heart forState:UIControlStateNormal];
    [heartButton addTarget:self action:@selector(pushToDetail:) forControlEvents:UIControlEventTouchUpInside];
    [heartButton setExclusiveTouch:YES];
    [mainView addSubview:heartButton];
    heartButton.tag = 0;
    
    //    UIImage *sleep = [UIImage imageNamed:@"btn_homepage_sleep"];
    //    frame.origin.y = heartButton.bottom + 30;
    //    UIButton *sleepButton = [[UIButton alloc] initWithFrame:frame];
    //    [sleepButton setImage:sleep forState:UIControlStateNormal];
    //    [sleepButton addTarget:self action:@selector(pushToDetail:) forControlEvents:UIControlEventTouchUpInside];
    //    [mainView addSubview:sleepButton];
    //    sleepButton.tag = 1;
    
    UIImage *photoImage = [UIImage imageNamed:@"btn_homepage_camera"];
    frame.origin.y = heartButton.bottom + 30;
    UIButton *photoButton = [[UIButton alloc] initWithFrame:frame];
    [photoButton setImage:photoImage forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(pushToDetail:) forControlEvents:UIControlEventTouchUpInside];
    [photoButton setExclusiveTouch:YES];
    [mainView addSubview:photoButton];
    photoButton.tag = 1;
}

- (void)setPageControll {
    self.pageControll.currentPage = 0;
    self.pageControll.numberOfPages = 2;
}

- (void)pushToDetail:(UIButton *)button {
    UIViewController *vc;
    switch (button.tag) {
        case 0:
            vc = [[HeartViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        case 1:
            //            vc = [[SleepViewController alloc] init];
            [self takePhoto:nil];
                     break;
        default:
            return;
    }
}

- (void)takePhoto:(id)sender {
    
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [MBProgressHUD showHUDWithMessageOnly:NSLocalizedString(@"deviceNoCamera", nil)];
        return;
    }
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
    {
        //无权限 做一个友好的提示
        UIAlertView * alart = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"cameraNoPermission", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil, nil];
        [alart show];
        return ;
    }
    
    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
        //无权限做一个友好的提示
        UIAlertView * alart = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"cameraNoPermission", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil, nil];
        [alart show];
        return ;
    }

    
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
//    view.backgroundColor = [UIColor yellowColor];
    
    
    CameraViewController *vc = [[CameraViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
   

    
}

#pragma mark - Actions

- (void)rightAction {
    
    HeartRatePopHelpView *setPop = [HeartRatePopHelpView viewFromNibByVc:self];
   
    [setPop show];
}

- (IBAction)share:(id)sender {
    
    ShareView *view = [ShareView popShow];
    view.captureView = self.view;
}

- (IBAction)gotoPublic:(id)sender {
    
    
    MSLog(@"主页跳转到公众号");
    
    [PublicNumberView popShow];
    
}

#pragma mark - BLE

- (void)searchDevice {
    BlueToothHelper *bt = [BlueToothHelper sharedInstance];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"LastConnectedDevice"]) {
        bt.needPop = true;
        [bt cancelAllConnected];
        [bt _setupBabyDelegate];
        
        [self scanAllMuseDevice];
    } else {
        bt.needPop = false;
        if (bt.connectedPeripheral.state != CBPeripheralStateConnected) {
            [bt _setupBabyDelegate];
//            [bt cancelAllConnected];
            [[BlueToothHelper sharedInstance] tryToConnectLastConnectedDevice2];
        }
    }
    
    
   
}

- (void)scanAllMuseDevice {
    
    BlueToothHelper *bt = [BlueToothHelper sharedInstance];
    [bt startScanWithCompletion:^(NSArray<CBPeripheral *> * _Nonnull scanedPeripherals) {
        
        MSLog(@"搜索页搜索完毕");
        if (scanedPeripherals.count) {
            if (scanedPeripherals.count == 1) {
                [bt connectPeripheral:[scanedPeripherals firstObject]
                          deviceQurey:NO
                           completion:^(BOOL successed) {
                               if (successed) {
                                   //                                       [self setSearchSuccessedStep];
                               } else {
                                   //                                       [self setSearchFailedStep];
                                   [MBProgressHUD showHUDWithMessageOnly:NSLocalizedString(@"searchButConF", nil)];
                               }
                           }];
            } else {
                DeviceSelectionViewController *vc = [[DeviceSelectionViewController alloc] init];
                vc.peripherals = scanedPeripherals;
                [vc setCompletionBlock:^(CBPeripheral *selectedPeripheral) {
                    [bt connectPeripheral:selectedPeripheral
                              deviceQurey:NO
                               completion:^(BOOL successed) {
                                   if (successed) {
                                       //                                   [self setSearchSuccessedStep];
                                   } else {
                                       //                                   [self setSearchFailedStep];
                                       [MBProgressHUD showHUDWithMessageOnly:NSLocalizedString(@"searchButConF", nil)];
                                   }
                               }];
                }];
                [self presentViewController:vc animated:YES completion:nil];
            }
            
            
            
        } else {
            [self scanAllMuseDevice];
        }
    }];

}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.pageControll.currentPage = index;
}


#pragma mark --<密语发送>
/** 发送密语 */
- (void)sendSecretMessage:(NSString *)address
{
    [[BlueToothHelper sharedInstance] lightingWithColor:LightColorBlue duration:1];
    
    [self sendSecretWithPersonArray:[[LCSOSHandler loadSecretTalkContacts] mutableCopy] address:address];
}
- (void)getaddressAndSendMessage
{
    if ([CURRENTLANGUAGE hasPrefix:@"zh-"]) {
        // 是否发送位置信息
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:USERMILOCATIONSTATE] boolValue] == YES) {
            [[LocationServer sharedServer] locateWithCompletion:^(BMKReverseGeoCodeResult *locationResult) {
                if (CLLocationCoordinate2DIsValid(locationResult.location)
                    && locationResult.address.length) {
                    
                    NSString *address = [NSString stringWithFormat:@"%@:%.2f,%@:%.2f,%@:%@", NSLocalizedString(@"long", nil), locationResult.location.longitude, NSLocalizedString(@"la", nil),locationResult.location.latitude, NSLocalizedString(@"address", nil), locationResult.address];
                    
                    [self sendSecretMessage:address];
                } else {
                    
                }
            }];
        } else {
            [self sendSecretMessage:@"No Address"];
        }
        
    } else {
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:USERMILOCATIONSTATE] boolValue] == YES) {
        [[LocationServer sharedServer] locate_CL_WithCompletion:^(CLPlacemark *locationResult) {
            if (locationResult.addressDictionary[@"FormattedAddressLines"]) {
                NSString *address = [NSString stringWithFormat:@"%@:%.2f,%@:%.2f,%@:%@", NSLocalizedString(@"long", nil), locationResult.location.coordinate.longitude, NSLocalizedString(@"la", nil),locationResult.location.coordinate.latitude, NSLocalizedString(@"address", nil), [locationResult.addressDictionary[@"FormattedAddressLines"] firstObject]];
                
                [self sendSecretMessage:address];
            } else {
            }
            
        }];
        } else {
            [self sendSecretMessage:@"No Address"];
        }
    }
    
}
#pragma mark --<判断亲友发送>
- (void)sendSecretWithPersonArray:(NSArray *)array address:(NSString *)address {
    
    NSString *message = [[NSUserDefaults standardUserDefaults] objectForKey:MiNiMessageKey];
    
    //  NSString *message = [[NSUserDefaults standardUserDefaults] objectForKey:SOSMessageKey];
    if (message.length == 0) {
        message = NSLocalizedString(@"Honey, Come on!", nil);
    }
    
    if (array.count == 0) {
        MSLog(@"没有需要发送的对象");
    }else {
        
        NSMutableString *phones = [[NSMutableString alloc] init];
        
        
        if (array.count == 1) {
            AddressPerson *person = [array firstObject];
            phones = [[phones stringByAppendingString:[NSString stringWithFormat:@"%@", person.phone]] mutableCopy];
        } else {
            for (AddressPerson *person in array) {
                
                phones = [[phones stringByAppendingString:[NSString stringWithFormat:@"%@,", person.phone]] mutableCopy];
                
            }
            
            NSString *str = [phones substringToIndex:phones.length - 1];
           [phones setString:str];
        }

        
        [self sendMessageSMSToAddressBook:phones message:message address:address];
        
    }
    
}


- (void)sendMessageSMSToAddressBook:(NSString *)phones message:(NSString *)message address:(NSString *)address
{
    
    LRLog(@"%@",phones );
    // 发送密语到对象
    NSString *newStr;

    if ([address isEqualToString:@"No Address"]) {
        newStr = message;
    } else {
        newStr = [NSString stringWithFormat:@"%@，%@",message,address];
    }
    
    [SendSecrectToFriendRequest startWithUserID:phones sendMessage:
                         newStr completionBlockSuccess:^(id request) {
        
        MSLog(@"在这里🌩MIYU%@", request);
        [MBProgressHUD showSuccess:NSLocalizedString(@"miSendS", nil) toView:nil];
    } failure:^(id request) {
        MSLog(@"失败");
        [MBProgressHUD showError:NSLocalizedString(@"miSendF", nil) toView:nil];
    }];
}


@end
