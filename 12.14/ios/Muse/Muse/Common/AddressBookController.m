//
//  AddressBookController.m
//  Muse
//
//  Created by jiangqin on 16/4/16.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "AddressBookController.h"
#import "AppDelegate.h"
#import "MSRequestFindcontacts.h"
#import "SectionTitleTableViewCell.h"
#import "AddressTableViewCell.h"

#import "UIColor+FastKit.h"
#import "DBManager+Contacts.h"

@interface AddressBookController () <UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate,UISearchControllerDelegate,UIScrollViewDelegate> {
    NSString *_cellIdentifier;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *initials;
@property (strong, nonatomic) NSMutableDictionary *contacts;

@property NSMutableArray *initials_muse; // 仅存放 muse 用户
@property NSMutableDictionary *contacts_muse; //  仅存放 muse 用户

@property (strong, nonatomic) NSMutableArray<AddressPerson *> *selectedPersons;

@property (strong, nonatomic) NSArray *searchPersons;

@property (weak, nonatomic) MBProgressHUD *hud;

@property IBOutlet UISearchBar *searchBar;

@end

@implementation AddressBookController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _limitedCount = -1;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupHeaderView:ControllerHeaderTypeAddress];//ControllerHeaderTypeDefault
    [self.headerView.confirmButton addTarget:self action:@selector(confirmSelection:) forControlEvents:UIControlEventTouchUpInside];
    self.headerView.noConnectionImageView.hidden = YES;
    
    _tableView.tableFooterView = [UIView new];
    _cellIdentifier = @"ContactsCell";
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:_cellIdentifier];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, .5, .5)];
    _tableView.tintColor = [UIColor colorWithHex:0x505050];
    _tableView.backgroundColor = [UIColor colorWithHex:0xebebeb];
    
    if (_persons) {
        _selectedPersons = [NSMutableArray arrayWithArray:_persons];
    } else {
        _selectedPersons = [NSMutableArray array];
    }
    
    self.searchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc]init];
    [self.searchDisplayController.searchResultsTableView setRowHeight:self.tableView.rowHeight];
    
    
    _initials_muse = [[NSMutableArray alloc] init];
    _contacts_muse = [[NSMutableDictionary alloc] init];
    
    _searchBar.placeholder = NSLocalizedString(@"searchcontact", nil);
    
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [header setTitle:NSLocalizedString(@"Pull down to refresh", nil) forState:MJRefreshStateIdle];
    [header setTitle:NSLocalizedString(@"Release to refresh", nil) forState:MJRefreshStatePulling];
    [header setTitle:NSLocalizedString(@"Loading ...", nil) forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    self.tableView.mj_header = header;
    
}

- (void)loadNewData {
    self.hud = [MBProgressHUD showHUDWithMessage:NSLocalizedString(@"getContact", nil) toView:self.view];
    
    [[AddressBookManager sharedInstance] refreshPersonWithCompletion:^(NSString *err) {
        [self.hud hide:YES];
        [self getContactWithAppear];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:EnterAddressBookKey];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
    [kNotificationCenter postNotificationName:Notify_AddCantactShow object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self getContactWithAppear];
}

- (void)getContactWithAppear {
    self.hud = [MBProgressHUD showHUDWithMessage:NSLocalizedString(@"getContact", nil) toView:self.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AddressBookManager *manager = [AddressBookManager sharedInstance];
        [manager loadPersonWithCompletion:^(NSString *err) {
            
            if (err) {
                [MBProgressHUD showError:err toView:self.view];
                [self.hud hide:YES];
                [_tableView.mj_header endRefreshing];
            } else {
                self.contacts = manager.addressBook;
                self.initials = [[[self.contacts allKeys] sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
                [self fetchMuseUserInContacts];
                
                
            }
        }];
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:EnterAddressBookKey];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [kNotificationCenter postNotificationName:Notify_AddCantactHide object:nil];
    
}


#pragma mark - Private

- (void)fetchMuseUserInContacts {
    NSMutableString *phones = [NSMutableString string];
    
    for (NSString *initial in _initials) {
        NSArray *persons = _contacts[initial];
        for (AddressPerson *person in persons) {
            [phones appendFormat:@"%@,", person.phone];
        }
    }
    
    if (phones.length < 1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hud hide:YES];
            [_tableView.mj_header endRefreshing];
        });
        return;
    }
    
    NSString *phonesPara = [[[[phones substringToIndex:phones.length - 1] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"+" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];

    MSRequestFindContacts *req = [[MSRequestFindContacts alloc] initWithPhones:phonesPara];
    [req startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
        if (MSRequestIsSuccess(responseData)) {
            NSArray *data = MSResponseData(responseData);
            
            for (NSDictionary *personInfo in data) {
                BOOL pairNext = NO;
                NSString *phone = [NSString stringWithFormat:@"%@", personInfo[@"phone"]];
                

                for (NSString *initial in _initials) {
                    // 姓氏开头筛选
                    NSMutableArray *persons = _contacts[initial];
                    
                    
                    AddressPerson *musePerson = nil;
                    for (AddressPerson *person in persons) {
                        if ([person.phone isEqualToString:phone]) {
                            person.isMuseUser = YES;
                            pairNext = YES;
                            musePerson = person;
                        
                            break;
                        }
                    }
                    
                    //更新数据库
                    if (musePerson) {
                        [[DBManager sharedManager] addPerson:musePerson];
                    }
                    
                    if (pairNext) {
                        break;
                    }
                }
            }
            
            if (_isShowMuseUser == YES) {

                for (NSString *initial in _initials) {
                    // 姓氏开头筛选
                    NSMutableArray *persons = _contacts[initial];
                    
                    NSMutableArray *tempArr = [[NSMutableArray alloc] init];

                    
                    // 号码筛选
                    for (AddressPerson *person in persons) {
                        
                        for (NSDictionary *personInfo in data) {
                            // 拿服务器Muse用户的手机号码
                            NSString *phone = [NSString stringWithFormat:@"%@", personInfo[@"phone"]];
                        
                        if ([person.phone containsString:phone]) {
                            
                            // 单独显示 muse 用户存放一组数据
                                [tempArr addObject:person];
                                [_contacts_muse setObject:tempArr forKey:initial];
                                if (![_initials_muse containsObject:initial]) {
                                    [_initials_muse addObject:initial];
                                }
                            
//                            break;
                        }
                        }
                    }
                  
                }
                
              
        
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.hud hide:YES];
                [_tableView.mj_header endRefreshing];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.hud hide:YES];
                [_tableView.mj_header endRefreshing];
            });
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView.mj_header endRefreshing];
            [self.hud hide:YES];
            
        });

    }];
}

- (void)confirmSelection:(id)sender {
    if(_completionBlock) {
        _completionBlock(_selectedPersons);
        _completionBlock = nil;
    }
    
    [self backToLastController:nil];
}

- (void)selectPerson:(AddressPerson *)person {
    
   
    
    if (_onlySelectMuseUser && !person.isMuseUser) {
       // [MBProgressHUD showHUDWithMessageOnly:@"ta还不是muse用户，只有muse用户才能操作哦"];
         [MBProgressHUD showHUDWithMessageOnly:@"不是MuseHeart用户"];
        return;
    }
    
    BOOL isAdded = NO;
    AddressPerson *personToRemove;
    for (AddressPerson *personAdded in _selectedPersons) {
        if ([personAdded.phone isEqualToString:person.phone]) {
            isAdded = YES;
            personToRemove = personAdded;
            break;
        }
    }
    
    if (isAdded) {
        [_selectedPersons removeObject:personToRemove];
    } else {
        if (_selectedPersons.count >= _limitedCount) {
          //  [MBProgressHUD showHUDWithMessageOnly:[NSString stringWithFormat:@"最多只能选择%ld个人哦", (long)_limitedCount]];
           [MBProgressHUD showHUDWithMessageOnly:NSLocalizedString(@"only3person", nil)];
        } else {
            [_selectedPersons addObject:person];
        }
    }
}

#pragma mark - UITableViewDataSource

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I",
             @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R",
             @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#"];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSInteger section = -1;
    
    
    for (NSInteger i = 0; i < (_isShowMuseUser ? _initials_muse.count : _initials.count); i++) {
        if ([title isEqualToString:_isShowMuseUser ? _initials_muse[i] : _initials[i]]) {
            section = i;
            break;
        }
    }
    if (section == -1) {
        section = [tableView indexPathForRowAtPoint:CGPointMake(0, tableView.contentOffset.y + 33)].section;
    }
    
    return section;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(tableView == self.tableView)
        return 33;
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(tableView == self.tableView)
        return 1;
    
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(tableView == self.tableView) {
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0,0, tableView.frame.size.width, 33)];
        v.backgroundColor = [UIColor colorWithHex:0xebebeb];
        
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
        lb.text = _isShowMuseUser ? _initials_muse[section] : _initials[section];
        lb.font = [UIFont systemFontOfSize:20];
        lb.textColor = [UIColor colorWithHex:0xa0a0a0];
        [v addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(v.mas_centerY);
            make.left.equalTo(@21);
        }];
        
        return v;
    }
    
    return nil;
}

//-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//{
//    view.tintColor = [UIColor whiteColor];
//    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
//    [header.textLabel setTextColor:[UIColor colorWithHex:0xa0a0a0]];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView == self.tableView) {
        return _isShowMuseUser ? _initials_muse.count : _initials.count;
    }

    return 1;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(tableView == self.tableView) {
        return _isShowMuseUser ? _initials_muse[section] : _initials[section];
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return _isShowMuseUser ? [_contacts_muse[_initials_muse[section]] count] : [_contacts[_initials[section]] count];
    }

    return self.searchPersons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTableViewCell"];
    if(!cell) {
        cell = [AddressTableViewCell cellFromNib];
    }
    cell.chooseIMV.hidden = YES;
    
    AddressPerson *person;
    if(tableView == self.tableView) {
        
        if (_isShowMuseUser == YES) {
            person = _contacts_muse[_initials_muse[indexPath.section]][indexPath.row];
        } else {
            person = _contacts[_initials[indexPath.section]][indexPath.row];
        }
        
        
    } else {
        person = _searchPersons[indexPath.row];
    }
    
    if(person.avatar) {
        cell.imv.image = person.avatar;
    } else {
        cell.imv.image = [UIImage imageNamed:@"icon_loading_photo"];
    }
    
    
    cell.titleLB.textColor = UIColorHex(0x141414);

//    if (person.isMuseUser) {
//    } else {
//        cell.titleLB.textColor = [UIColor lightGrayColor];
//    }
//    cell.titleLB.textColor = [UIColor lightGrayColor];
    
    cell.titleLB.text = person.name;
    
    for (AddressPerson *selectedPerson in _selectedPersons) {
        if ([person.phone isEqualToString:selectedPerson.phone]) {
            cell.chooseIMV.hidden = NO;
            break;
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AddressPerson *person;
    if(tableView == self.tableView) {
        if (_isShowMuseUser == YES) {
            person = _contacts_muse[_initials_muse[indexPath.section]][indexPath.row];
        } else {
            person = _contacts[_initials[indexPath.section]][indexPath.row];
        }
    } else {
        person = _searchPersons[indexPath.row];
    }
    
    NSLog(@"选择的联系人是: %@", person.phone);
    [self selectPerson:person];
    [tableView reloadData];
    self.headerView.confirmButton.hidden = !_selectedPersons.count;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i < [[_contacts allValues] count]; i++) {
        NSArray *arr = [_contacts allValues][i];
        
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            AddressPerson *person = obj;
            if([person.initial rangeOfString:searchBar.text].location != NSNotFound ||
               [person.name rangeOfString:searchBar.text].location != NSNotFound)
            {
                [temp addObject:obj];
            }
        }];
    }
    
    self.searchPersons = temp;
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self setSearchBarUI:searchBar];
    [self performSelector:@selector(setSearchBarUI:) withObject:searchBar afterDelay:0.01];
    
    self.headerView.hidden = YES;
    
    for (NSLayoutConstraint *cons in self.view.constraints) {
        if(cons.firstItem == searchBar && cons.firstAttribute == NSLayoutAttributeTop) {
            cons.constant = 22;
        }
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.headerView.hidden = NO;
    
    for (NSLayoutConstraint *cons in self.view.constraints) {
        if(cons.firstItem == searchBar && cons.firstAttribute == NSLayoutAttributeTop) {
            cons.constant = 118;
        }
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UISearchControllerDelegate

- (void) searchDisplayControllerWillEndSearch:(UISearchController *)controller {
    self.headerView.hidden = NO;
    
    for (NSLayoutConstraint *cons in self.view.constraints) {
        if(cons.firstItem == controller.searchBar && cons.firstAttribute == NSLayoutAttributeTop)
        {
            cons.constant = 118;
        }
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.001);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        
        for (UIView *subview in self.searchDisplayController.searchResultsTableView.subviews) {
            if ([subview isKindOfClass:[UILabel class]] && [[(UILabel *)subview text] isEqualToString:@"No Results"]) {
                UILabel *label = (UILabel *)subview;
                
                label.text = NSLocalizedString(@"noresult", nil);
                label.textColor = [UIColor colorWithHex:0xa0a0a0];
                label.font = [UIFont systemFontOfSize:40];
                label.frame = CGRectMake(label.frame.origin.x, self.view.frame.size.height - 355, label.frame.size.width, label.frame.size.height);
                
                break;
            }
        }
        
    });
    
    return YES;
}

#pragma mark - private

- (void)setSearchBarUI:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
    for(UIView * cc in [[searchBar subviews][0]subviews]) {
        if([cc isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)cc;
            
            [btn setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
//            [btn setTitleColor:[UIColor colorWithHex:0x141414] forState:UIControlStateNormal|UIControlStateHighlighted|UIControlStateDisabled|UIControlStateSelected|UIControlStateFocused|UIControlStateApplication|UIControlStateReserved];
            [btn setTitleColor:[UIColor colorWithHex:0x141414] forState:UIControlStateNormal|UIControlStateHighlighted|UIControlStateDisabled|UIControlStateSelected|UIControlStateApplication|UIControlStateReserved];
            [btn setTintColor:[UIColor colorWithHex:0x141414]];
            btn.titleLabel.textColor = [UIColor colorWithHex:0x141414];
        }
    }
}

#pragma mark - UIScrollViewDelegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if(scrollView == self.searchDisplayController.searchResultsTableView)
//    {
//        self.searchDisplayController can
//        [self.searchDisplayController.searchBar resignFirstResponder];
//    }
//}

@end
