//
//  PairViewController.m
//  Muse
//
//  Created by pg on 16/5/16.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "PairViewController.h"
#import "HomeViewController.h"
#import "AddressBookController.h"

#import "DoubleProgressView.h"
#import "PairPopView.h"
#import "Photo.h"

#import "AskforFriendAttentionRequest.h"

@interface PairViewController ()

@property (nonatomic, weak) IBOutlet DoubleProgressView *progressView;

@property (nonatomic, weak) IBOutlet UIButton *selectBtn;
@property (nonatomic, strong) NSMutableArray<AddressPerson *> *selectArr;

@end

@implementation PairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
    self.selectArr = [NSMutableArray array];
    [_progressView setOuterProgress:1.f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - Action

- (IBAction)toNextAction:(id)sender {
    NSMutableString *phones = [[NSMutableString alloc] init];
    NSMutableString *remarks = [[NSMutableString alloc] init];
    for (NSInteger i = 0; i < self.selectArr.count; i++) {
        AddressPerson *addPerson = self.selectArr[i];
        if (i == 0) {
            [phones appendFormat:@"%@", addPerson.phone];
            [remarks appendFormat:@"%@", addPerson.name];
        } else {
            [phones appendFormat:@",%@", addPerson.phone];
            [remarks appendFormat:@",%@", addPerson.name];
        }
    }
    // 发送邀请请求
    [AskforFriendAttentionRequest startRequestWithPhones:phones
                                                 remarks:remarks
                                  completionBlockSuccess:^(id request) {
                                      [MBProgressHUD showSuccess:@"邀请信息已发出，等待确认"
                                                          toView:self.view];
                                  } failure:nil];
    
    HomeViewController *vc = [[HomeViewController alloc] initWithNibName:@"HomeViewController"
                                                                  bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Action

- (IBAction)toContactsAction:(id)sender {
    __weak typeof(self)weakSelf = self;
    AddressBookController *vc = [[AddressBookController alloc]initWithNibName:@"AddressBookController" bundle:nil];
    vc.onlySelectMuseUser = YES;
    vc.persons = self.selectArr;
    [vc setCompletionBlock:^(NSMutableArray<AddressPerson *> *persons) {
        weakSelf.selectArr = persons;
        [weakSelf refreshSelectBtn];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)showFriendAction:(id)sender {
    if (_selectArr.count == 0) {
        [self toContactsAction:sender];
        return;
    }
    
    __weak typeof(self)weakSelf = self;
    PairPopView *pop = [PairPopView viewFromNibByVc:self peopleArr:_selectArr];
    [pop setCompletionBlock:^(NSMutableArray<AddressPerson *> *persons) {
        weakSelf.selectArr = persons;
        [weakSelf refreshSelectBtn];
    }];
    [pop show];
}

- (void)refreshSelectBtn {
    for (UIView *v in self.selectBtn.subviews) {
        if(v.tag == 99) {
            [v removeFromSuperview];
        }
    }
    
    if(_selectArr.count) {
        [self.selectBtn setTitle:@"" forState:UIControlStateNormal];
    } else {
        [self.selectBtn setTitle:@"添加亲友" forState:UIControlStateNormal];
    }
    
    NSUInteger count = MIN(_selectArr.count, 4);
    
    UIImage *image = [UIImage imageNamed:@"icon_loading_people"];
    CGFloat margin = 12;
    CGFloat total_w = count *(image.size.width) + margin * (count -1);
    
    CGFloat x = (_selectBtn.frame.size.width - total_w)/2;
    for (int i = 0; i < count; i++) {
        UIImageView *headimv = [[UIImageView alloc]initWithImage:image];
        headimv.frame = CGRectMake(x, (_selectBtn.frame.size.height - image.size.height)/2, image.size.width, image.size.height);
        headimv.tag = 99;
        [self.selectBtn addSubview:headimv];
        
        x += image.size.width+margin;
    }
}

@end
