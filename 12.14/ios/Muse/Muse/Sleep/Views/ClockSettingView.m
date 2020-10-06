//
//  ClockSettingView.m
//  Muse
//
//  Created by Ken.Jiang on 23/6/2016.
//  Copyright © 2016 Muse. All rights reserved.
//

#import "ClockSettingView.h"
#import "ClockSettingTableHeader.h"
#import "ClockSettingTableViewCell.h"

#import "ClockManager.h"
#import "UIColor+FastKit.h"
#import "BlueToothHelper.h"

@interface ClockSettingView () <ClockSettingTableHeaderDelegate, ClockSettingTableViewCellDelegate> {
    NSInteger _expandSection;
    NSMutableArray *_editingStates;
    
    NSString *_headerIdentifier;
    NSString *_cellIdentifier;
}

@property (weak, nonatomic) IBOutlet UIImageView *clockIconView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addClockButton;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTopConstraint;

@end

@implementation ClockSettingView

static UIWindow *_alertWindow = nil;

+ (UIWindow *)alertWindow {
    if (!_alertWindow) {
        _alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _alertWindow.windowLevel = UIWindowLevelAlert;
        [_alertWindow makeKeyAndVisible];
    }
    
    return _alertWindow;
}

+ (void)purgerAlertWindow {
    _alertWindow = nil;
}

+ (ClockSettingView *)viewFromNib {
    ClockSettingView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil] firstObject];
    
    return view;
}

- (void)awakeFromNib {
    _expandSection = -1;
    
    _tableView.backgroundColor = [UIColor colorWithHex:0xEAEFF0];
    
    _editingStates = [NSMutableArray array];
    
    NSUInteger count = [ClockManager sharedManager].clocks.count;
    for (int i = 0; i < count; i++) {
        [_editingStates addObject:@NO];
    }
    if (count >= 5) {
        _addClockButton.hidden = YES;
    }
    
    _headerIdentifier = @"HeaderIdentifier";
    [_tableView registerNib:[UINib nibWithNibName:@"ClockSettingTableHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:_headerIdentifier];
    
    _cellIdentifier = @"CellIdentifier";
    [_tableView registerNib:[UINib nibWithNibName:@"ClockSettingTableViewCell" bundle:nil] forCellReuseIdentifier:_cellIdentifier];
}

#pragma mark - Setter

- (void)setFullMode:(BOOL)fullMode {
    if (_fullMode == fullMode) {
        return;
    }
    
    _fullMode = fullMode;
    _dismissButton.enabled = !fullMode;
    _clockIconView.hidden = fullMode;
    if (fullMode) {
        _contentTopConstraint.constant = 0;
        _contentLeadingConstraint.constant = 0;
        _contentTrailingConstraint.constant = 0;
        _contentBottomConstraint.constant = 0;
        
        _tableTopConstraint.constant = 0;
    } else {
        _contentTopConstraint.constant = 92;
        _contentLeadingConstraint.constant = 24;
        _contentTrailingConstraint.constant = 24;
        _contentBottomConstraint.constant = 174;
        
        _tableTopConstraint.constant = 72;
    }
}

#pragma mark - Publics

- (void)show {
    if (_fullMode) {
        return;
    }
    
    UIWindow *win = [ClockSettingView alertWindow];
    
    [win addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self fadeIn];
}

- (void)dismiss {
    if (_fullMode) {
        return;
    }
    
    [[ClockManager sharedManager] saveSettings];
    [[BlueToothHelper sharedInstance] syncClocks];
    
    [self fadeOut];
}

#pragma mark - Privates

- (void)fadeIn {
    self.transform = CGAffineTransformMakeTranslation(0, 0);
    self.alpha = 0;
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.transform = CGAffineTransformIdentity;
                         self.alpha = 1;
                     }];
}

- (void)fadeOut {
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:.25 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, 0);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        [ClockSettingView purgerAlertWindow];
        
        if (weakSelf.dismissBlock) {
            weakSelf.dismissBlock();
        }
    }];
}

- (IBAction)addNewClock:(UIButton *)sender {
    for (int i = 0; i < _editingStates.count; i++) {
        _editingStates[i] = @NO;
    }
    
    ClockData *data = [ClockData clockData];
    NSMutableArray *clocks = [ClockManager sharedManager].clocks;
    [clocks addObject:data];
    [_editingStates addObject:@YES];
    _expandSection = clocks.count - 1;
    
    [_tableView reloadData];
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_expandSection]
                      atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    if (clocks.count == 5) {
        sender.hidden = YES;
    }
}

- (IBAction)dismiss:(id)sender {
    [self dismiss];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [ClockManager sharedManager].clocks.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _expandSection == section;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClockSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    
    cell.section = indexPath.section;
    cell.delegate = self;
    
    ClockData *data = [[ClockManager sharedManager].clocks objectAtIndex:indexPath.section];
    cell.time = data.time;
    cell.repeatDay = data.repeatDay;
    [cell updateTimePicker];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ClockSettingTableHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:_headerIdentifier];
    header.delegate = self;
    header.section = section;
    
    ClockData *data = [[ClockManager sharedManager].clocks objectAtIndex:section];
    header.timeLabel.text = data.time;
    header.repeatDayLabel.text = data.repeatDayDescription;
    header.clockEnabled = data.enabled;
    
    header.editing = [_editingStates[section] boolValue];
    
    return header;
}

#pragma mark - ClockSettingTableHeaderDelegate

- (void)expandClockSettingAtSection:(NSInteger)section {
    if (_expandSection == section) {
        _expandSection = -1;
    } else {
        _expandSection = section;
    }
    
    _editingStates[section] = @NO;
    
    [_tableView reloadData];
}

- (void)enableClockAtSection:(NSInteger)section {
    ClockData *data = [[ClockManager sharedManager].clocks objectAtIndex:section];
    data.enabled = !data.enabled;
    
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:section]
              withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)deleteClockAtSection:(NSInteger)section {
    ClockManager *clockManager = [ClockManager sharedManager];
    [clockManager.clocks removeObjectAtIndex:section];
    [_editingStates removeObjectAtIndex:section];
    
    if (section == _expandSection) {
        _expandSection = -1;
    }
    
    _addClockButton.hidden = NO;
    
    [_tableView reloadData];
}

- (void)saveClockAtSection:(NSInteger)section {
    _editingStates[section] = @NO;
    [[ClockManager sharedManager] saveSettings];
    
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:section]
              withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - ClockSettingTableViewCellDelegate

- (void)didChangeTime:(NSString *)time inSection:(NSInteger)section {
    ClockData *data = [[ClockManager sharedManager].clocks objectAtIndex:section];
    data.time = time;
}

- (void)updateRepeatDay:(ClockRepeatDay)repeatDay append:(BOOL)append inSection:(NSInteger)section {
    ClockData *data = [[ClockManager sharedManager].clocks objectAtIndex:section];
    if (append) {
        [data repeatDayAppend:repeatDay];
    } else {
        [data repeatDaySubtract:repeatDay];
    }
    
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:section]
              withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
