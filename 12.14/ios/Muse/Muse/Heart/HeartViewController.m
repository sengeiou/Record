//
//  HeartViewController.m
//  Muse
//
//  Created by Ken.Jiang on 31/5/2016.
//  Copyright © 2016 Muse. All rights reserved.
//

#import "HeartViewController.h"

#import "HeartDataView.h"

#import "ChartBarView.h"
#import "HeartRatePopView.h"
#import "HeartRatePopHelpView.h"

#import "BlueToothHelper.h"
#import "NSTimer+FastKit.h"
#import "UIColor+FastKit.h"
#import "HeartRateDataManager.h"
#import "NSDate+FastKit.h"

#import "LocationServer.h"

#import "AppDelegate.h"

#import "MSGetMyHeartRateRequest.h"
#import "MSHeartAlertRequest.h"

#define MaxShowMonth    6

NSString *const LASTHEARTTATE = @"LASTHEARTTATE";

@interface HeartViewController () <iCarouselDataSource, iCarouselDelegate, ChartBarViewDataSource, ChartBarDataSource, HeartDataViewDataSource, HeartRateDataManagerDelegate, HeartTestManagerDelegate> {
    
//    HeartDataView *_heartDataView;
    
    HeartRateDataManager *_dataManager;
    
    NSInteger _lastRecordOffset;
    
    double progressCount__;
    
    
    NSMutableArray *heartDataListArray;
    
    float resultHeartRate;
    
    
    HeartTestManager *testManager;
    
    BOOL isAuto;
    
}

@property (weak, nonatomic) NSTimer *monitorTimer;

@property (assign, nonatomic) NSInteger currentYear;

@property (assign, nonatomic) NSInteger currentMonth;

@end

@implementation HeartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    heartDataListArray = [[NSMutableArray alloc] initWithCapacity:0];
//    [self.view layoutIfNeeded];
    
    [self setupHeaderView:ControllerHeaderTypeHeart];
    
    [self.headerView.rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    
  //  self.detailProgressView.typeTopIMV.hidden = YES;
    
    _dataManager = [[HeartRateDataManager alloc] init];
    
    
    progressCount__ = 0;
    
    _dataManager.delegate = self;
    
    testManager = [HeartTestManager sharedInstance];
    testManager.delegate = self;
    
    NSString *lastHeartRateStr = [kUserDefaults objectForKey:LASTHEARTTATE];
    
    isAuto = YES;
    
    // 看看是不是在测试心率中.
    if (testManager.isTestHeart == YES) {
        [self.detailProgressView startHeartRipple];
        
    } else {
        
        self.detailCenterButton.enabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.detailCenterButton.enabled = YES;
        });
        
        if (lastHeartRateStr) {
            
            NSInteger lastHeartRate = [lastHeartRateStr integerValue];
            
            [self changeHeartImageWithHeartRate:lastHeartRate isFrist:YES];
            
            
        }else {
            //初始化界面
            self.detailProgressView.cellData = @{@"unit":NSLocalizedString(@"unit_disk_heartrate", nil),
                                                 @"bottom_image":@"icon_disk_health",
                                                 @"progess":@0,
                                                 @"dataNum":@"000"};
            
            // self.detailProgressView.progressView.outerImageLayer.contents = (id)[[UIImage imageNamed:@"circle_disk_red"] CGImage];
            //self.detailProgressView.progressView.outerProgress = 1.f;
            
            
        }
    }
    
 
    

    
    
    self.detailProgressView.userInteractionEnabled = NO;
//    [self.detailCenterButton setImage:[UIImage imageNamed:@"btn_secondarypage_heart"]
//                             forState:UIControlStateNormal];
//    [self.detailCenterButton setTitle:localizedString(@"measureHeartate")
//                             forState:UIControlStateNormal];
    [self.detailCenterButton addTarget:self action:@selector(startMonitorHeartRate:)
                      forControlEvents:UIControlEventTouchUpInside];
    
//    _heartDataView = [HeartDataView viewFromNib];
//    _heartDataView.dataSource = self;
    
    
//      本地拿数据取消, 改为接口获取
//    _lastRecordOffset = 0;
//
//    
//    for (NSInteger i = 0; i >= 0; i ++) {
//        NSDictionary *data = [_dataManager heartRateRecordLastWithOffset:_lastRecordOffset];
//        if (!data) {
//            [_dataListView.listTbv reloadData];
//            break;
//        }
//        
//        [heartDataListArray addObject:data];
//        
//        _lastRecordOffset ++;
//    }
//    

    
    
    NSDate *date = [NSDate date];
    _currentYear = date.year;
    _currentMonth = date.month;
    
//    _heartDataView.chartContainer.dataSource = self;
//    _heartDataView.chartContainer.delegate = self;
    
    
    
    
//    [self.dataContainer insertSubview:_heartDataView atIndex:1];
    
    
    _dataListView = [[[NSBundle mainBundle] loadNibNamed:@"HeartDataListView" owner:self options:nil] lastObject];
    _dataListView.titleLbl.text = NSLocalizedString(@"heartHis", nil);
    _dataListView.listTbv.delegate = self;
    _dataListView.listTbv.dataSource = self;
    [self.dataContainer insertSubview:_dataListView atIndex:1];
        [_dataListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.dataContainer);
        }];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [header setTitle:NSLocalizedString(@"Pull down to refresh", nil) forState:MJRefreshStateIdle];
    [header setTitle:NSLocalizedString(@"Release to refresh", nil) forState:MJRefreshStatePulling];
    [header setTitle:NSLocalizedString(@"Loading ...", nil) forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    _dataListView.listTbv.mj_header = header;
    
    
    [kNotificationCenter addObserver:self selector:@selector(refreshHeartRate) name:Notify_UploadHeartRateSucceed object:nil];
}

- (void)refreshHeartRate {
    if ([_dataListView.listTbv.mj_header isRefreshing]) {
        return;
    }
    [self loadNewData];
}

- (void)loadNewData {
    
    MSGetMyHeartRateRequest *req = [[MSGetMyHeartRateRequest alloc] init];
    [req startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        [heartDataListArray removeAllObjects];
        
        [_dataListView.listTbv.mj_header endRefreshing];
        
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
        if (MSRequestIsSuccess(responseData)) {
            MSLog(@"succeed download rate");
            for (NSInteger i = 0; i < [responseData[@"data"] count]; i ++) {
                [heartDataListArray addObject:responseData[@"data"][i]];
            }
        } else {
            MSLog(@"failed download rate");
        }
        
        [_dataListView.listTbv reloadData];
    } failure:^(__kindof YTKBaseRequest *request) {
        MSLog(@"failed upload rate");
        [_dataListView.listTbv.mj_header endRefreshing];

    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.dataContainer.hidden = YES;
    
}

- (void)viewDidDisappear:(BOOL)animated {

}

- (void)viewDidAppear:(BOOL)animated {
    if ([_dataListView.listTbv.mj_header isRefreshing]) {
        return;
    }
    [self loadNewData];
}


#pragma mark - Override

- (void)rightAction {
    
   // HeartRatePopHelpView *setPop = [HeartRatePopHelpView viewFromNibByVc:self];
    
    HeartRatePopView *setPop = [HeartRatePopView viewFromNibByVc:self];
    
    [setPop show];
}


#pragma mark - testManagerDelegate

- (void)testStart {
    self.detailProgressView.cellData = @{@"unit":NSLocalizedString(@"unit_disk_heartrate", nil),
                                         @"bottom_image":@"icon_disk_health",
                                         @"progess":@(0),
                                         @"dataNum":[NSString stringWithFormat:@"000"]};
    self.detailProgressView.progressView.outerImageLayer.contents = (id)[[UIImage imageNamed:@"circle_disk_yellow"] CGImage];
    self.detailProgressView.progressView.outerProgress = 0;
    self.detailProgressView.progressView.innerProgress = 0;
    
    
    [self.detailProgressView startHeartRipple];
}

- (void)testEnd:(NSUInteger)heartRate {
    MSLog(@"%ld", heartRate);
    
    if (heartRate == 0 || heartRate > 185) {
        if ([AppDelegate appDelegate].isBackgroundMode) {
            return;
        }
        [MBProgressHUD showHUDWithMessageOnly:NSLocalizedString(@"Please hand flat", nil)];
        testManager.isTestHeart = NO;
        [self.detailProgressView stopHeartRipple];
        self.detailProgressView.progressView.innerProgress = 0;
        isAuto = YES;
    } else {
        [_dataManager addANewHeartRate:heartRate isAuto:isAuto];
        [self stopMonitorHeartRate:heartRate];
        isAuto = YES;
    }
}

- (void)testingWithProgress:(float)progress {
    self.detailProgressView.progressView.innerProgress = progress;
}



#pragma mark - Private


- (void)updateOuterMonitorProgress:(NSTimer *)sender {
    progressCount__ += resultHeartRate;
    float progress = (progressCount__/50.f);
    self.detailProgressView.progressView.outerProgress = progress;
    
    
//    self.detailProgressView.dataLB.num = [NSString stringWithFormat:@"%03lu", (unsigned long)((progressCount__/50.f) * 160.f) - 1];
    
}

- (void)setOuterProgress {
    
    progressCount__ = 0;
    
    self.monitorTimer = [NSTimer fk_scheduledTimerWithTimeInterval:0.02
                                                            target:self
                                                          selector:@selector(updateOuterMonitorProgress:)
                                                          userInfo:nil
                                                           repeats:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.monitorTimer invalidate];
        self.monitorTimer = nil;
        
        self.detailProgressView.dataLB.num = [NSString stringWithFormat:@"%03lu", (unsigned long)(resultHeartRate * 160.f)];
    });
}

#pragma mark --<点击测心率>
- (void)startMonitorHeartRate:(id)sender {
    
    BlueToothHelper *bt = [BlueToothHelper sharedInstance];
    
    if (bt.connectedPeripheral.state != CBPeripheralStateConnected) {
        
        [MBProgressHUD showMessage:NSLocalizedString(@"noConMuse", nil) toView:self.view hideAfterDelay:3];

        
        return;
    }
    
    if (testManager.isTestHeart == YES) {
        [MBProgressHUD showMessage:NSLocalizedString(@"isTestingHeart", nil) toView:self.view hideAfterDelay:2];
        return;
    }
    
    isAuto = NO;
    
    [testManager startTest];
    
}

- (void)stopMonitorHeartRate:(NSUInteger)heartRate {
    
    
    testManager.isTestHeart = NO;
    
    [self.detailProgressView stopHeartRipple];
    
    self.detailProgressView.progressView.innerProgress = 0;
    
    
    // 停止测心率, 从数据库加东西后, 重新拿
//    _lastRecordOffset = 0;
//    
//    NSDictionary *data = [_dataManager heartRateRecordLastWithOffset:_lastRecordOffset];
//    
//    [heartDataListArray insertObject:data atIndex:0];
//    [_dataListView.listTbv reloadData];
    
    
//    [_heartDataView setDate:data[@"Date"] heartRate:data[@"HeartRate"]];
    
    [self changeHeartImageWithHeartRate:heartRate isFrist:NO];
}

//心率0-130-150－ 范围内UI显示
- (void)changeHeartImageWithHeartRate:(NSUInteger)heartRate isFrist:(BOOL)yes {
    
    NSString *heartStr = [NSString stringWithFormat:@"%lu",(unsigned long)heartRate];
    

    
    
    if (heartRate == 0 || heartRate > 185) {
        [MBProgressHUD showMessage:NSLocalizedString(@"Please hand flat", nil) toView:self.view hideAfterDelay:3];
        
        self.detailProgressView.cellData = @{@"unit":NSLocalizedString(@"unit_disk_heartrate", nil),
                                             @"bottom_image":@"icon_disk_health",
                                             @"progess":@(0),
                                             @"dataNum":[NSString stringWithFormat:@"000"]};
        self.detailProgressView.progressView.outerImageLayer.contents = (id)[[UIImage imageNamed:@"circle_disk_yellow"] CGImage];
        self.detailProgressView.progressView.outerProgress = 0;
        
        return;
    }
    
    [kUserDefaults setObject:heartStr forKey:LASTHEARTTATE];
    
    if (heartRate < 130) {
        self.detailProgressView.cellData = @{@"unit":NSLocalizedString(@"unit_disk_heartrate", nil),
                                             @"bottom_image":@"icon_disk_health",
                                             @"progess":@(heartRate/160.f),
                                             @"dataNum":[NSString stringWithFormat:@"%03lu", (unsigned long)heartRate]};
        self.detailProgressView.progressView.outerImageLayer.contents = (id)[[UIImage imageNamed:@"circle_disk_yellow"] CGImage];
//        self.detailProgressView.progressView.outerProgress = heartRate/150.f;
//        [self.detailProgressView.progressView setOuterProgress:heartRate/150.f animated:YES];
        
//        ZHLog10(@"%@",self.detailProgressView);
        
        resultHeartRate = heartRate/160.f;
        
        [self setOuterProgress];
        
        
        if(!yes) {
            
            [[BlueToothHelper sharedInstance] lightingWithColor:LightColorBlue duration:1];
        }
        
    } else  if (heartRate >= 130 && heartRate < 160) {
            self.detailProgressView.cellData = @{@"unit":NSLocalizedString(@"unit_disk_heartrate", nil),
                                                 @"bottom_image":@"icon_disk_danger2",
                                                 @"progess":@(heartRate/160.f),
                                                 @"dataNum":[NSString stringWithFormat:@"%03lu", (unsigned long)heartRate]};
            self.detailProgressView.progressView.outerImageLayer.contents = (id)[[UIImage imageNamed:@"circle_disk_orange"] CGImage];
            
            resultHeartRate = heartRate/160.f;

            [self setOuterProgress];
            
            if(!yes) {
                
                [[BlueToothHelper sharedInstance] lightingWithColor:LightColorBlue duration:1];
            }

            
        } else if (heartRate >= 160) {
            self.detailProgressView.cellData = @{@"unit":NSLocalizedString(@"unit_disk_heartrate", nil),
                                                 @"bottom_image":@"icon_disk_danger",
                                                 @"progess":@1,
                                                 @"dataNum":[NSString stringWithFormat:@"%03lu", (unsigned long)heartRate]};
            self.detailProgressView.progressView.outerImageLayer.contents = (id)[[UIImage imageNamed:@"circle_disk_red"] CGImage];
//            [self.detailProgressView.progressView setOuterColor:kRedColor];
//            self.detailProgressView.progressView.outerProgress = 1.f;
            
            resultHeartRate = heartRate / 160.f;
            
            [self setOuterProgress];
            
            if(!yes) {
                
                [[BlueToothHelper sharedInstance] lightingWithColor:LightColorRed duration:1];
            }

        }
        
        
            if (heartRate >= [[HeartRateDataManager alertHeartRate] integerValue]
            && [[BlueToothHelper sharedInstance] isMuseSettingEnable:BLESettingsOverHeartRate] && !yes) {
                
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                [[BlueToothHelper sharedInstance] lightingWithColor:LightColorRed duration:3];
            });
                
            //TODO: 自己心率超标，给亲友发送mqtt消息
            //           "该亲友心率超标：" + rate_now + "，"+APP.getInstance().mMyAddress
            NSMutableArray *friendList = [[DBManager sharedManager] getUserFriendListfromDB];
            NSMutableString *phones = [[NSMutableString alloc] init];
            for (NSDictionary *list in friendList) {
                phones = [[phones stringByAppendingString:[NSString stringWithFormat:@"%@,", list[@"phone"]]] mutableCopy];
            }
                
                
                if ([CURRENTLANGUAGE hasPrefix:@"zh-"]) {
                    [[LocationServer sharedServer] locateWithCompletion:^(BMKReverseGeoCodeResult *locationResult) {
                        if (CLLocationCoordinate2DIsValid(locationResult.location)
                            && locationResult.address.length) {
                            NSString *messageadd = [NSString stringWithFormat:@"%@:%f,%@:%f%@:%@", NSLocalizedString(@"long", nil), locationResult.location.longitude, NSLocalizedString(@"la", nil), locationResult.location.latitude, NSLocalizedString(@"address", nil), locationResult.address];
                            NSString *HQStr = [self appendingStringWith:heartStr and:messageadd];
                            [self sendHeartAlertMessage:HQStr];
                            
                        }
                    }];
                } else {
                    [[LocationServer sharedServer] locate_CL_WithCompletion:^(CLPlacemark *locationResult) {
                        if (locationResult.addressDictionary[@"FormattedAddressLines"]) {
                            NSString *messageadd = [NSString stringWithFormat:@"%@:%.2f,%@:%.2f,%@:%@", NSLocalizedString(@"long", nil), locationResult.location.coordinate.longitude, NSLocalizedString(@"la", nil),locationResult.location.coordinate.latitude, NSLocalizedString(@"address", nil), [locationResult.addressDictionary[@"FormattedAddressLines"] firstObject]];
                            
                            NSString *HQStr = [self appendingStringWith:heartStr and:messageadd];
                            [self sendHeartAlertMessage:HQStr];
                        }
                    }];
                }
            
        }else{
            //  [[BlueToothHelper sharedInstance] lightingWithColor:LightColorBlue duration:1];
        }

    
   // [[BlueToothHelper sharedInstance] lightingWithColor:LightColorBlue duration:1];
}
- (NSString *)appendingStringWith:(NSString *)message and:(NSString *)address {
    
    
    NSString *user = [MuseUser currentUser].nickname;
    
    if (!user) {
        user = [MuseUser currentUser].phone;
    }
    
    NSString *temp = [NSString stringWithFormat:@"%@\"%@\"%@:%@", NSLocalizedString(@"friend", nil), user, NSLocalizedString(@"heartrateoverproof", nil), message] ;
    
    NSString *HQStr = [temp stringByAppendingString:[NSString stringWithFormat:@",%@",address]];
    
    return HQStr;
    
}
#pragma mark - HeartRateDataManagerDelegate

/**
 *  通知已获取到数据（界面可刷新）
 */
- (void)dataManagerDidFecthDatas {
    
//    [_heartDataView.chartContainer reloadData];
    
    [_dataListView.listTbv reloadData];
}


#pragma mark --<超标发送心率>
- (void)sendHeartAlertMessage:(NSString *)message
{
    
    MSHeartAlertRequest *req = [[MSHeartAlertRequest alloc] initWithMessage:message];
    [req startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        MSLog(@"succeed send heartAlert");
    } failure:^(__kindof YTKBaseRequest *request) {
        MSLog(@"failed send heartAlert");
    }];
    
    
}





#pragma mark - LISTVIEW 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return heartDataListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HeartDataListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeartDataListCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HeartDataListCell" owner:self options:nil] lastObject];
    }
    
    // 设置 cell 先在外部实现
    NSString *heartRate = heartDataListArray[indexPath.row][@"rate"];
    
    if ([heartDataListArray[indexPath.row][@"auto"] boolValue] == YES) {
        cell.careImageView.hidden = NO;
    } else {
        cell.careImageView.hidden = YES;
    }
    
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[heartDataListArray[indexPath.row][@"created"] integerValue]];
    NSLog(@"%@", date);
    NSString *timeString = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
    
    NSArray *dates = [timeString componentsSeparatedByString:@" "];

    
    if (dates.count == 2) {
        cell.dateLbl.text = dates[0];
        cell.timeLbl.text = dates[1];
    } else {
        cell.dateLbl.text = @"0000-00-00";
        cell.timeLbl.text = @"00:00";
    }
    
    cell.rateLbl.text = [NSString stringWithFormat:@"%@ %@", heartRate, NSLocalizedString(@"Time/Min", nil)];
    
    return cell;
}





@end
